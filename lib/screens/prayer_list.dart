import 'package:flutter/material.dart';
import 'package:amazon_like_filter/amazon_like_filter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qleedo/models/Prayer.dart';
import 'package:qleedo/index.dart';
import 'package:qleedo/screens/html_view_inapp.dart';
import 'package:qleedo/screens/html_view_web.dart';
import 'package:qleedo/service/webservices_call.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PryerList extends StatefulWidget {
  static const routeName = '\PrayerList';

  const PryerList({Key? key}) : super(key: key);

  @override
  PrayerPageState createState() => PrayerPageState();
}

class PrayerPageState extends State<PryerList> with SingleTickerProviderStateMixin {
  List<Prayers> prayerList = [];
  PrayerProperties properties = PrayerProperties.empty();
  List<int> languageFilter = [];
  List<int> collectionFilter = [];
  List<int> translationFilter = [];
  List<int> daysFilter = [];
  List<int> hoursFilter = [];
  String queryParameter = "";
  int pageOffset = 0;
  String currentPage = "limit=$pageSize&offset=0";
  bool isLoading = true;
  
  final searchController = TextEditingController();
  final PagingController<int, Prayers> pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) {
      getPrayerList(queryParameter, pageKey);
    });
    getPrayerPropertyList();
  }
  
  @override
  void dispose() {
    searchController.dispose();
    pagingController.dispose();
    super.dispose();
  }

  Future<void> getPrayerList(String queryParam, int pageKey) async {
    try {
      var paramsUrl = queryParam.isNotEmpty ? "$queryParam&$currentPage" : currentPage;
      WebService service = WebService();
      Map<String, String> headers = {"accept": "application/json"};
      
      final response = await service.getResponse("$prayerListApi?$paramsUrl", headers);
      Map<String, dynamic> jsonData = response;
      var status = jsonData[statusKey];
      
      if (pageKey == 0) {
        pagingController.itemList = [];
      }
      
      if (status == 200) {
        var festList = jsonData[dataKey][reslutsKey];
        var nextLocal = jsonData[dataKey][nextKey] ?? "";
        
        var nextPage = nextLocal.isNotEmpty ? nextLocal.replaceAll(qleedoAPIUrl + prayerListApi, '') : '';
        var list = (festList as List).map((data) => Prayers.fromJson(data)).toList();

        if (nextPage.isEmpty) {
          pagingController.appendLastPage(list);
        } else {
          currentPage = nextPage;
          final nextPageKey = pageKey + list.length;
          pagingController.appendPage(list, nextPageKey);
        }
      } else if (status == 204) {
        pagingController.itemList = [];
        setState(() {
          prayerList = [];
        });
      }
    } catch (error) {
      pagingController.error = error;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getPrayerPropertyList() async {
    WebService service = WebService();
    Map<String, String> headers = {"accept": "application/json"};
    
    try {
      final response = await service.getResponse(prayerSacramentPropertiesAPi, headers);
      Map<String, dynamic> jsonData = response;
      var status = jsonData[statusKey];
      
      if (status == 200) {
        var data = PrayerProperties.fromJson(jsonData);
        setState(() {
          properties = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching prayer properties: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      queryParameter = "search=$query&";
    } else {
      queryParameter = "";
    }
    currentPage = "limit=$pageSize&offset=0";
    getPrayerList(queryParameter, 0);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: themeData.isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeData.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: themeData.isDarkMode ? Colors.white : const Color(0xFF4E1208),
              size: 28,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Prayers",
          style: TextStyle(
            color: themeData.isDarkMode ? Colors.white : const Color(0xFF4E1208),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: themeData.isDarkMode ? Colors.white : const Color(0xFF4E1208),
              size: 28,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PrayerSearchDelegate(themeData, (query) => _performSearch(query)),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4E1208),
              ),
            )
          : Column(
              children: [
                // Featured prayer card
                if (pagingController.itemList != null && pagingController.itemList!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildFeaturedPrayer(
                      pagingController.itemList!.first,
                      themeData,
                      size,
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0),
                
                // Prayer list
                Expanded(
                  child: RefreshIndicator(
                    color: const Color(0xFF4E1208),
                    onRefresh: () async {
                      pagingController.refresh();
                    },
                    child: pagingController.itemList == null || pagingController.itemList!.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 72,
                                  color: themeData.isDarkMode ? Colors.grey[400] : Colors.grey[500],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No prayers found",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: themeData.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : PagedListView<int, Prayers>(
                            pagingController: pagingController,
                            builderDelegate: PagedChildBuilderDelegate<Prayers>(
                              itemBuilder: (context, item, index) {
                                // Skip the first item as it's displayed as featured
                                if (index == 0) return const SizedBox();
                                return _buildPrayerItem(item, themeData, index);
                              },
                              firstPageErrorIndicatorBuilder: (_) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline_rounded,
                                      size: 48,
                                      color: Colors.red[300],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Failed to load prayers",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: themeData.textColor,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => pagingController.refresh(),
                                      child: const Text("Retry"),
                                    ),
                                  ],
                                ),
                              ),
                              noItemsFoundIndicatorBuilder: (_) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      size: 72,
                                      color: themeData.isDarkMode ? Colors.grey[400] : Colors.grey[500],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "No prayers found",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: themeData.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
      floatingActionButton: properties.modelList.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showFilterBottomSheet(context),
              backgroundColor: const Color(0xFF4E1208),
              elevation: 4,
              child: const Icon(
                Icons.filter_list_rounded,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  Widget _buildFeaturedPrayer(Prayers prayer, ThemeConfiguration themeData, Size size) {
    return GestureDetector(
      onTap: () => prayerClickAction(prayer),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4E1208),
              const Color(0xFF6E2218),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Featured",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.bookmark_border_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                prayer.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                prayer.properties,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    "Read now",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerItem(Prayers prayer, ThemeConfiguration themeData, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => prayerClickAction(prayer),
        child: Container(
          decoration: BoxDecoration(
            color: themeData.isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4E1208).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      prayer.name.substring(0, 1),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4E1208),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prayer.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: themeData.isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        prayer.properties,
                        style: TextStyle(
                          fontSize: 13,
                          color: themeData.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: themeData.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: (50 * index).ms).slideX(begin: 0.2, end: 0);
  }

  void _showFilterBottomSheet(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: themeData.isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 6,
                width: 40,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      "Filter Prayers",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeData.isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        resetAllFilters();
                        createFilterParameter();
                        currentPage = "limit=$pageSize&offset=0";
                        getPrayerList(queryParameter, 0);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Reset",
                        style: TextStyle(
                          color: Color(0xFF4E1208),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FilterWidget(
                  filterProps: FilterProps(
                    title: "",
                    themeProps: ThemeProps(
                      checkBoxTileThemeProps: CheckBoxTileThemeProps(
                        activeCheckBoxColor: const Color(0xFF4E1208),
                      ),
                      dividerThickness: 1,
                      searchBarViewProps: SearchBarViewProps(
                        filled: true,
                        fillColor: themeData.isDarkMode ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5),
                      ),
                    ),
                    onFilterChange: (value) {
                      Navigator.pop(context);
                      filterApply(value);
                    },
                    filters: properties.modelList.isNotEmpty ? filterList() : Container(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  filterList() {
    return properties.modelList;
  }

  void filterApply(value) {
    if (value.isNotEmpty) {
      resetAllFilters();
      int index = 0;
      for (var filter in value) {
        FilterListModel data = properties.modelList[index];
        if (filter.filterTitle == data.title) {
          if (filter.applied.isNotEmpty) {
            if (filter.filterTitle == languageTitle) {
              addToLanguageFilter(filter.applied);
            } else if (filter.filterTitle == collectionTitle) {
              addToCollectionFilter(filter.applied);
            } else if (filter.filterTitle == translationTitle) {
              addToTranslationFilter(filter.applied);
            } else if (filter.filterTitle == daysTitle) {
              addToDaysFilter(filter.applied);
            } else if (filter.filterTitle == hoursTitle) {
              addToHoursFilter(filter.applied);
            }

            properties.modelList[index] = data.copyWith(previousApplied: filter.applied);
          } else {
            if (filter.filterTitle == languageTitle) {
              languageFilter = [];
            } else if (filter.filterTitle == collectionTitle) {
              collectionFilter = [];
            } else if (filter.filterTitle == translationTitle) {
              translationFilter = [];
            } else if (filter.filterTitle == daysTitle) {
              daysFilter = [];
            } else if (filter.filterTitle == hoursTitle) {
              hoursFilter = [];
            }
            properties.modelList[index] = data.copyWith(previousApplied: []);
          }
        }
        index++;
      }
    } else {
      int index = 0;
      for (FilterListModel filter in properties.modelList) {
        properties.modelList[index] = filter.copyWith(previousApplied: []);
        index++;
      }
      resetAllFilters();
    }

    createFilterParameter();
    currentPage = "limit=$pageSize&offset=0";
    getPrayerList(queryParameter, 0);
  }

  void addToLanguageFilter(dataList) {
    for (FilterItemModel item in dataList) {
      languageFilter.add(int.parse(item.filterKey));
    }
  }

  void addToTranslationFilter(dataList) {
    for (FilterItemModel item in dataList) {
      translationFilter.add(int.parse(item.filterKey));
    }
  }

  void addToCollectionFilter(dataList) {
    for (FilterItemModel item in dataList) {
      collectionFilter.add(int.parse(item.filterKey));
    }
  }

  void addToHoursFilter(dataList) {
    for (FilterItemModel item in dataList) {
      hoursFilter.add(int.parse(item.filterKey));
    }
  }

  void addToDaysFilter(dataList) {
    for (FilterItemModel item in dataList) {
      daysFilter.add(int.parse(item.filterKey));
    }
  }

  void resetAllFilters() {
    languageFilter = [];
    collectionFilter = [];
    translationFilter = [];
    daysFilter = [];
    hoursFilter = [];
  }

  void createFilterParameter() {
    queryParameter = "";
    if (languageFilter.isNotEmpty) {
      queryParameter = "language__in=${languageFilter.join(",")}&";
    }
    if (collectionFilter.isNotEmpty) {
      queryParameter += "prayer__prayer_subcollection__in=${collectionFilter.join(",")}&";
    }
    if (translationFilter.isNotEmpty) {
      queryParameter += "prayer__translation__in=${translationFilter.join(",")}&";
    }
    if (hoursFilter.isNotEmpty) {
      queryParameter += "prayer__hour__in=${hoursFilter.join(",")}&";
    }
    if (daysFilter.isNotEmpty) {
      queryParameter += "prayer__day__in=${daysFilter.join(",")}&";
    }
  }

  void prayerClickAction(Prayers prayer) {
    if (kIsWeb) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HtmlViewWeb(
            name: prayer.name,
            objectID: prayer.id.toString(),
            pageType: 'PR',
            collectionName: "Prayer",
            htmlurl: "",
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HtmlViewInApp(
            name: prayer.name,
            objectID: prayer.id.toString(),
            pageType: 'PL',
            collectionName: "",
            htmlurl: "",
          ),
        ),
      );
    }
  }
}

// Custom search delegate for prayers
class PrayerSearchDelegate extends SearchDelegate<String> {
  final ThemeConfiguration themeData;
  final Function(String) onSearch;

  PrayerSearchDelegate(this.themeData, this.onSearch);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: themeData.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: themeData.isDarkMode ? Colors.grey[400] : Colors.grey[500],
        ),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: themeData.isDarkMode ? Colors.white : Colors.black87,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
        color: themeData.isDarkMode ? Colors.white : const Color(0xFF4E1208),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
      color: themeData.isDarkMode ? Colors.white : const Color(0xFF4E1208),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: themeData.isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F7FA),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: themeData.isDarkMode ? Colors.grey[700] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "Search for prayers",
              style: TextStyle(
                fontSize: 18,
                color: themeData.isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}