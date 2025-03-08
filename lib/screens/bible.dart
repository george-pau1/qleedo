import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/userbible.dart';
import '../widgets/drawer.dart';
import 'package:qleedo/index.dart';

class BiblePage extends StatefulWidget {
  static const String routeName = '/bible';

  @override
  _BiblePageState createState() => _BiblePageState();
}

enum TtsState { playing, stopped, paused, continued }

class _BiblePageState extends State<BiblePage> with TickerProviderStateMixin {
  final scrollDirection = Axis.vertical;
  late AutoScrollController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Bible data
  List<String> _bibleNames = [];
  List<String> _bibleChapters = [];
  List<dynamic> _bibleVerse = [];
  List<String> _selectedBibleChapters = [];
  var _selectedBible = 'Genesis';
  var _selectedBibleIndex = 1;
  var _selectedChapter = 1;
  var _selectedVerse = 1;
  var _selectedVerseMax = 1;
  var _selectedBibleFile = 'assets/bible/eng/1/1.json';
  var _fontSize = 18.0;
  var selectedLanguage = 'eng';
  var currentPage = 1;
  var previousPage = 1;
  var bibleCurrentChapter = {};
  var _isFirst = true;
  var _isLoading = true;
  
  // UI state
  bool _showControls = true;
  bool _showSettings = false;
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  
  // Text to Speech
  late FlutterTts flutterTts;
  bool isPlayingBible = false;
  bool isPlayDisplay = true;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  TtsState ttsState = TtsState.stopped;

  bool get isPlaying => ttsState == TtsState.playing;
  bool get isStopped => ttsState == TtsState.stopped;
  bool get isPaused => ttsState == TtsState.paused;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );
    
    // Initialize TTS
    initTts();
    
    // Initialize scroll controller
    controller = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: scrollDirection
    );
    
    // Get saved Bible state
    Future.delayed(Duration.zero, () {
      ThemeConfiguration theme = Provider.of<ThemeConfiguration>(context, listen: false);
      
      _selectedBibleIndex = theme.bible.name ?? 1;
      _selectedChapter = theme.bible.chapter ?? 1;
      _selectedVerse = theme.bible.verse ?? 1;
      _selectedBibleIndex = _selectedBibleIndex == 0 ? 1 : _selectedBibleIndex;
      _selectedChapter = _selectedChapter == 0 ? 1 : _selectedChapter;
      _selectedVerse = _selectedVerse == 0 ? 1 : _selectedVerse;
      _selectedBibleFile = 'assets/bible/eng/$_selectedBibleIndex/$_selectedChapter.json';
      _pageController = PageController(initialPage: _selectedChapter - 1);
    });
    
    // Setup scroll listener for showing/hiding controls
    controller.addListener(_handleScroll);
  }

  void _navigateTo(BuildContext context, String routeName) {
  Navigator.pushNamed(context, routeName);
  }

  void _handleScroll() {
  if (controller.hasClients) { // Ensure controller is attached
    ScrollDirection direction = controller.position.userScrollDirection; // Corrected reference
    
    if (direction == ScrollDirection.reverse && _showControls) {
      setState(() {
        _showControls = false;
        _fabAnimationController.reverse();
      });
    } else if (direction == ScrollDirection.forward && !_showControls) {
      setState(() {
        _showControls = true;
        _fabAnimationController.forward();
      });
    }
  }
}

  void _goToNextChapter() {
    var currPage = (_pageController.page?.toInt() ?? 0) + 1;
    if (currPage >= _selectedBibleChapters.length) {
      currPage = 0;
    }
    
    setState(() {
      currentPage = currPage + 1;
      _selectedChapter = currPage + 1;
      _selectedVerse = 1;
      _selectedBibleFile = 'assets/bible/$selectedLanguage/$_selectedBibleIndex/$currentPage.json';
      previousPage = currPage + 1;
    });
    
    _pageController.animateToPage(
      currPage,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  void _goToPreviousChapter() {
    var currPage = (_pageController.page?.toInt() ?? 0) - 1;
    if (currPage < 0) {
      currPage = _selectedBibleChapters.length - 1;
    }
    
    setState(() {
      currentPage = currPage + 1;
      _selectedChapter = currPage + 1;
      _selectedVerse = 1;
      _selectedBibleFile = 'assets/bible/$selectedLanguage/$_selectedBibleIndex/$currentPage.json';
      previousPage = currPage + 1;
    });
    
    _pageController.animateToPage(
      currPage,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  // TTS Functions
  initTts() {
    flutterTts = FlutterTts();
    
    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      if (ttsState != TtsState.stopped) {
        setState(() {
          ttsState = TtsState.playing;
          isPlayingBible = true;
        });
      }
    });

    flutterTts.setCompletionHandler(() {
      if (ttsState != TtsState.stopped) {
        setState(() {
          ttsState = TtsState.stopped;
          _selectedVerse = _selectedVerse + 1;
        });
        playContent();
        _scrollToIndex();
      }
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
        isPlayingBible = false;
      });
    });
  }

  Future<dynamic> _getEngines() => flutterTts.getEngines;

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _speak(String speechText) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (speechText.isNotEmpty) {
      var result = await flutterTts.speak(speechText);
      if (result == 1) setState(() => ttsState = TtsState.playing);
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  void playContent() {
    var key = (_selectedVerse).toString();
    if (bibleCurrentChapter.containsKey(key)) {
      var rowData = bibleCurrentChapter[key]['verse'];
      _speak(rowData);
    } else {
      // End of verses, move to next chapter
      setState(() {
        isPlayingBible = false;
      });
    }
  }

  void togglePlayBibleContent() {
    if (isPlayingBible) {
      _stop();
      setState(() {
        isPlayingBible = false;
      });
    } else {
      setState(() {
        isPlayingBible = true;
      });
      playContent();
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    flutterTts.stop();
    _fabAnimationController.dispose();
    controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isFirst) {
      setState(() {
        _isLoading = true;
      });
      loadBibleData();
    }
    super.didChangeDependencies();
  }

  // Bible data loading functions
  Future<String> _loadBibleIndex() async {
    return await rootBundle.loadString('assets/bible/JsonBibile.json');
  }

  void loadChapter(int count, String type) {
    List<String> _localBibleCount = [];
    for (int i = 1; i <= count; i++) {
      _localBibleCount.add(i.toString());
    }

    setState(() {
      if (type == 'C') _selectedBibleChapters = _localBibleCount;
    });
  }

  Future _scrollToIndex() async {
    await controller.scrollToIndex(_selectedVerse);
    controller.highlight(_selectedVerse);
  }

  Future<void> loadBibleData() async {
    List<String> names = [];
    List<String> chapters = [];
    List<dynamic> verses = [];
    
    String jsonData = await _loadBibleIndex();
    final parsed = json.decode(jsonData) as List;
    
    parsed.forEach((bible) {
      names.add(bible['name'] as String);
      chapters.add(bible['chapter'] as String);
      verses.add(bible['verses']);
    });

    var verseCounting = verses[0][0];

    setState(() {
      _bibleNames = names;
      _bibleChapters = chapters;
      _bibleVerse = verses;
      _selectedVerseMax = verseCounting;
      _isFirst = false;
      _isLoading = false;
    });
    
    loadChapter(int.parse(chapters[0]), 'C');
  }

  Future<Object> _loadAssets(String bibleUrlPath) async {
    return await rootBundle.loadString(bibleUrlPath);
  }

  void showBibleSelector(BuildContext context, String type) {
    List<String> options = type == 'book' 
        ? _bibleNames 
        : type == 'chapter' 
            ? _selectedBibleChapters 
            : List.generate(_selectedVerseMax, (i) => (i + 1).toString());
            
    int initialIndex = type == 'book' 
        ? _selectedBibleIndex - 1 
        : type == 'chapter' 
            ? _selectedChapter - 1 
            : _selectedVerse - 1;
    
    final theme = Theme.of(context);
    final themeConfig = Provider.of<ThemeConfiguration>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16))
      ),
      builder: (context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select ${type.substring(0, 1).toUpperCase() + type.substring(1)}',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        options[index],
                        style: TextStyle(
                          color: index == initialIndex ? theme.primaryColor : themeConfig.textColor,
                          fontWeight: index == initialIndex ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _handleSelectionChange(type, index, options[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSelectionChange(String type, int selectedIndex, String selectedValue) {
    if (type == 'book') {
      setState(() {
        _selectedBible = selectedValue;
        _selectedBibleIndex = selectedIndex + 1;
        _selectedBibleFile = 'assets/bible/$selectedLanguage/${selectedIndex + 1}/$_selectedChapter.json';
      });
    } else if (type == 'chapter') {
      var index = int.parse(selectedValue);
      var verseCount = _bibleVerse[_selectedBibleIndex - 1][index - 1];
      
      setState(() {
        _selectedChapter = index;
        _selectedVerseMax = verseCount;
        _selectedBibleFile = 'assets/bible/$selectedLanguage/$_selectedBibleIndex/$index.json';
      });
      
      _pageController.jumpToPage(index - 1);
    } else if (type == 'verse') {
      setState(() {
        _selectedVerse = int.parse(selectedValue);
      });
      _scrollToIndex();
    }
  }

  void _showSettingsSheet(BuildContext context) {
    final theme = Theme.of(context);
    final themeConfig = Provider.of<ThemeConfiguration>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16))
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings', style: theme.textTheme.titleLarge),
                  SizedBox(height: 24),
                  
                  Text('Font Size', style: theme.textTheme.titleMedium),
                  Slider(
                    value: _fontSize,
                    min: 12,
                    max: 32,
                    divisions: 10,
                    label: _fontSize.round().toString(),
                    onChanged: (value) {
                      setModalState(() {
                        setState(() => _fontSize = value);
                      });
                    },
                  ),
                  
                  SizedBox(height: 16),
                  Text('Language', style: theme.textTheme.titleMedium),
                  SizedBox(height: 8),
                  
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildLanguageChip('English', 'eng', theme),
                      _buildLanguageChip('Malayalam', 'mlm', theme),
                    ],
                  ),
                  
                  if (isPlayDisplay)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text('Speech Rate', style: theme.textTheme.titleMedium),
                      Slider(
                        value: rate,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: rate.toString(),
                        onChanged: (value) {
                          setModalState(() {
                            setState(() => rate = value);
                          });
                        },
                      ),
                      
                      Text('Volume', style: theme.textTheme.titleMedium),
                      Slider(
                        value: volume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: volume.toString(),
                        onChanged: (value) {
                          setModalState(() {
                            setState(() => volume = value);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildLanguageChip(String label, String code, ThemeData theme) {
    final isSelected = selectedLanguage == code;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: theme.primaryColor.withOpacity(0.2),
      checkmarkColor: theme.primaryColor,
      onSelected: (selected) {
        if (selected) {
          var selectBible = _selectedBibleIndex;
          setState(() {
            selectedLanguage = code;
            _selectedBibleFile = 'assets/bible/$code/$selectBible/$_selectedChapter.json';
            isPlayDisplay = code == 'eng';
          });
          
          if (isPlayingBible) _stop();
        }
      },
    );
  }

  void cacheBibleData(BuildContext context) async {
    UserBible bible = UserBible(
      chapter: _selectedChapter, 
      name: _selectedBibleIndex, 
      verse: _selectedVerse, 
      isPlayEnabled: isPlayingBible
    );
    
    await setPrefrenceBible(isUSERLOGINED, bible);
    Provider.of<ThemeConfiguration>(context, listen: false).updateBible(bible);
  }

  Widget _wrapScrollTag({required int index, required Widget child}) => AutoScrollTag(
    key: ValueKey(index),
    controller: controller,
    index: index,
    child: child,
    highlightColor: Colors.black.withOpacity(0.1),
  );

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeData.bgColor,
      appBar: AppBar(
        title: Text('Bible'),
        elevation: 0,
        backgroundColor: themeData.bgColor,
        foregroundColor: themeData.textColor,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _showSettingsSheet(context),
          ),
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () => cacheBibleData(context),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          // Bible navigation bar
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _showControls ? 64 : 0,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => showBibleSelector(context, 'book'),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Book',
                            style: TextStyle(
                              color: themeData.textColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                _selectedBible,
                                style: TextStyle(
                                  color: themeData.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down, color: themeData.textColor),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 32,
                  width: 1,
                  color: themeData.textColor.withOpacity(0.2),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => showBibleSelector(context, 'chapter'),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chapter',
                            style: TextStyle(
                              color: themeData.textColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                _selectedChapter.toString(),
                                style: TextStyle(
                                  color: themeData.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down, color: themeData.textColor),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 32,
                  width: 1,
                  color: themeData.textColor.withOpacity(0.2),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => showBibleSelector(context, 'verse'),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verse',
                            style: TextStyle(
                              color: themeData.textColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                _selectedVerse.toString(),
                                style: TextStyle(
                                  color: themeData.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down, color: themeData.textColor),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bible content
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : FutureBuilder<Object>(
                    future: _loadAssets(_selectedBibleFile),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      
                      if (snapshot.hasError) {
                        return Center(child: Text('Error loading Bible content'));
                      }
                      
                      if (snapshot.data == null) {
                        return Center(child: Text('No content available'));
                      }
                      
                      return GestureDetector(
                        onHorizontalDragEnd: (dragEndDetails) {
                          if (dragEndDetails.primaryVelocity! < 0) {
                            _goToNextChapter();
                          } else if (dragEndDetails.primaryVelocity! > 0) {
                            _goToPreviousChapter();
                          }
                        },
                        child: PageView.builder(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _selectedBibleChapters.length,
                          onPageChanged: (index) {
                            setState(() {
                              _selectedChapter = index + 1;
                              _selectedBibleFile = 'assets/bible/$selectedLanguage/$_selectedBibleIndex/${index + 1}.json';
                              currentPage = index + 1;
                            });
                          },
                          itemBuilder: (context, position) {
                            var jsonDecoder = json.decode(snapshot.data);
                            bibleCurrentChapter = jsonDecoder;
                            
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: ListView.builder(
                                controller: controller,
                                scrollDirection: scrollDirection,
                                itemCount: jsonDecoder.length,
                                itemBuilder: (context, index) {
                                  var key = (index + 1).toString();
                                  if (!jsonDecoder.containsKey(key)) {
                                    return SizedBox.shrink();
                                  }
                                  
                                  return _buildVerseItem(
                                    jsonDecoder[key]['verse'], 
                                    index + 1, 
                                    themeData
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FadeTransition(
        opacity: _fabAnimation,
        child: ScaleTransition(
          scale: _fabAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.small(
                heroTag: "prev",
                backgroundColor: themeData.textColor,
                foregroundColor: themeData.bgColor,
                child: Icon(Icons.arrow_back_ios_rounded, size: 18),
                onPressed: _goToPreviousChapter,
              ),
              SizedBox(height: 8),
              FloatingActionButton(
                heroTag: "play",
                backgroundColor: themeData.textColor,
                foregroundColor: themeData.bgColor,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: Icon(
                    isPlayingBible 
                        ? Icons.pause_rounded 
                        : Icons.play_arrow_rounded,
                    size: 32,
                    key: ValueKey(isPlayingBible),
                  ),
                ),
                onPressed: isPlayDisplay ? togglePlayBibleContent : null,
              ),
              SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: "next",
                backgroundColor: themeData.textColor,
                foregroundColor: themeData.bgColor,
                child: Icon(Icons.arrow_forward_ios_rounded, size: 18),
                onPressed: _goToNextChapter,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerseItem(String text, int index, ThemeConfiguration themeData) {
    final isCurrentVerse = index == _selectedVerse;
    
    return _wrapScrollTag(
      index: index,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isCurrentVerse 
              ? themeData.textColor.withOpacity(0.1) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              margin: EdgeInsets.only(right: 12, top: 2),
              decoration: BoxDecoration(
                color: isCurrentVerse 
                    ? themeData.textColor.withOpacity(0.1) 
                    : themeData.textColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                index.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isCurrentVerse ? FontWeight.bold : FontWeight.normal,
                  color: themeData.textColor.withOpacity(isCurrentVerse ? 1.0 : 0.7),
                ),
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: _fontSize,
                  height: 1.5,
                  color: themeData.textColor,
                  fontWeight: isCurrentVerse ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}