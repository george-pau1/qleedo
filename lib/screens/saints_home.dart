import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qleedo/index.dart' hide SearchBar;
import 'package:qleedo/models/saints.dart';
import 'package:qleedo/screens/saints_details.dart';
import 'package:qleedo/service/webservices_call.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class SaintsList extends StatefulWidget {
  static const routeName = '\SaintsDetails';

  const SaintsList({super.key});

  @override
  _SaintsListState createState() => _SaintsListState();
}

class _SaintsListState extends State<SaintsList> with TickerProviderStateMixin {
  int startingTabCount = 0;
  var isLoading = false;
  List<Saints> saintsList = [];
  List<Saints> searchList = [];
  final searchController = TextEditingController();
  late SearchBar searchBar;
  final GlobalKey key = GlobalKey();
  String queryParameter = "";
  int pageOffset = 0;
  String currentPage = "limit=$pageSize&offset=0";

  final PagingController<int, Saints> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage("", pageKey);
    });
    createSearchWidget();
  }

  _fetchPage(queryParam, int pageKey) async {
    WebService service = WebService();
    var paramsUrl = queryParam != "" ? queryParam : currentPage;
    var urlParams = "$saintsApi?$paramsUrl";
    Map<String, String> headers = {"accept": "application/json"};
    final response = await service.getResponse(urlParams, headers);
    
    Map<String, dynamic> jsonData = response;
    var status = jsonData[statusKey];
    if (pageKey == 0) {
      _pagingController.itemList = [];
    }
    
    if (status == 200) {
      var data = jsonData[dataKey];
      var previousLocal = data[previousKey] ?? "";
      var nextLocal = data[nextKey] ?? "";
      var count = data[countKey] ?? 0;
      
      var previousPage = previousLocal != "" ? previousLocal.replaceAll("$qleedoAPIUrl$saintsApi?", '') : '';
      var nextPage = nextLocal != "" ? nextLocal.replaceAll("$qleedoAPIUrl$saintsApi?", '') : '';
      var saintsLists = data[reslutsKey] as List;
      
      var listData = saintsLists.map((data) => Saints.fromJson(data)).toList();
      
      if (nextPage == "") {
        _pagingController.appendLastPage(listData);
      } else {
        currentPage = nextPage;
        final nextPageKey = pageKey + listData.length;
        _pagingController.appendPage(listData, nextPageKey);
      }
    } else if (status == 204) {
      _pagingController.itemList = [];
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: searchBar.build(context),
      drawer: AppDrawer(),
      body: isLoading
          ? _buildLoadingIndicator(themeData, deviceWidth, deviceHeight)
          : _buildSaintsGrid(themeData),
    );
  }

  Widget _buildLoadingIndicator(ThemeConfiguration themeData, double width, double height) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: themeData.appNavBg,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Loading Saints...",
            style: GoogleFonts.poppins(
              color: themeData.appNavBg,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSaintsGrid(ThemeConfiguration themeData) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Explore Saints",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Discover saints and learn about their lives",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: PagedSliverGrid<int, Saints>(
              pagingController: _pagingController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 20,
                crossAxisCount: 2,
              ),
              builderDelegate: PagedChildBuilderDelegate<Saints>(
                firstPageProgressIndicatorBuilder: (_) => _buildGridPlaceholders(),
                newPageProgressIndicatorBuilder: (_) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator(
                        color: themeData.appNavBg,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (_) => _buildNoResultsFound(),
                itemBuilder: (context, item, index) => AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  columnCount: 2,
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: saintCard(item, themeData, index),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Add bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          Text(
            "No saints found",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try a different search term",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              currentPage = "limit=$pageSize&offset=0";
              _fetchPage("", 0);
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Reset Search"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.grey[800],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridPlaceholders() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        crossAxisCount: 2,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget saintCard(Saints data, ThemeConfiguration themeData, int index) {
    return Hero(
      tag: 'saint-${data.id}',
      child: Material(
        borderRadius: BorderRadius.circular(24),
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () => onSelectSaints(data),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: data.imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[100],
                                  child: const Icon(Icons.image_not_supported_rounded, color: Colors.grey),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.6),
                                    ],
                                    stops: const [0.7, 1.0],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: themeData.appNavBg,
                            ),
                            child: Center(
                              child: Text(
                                data.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.visibility_rounded,
                          color: themeData.appNavBg,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  onSelectSaints(Saints data) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SaintsDetailsView(
          selectedSaints: data,
          type: "D",
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.1);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  createSearchWidget() {
    searchBar = SearchBar(
      inBar: false,
      showClearButton: true,
      closeOnSubmit: false,
      buildDefaultAppBar: buildAppBar,
      setState: setState,
      onSubmitted: onSubmitted,
      onCleared: () {
        currentPage = "limit=$pageSize&offset=0";
        var searchParam = "limit=$pageSize&offset=0";
        _fetchPage(searchParam, 0);
      },
      onClosed: () {
        setState(() {
          searchList = saintsList;
        });
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    return AppBar(
      elevation: 0,
      backgroundColor: themeData.appNavBg.withOpacity(0.95),
      title: Text(
        "Gallery of Saints",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: AppConstants.headingFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [searchBar.getSearchAction(context)],
    );
  }

  onSubmitted(String value) {
    currentPage = "";
    var searchParam = value.isNotEmpty
        ? "limit=$pageSize&offset=0&search=$value"
        : "limit=$pageSize&offset=0";
    _fetchPage(searchParam, 0);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}