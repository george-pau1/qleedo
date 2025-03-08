import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qleedo/models/Media.dart';
//import 'package:qleedo/screens/media_youtube_player.dart';
import 'package:qleedo/index.dart';
import 'package:qleedo/service/webservices_call.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MediaDetailsView extends StatefulWidget {
  static const routeName = '/MEDIASDETAILS';
  final Media selectedMedia;
  final String typeSelected;

  const MediaDetailsView({
    Key? key, 
    required this.selectedMedia, 
    required this.typeSelected
  }) : super(key: key);

  @override
  _MediaDetailsViewState createState() => _MediaDetailsViewState();
}

class _MediaDetailsViewState extends State<MediaDetailsView> with TickerProviderStateMixin {
  bool _isLoading = true;
  MediaDetails _mediaDetails = MediaDetails.initialise();
  int _selectedIndex = 0;
  
  late TabController _tabController;
  final List<Tab> _tabs = [];

  @override
  void initState() {
    super.initState();
    _fetchMediaDetails();
  }

  @override
  void dispose() {
    if (_tabs.isNotEmpty) {
      _tabController.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchMediaDetails() async {
    setState(() => _isLoading = true);
    
    try {
      final String url = "$mediaApi${widget.selectedMedia.id}";
      final WebService service = WebService();
      final Map<String, String> headers = {"accept": "application/json"};
      
      final response = await service.getResponse(url, headers);
      final Map<String, dynamic> jsonData = response;
      
      final int status = jsonData[statusKey];
      
      if (status == 200) {
        final Map<String, dynamic> mediaData = jsonData[dataKey];
        final MediaDetails data = MediaDetails.fromJson(mediaData);
        
        if (data.tabList.isNotEmpty) {
          _buildTabs(data.tabList);
          _tabController = _getTabController();
        }
        
        setState(() {
          _isLoading = false;
          _mediaDetails = data;
        });
      } else {
        setState(() => _isLoading = false);
        _showErrorSnackbar("Failed to load media details");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar("Error: ${e.toString()}");
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onTabChange(int index) {
    setState(() => _selectedIndex = index);
  }

  List<Tab> _buildTabs(List<String> dataList) {
    _tabs.clear();
    for (var data in dataList) {
      _tabs.add(_buildTab(data));
    }
    return _tabs;
  }

  Tab _buildTab(String title) {
    return Tab(
      text: title.toUpperCase(),
    );
  }

  TabController _getTabController() {
    return TabController(length: _tabs.length, vsync: this)
      ..addListener(() => setState(() {}));
  }

  Widget _buildMediaListView(ThemeConfiguration themeData, int index) {
    final String currentTab = _mediaDetails.tabList[index];
    final List<MediaItem> mediaItems = _mediaDetails.mediaDict[currentTab] ?? [];
    
    if (mediaItems.isEmpty) {
      return Center(child: Text('No $currentTab available'));
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: mediaItems.length,
      itemBuilder: (context, position) {
        final MediaItem item = mediaItems[position];
        
        switch (currentTab) {
          case "images":
        //    return _buildImageCard(item.url);
          case "youtube":
      //      return _buildYoutubeCard(item.url);
          default:
        //    return _buildMediaCard(currentTab, item);
        }
      },
    );
  }

  Widget _buildImageCard(String url) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        // child: CachedNetworkImage(
        //   imageUrl: url,
        //   height: 220,
        //   width: double.infinity,
        //   fit: BoxFit.cover,
        //   placeholder: (context, url) => const Center(
        //     child: CircularProgressIndicator(),
        //   ),
        //   errorWidget: (context, url, error) => const Center(
        //     child: Icon(Icons.error, size: 40),
        //   ),
        // ),
      ),
    );
  }

  Widget _buildYoutubeCard(String youtubeUrl) {
    // Extract video ID from URL if needed
   // final String videoId = YoutubePlayer.convertUrlToId(youtubeUrl) ?? youtubeUrl;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
       //   onTap: () => _navigateToYoutubePlayer(videoId),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // CachedNetworkImage(
              //   imageUrl: 'https://img.youtube.com/vi/$videoId/0.jpg',
              //   height: 220,
              //   width: double.infinity,
              //   fit: BoxFit.cover,
              //   placeholder: (context, url) => const Center(
              //     child: CircularProgressIndicator(),
              //   ),
              //   errorWidget: (context, url, error) => Container(
              //     height: 220,
              //     color: Colors.grey[300],
              //     child: const Center(child: Icon(Icons.movie, size: 60)),
              //   ),
              // ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildMediaCard(String type, MediaItem media) {
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     margin: const EdgeInsets.symmetric(vertical: 8),
  //     child: ListTile(
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       leading: Icon(
  //         type == "audio" ? Icons.audiotrack : Icons.video_library,
  //         size: 36,
  //         color: Theme.of(context).primaryColor,
  //       ),
  //       title: Text(
  //         media.title ?? 'Untitled Media',
  //         style: const TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       subtitle: media.description != null 
  //         ? Text(media.description!) 
  //         : null,
  //       trailing: const Icon(Icons.play_circle_filled, size: 36),
  //       onTap: () => _playMedia(media),
  //     ),
  //   );
  // }

  void _navigateToYoutubePlayer(String videoId) {
    // Create a MediasDetails object or whatever your YouTube player expects
    final mediaDetails = MediasDetails(id: videoId, title: widget.selectedMedia.name);
    // Navigator.push(
    //   context
    //   MaterialPageRoute(
    //     builder: (context) => MediaYoutubePlayer(
    //       selectedPlayer: mediaDetails,
    //     ),
    //   ),
    // );
  }

  void _playMedia(MediaItem media) {
    // Implement media playing functionality
    // This would depend on what your MediaItem contains and how you want to play it
  }

  @override
  Widget build(BuildContext context) {
    final ThemeConfiguration themeData = Provider.of<ThemeConfiguration>(context);
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.appNavBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: themeData.appNavTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.selectedMedia.name,
          style: TextStyle(
            color: themeData.appNavTextColor,
            fontSize: AppConstants.headingFontSize,
            fontWeight: AppConstants.fontWeight,
          ),
        ),
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator(color: themeData.appNavBg))
        : Column(
            children: [
              // Tabs Section
              if (_mediaDetails.tabList.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    isScrollable: true,
                    tabs: _tabs,
                    labelColor: themeData.appNavBg,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: themeData.appNavBg,
                    indicatorWeight: 3,
                    labelStyle: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w600, 
                      color: themeData.textColor,
                    ),
                    controller: _tabController,
                    onTap: _onTabChange,
                  ),
                ),
              
              // Content Section
              if (_mediaDetails.tabList.isNotEmpty)
                Expanded(
                  child: _buildMediaListView(themeData, _selectedIndex),
                )
              else
                Expanded(
                  child: Center(
                    child: Text(
                      'No media content available',
                      style: TextStyle(
                        fontSize: 16,
                        color: themeData.textColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
    );
  }
}

// Assuming this class exists or needs to be created
class MediasDetails {
  final String id;
  final String title;
  
  MediasDetails({required this.id, required this.title});
}