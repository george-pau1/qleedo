import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qleedo/screens/html_view_inapp.dart';
import 'package:qleedo/screens/html_view_web.dart';
import 'package:qleedo/index.dart';
import 'package:qleedo/service/webservices_call.dart';
import 'package:amazon_like_filter/amazon_like_filter.dart';

class SacramentList extends StatefulWidget {
  static const routeName = '\SacramentList';

  SacramentList({Key? key}) : super(key: key);

  @override
  _SacramentListPageState createState() => _SacramentListPageState();
}

class _SacramentListPageState extends State<SacramentList>
    with SingleTickerProviderStateMixin {
  List<Sacraments> sacramentList = [];
  SacramentProperties properties = SacramentProperties.empty();
  List<int> languageFilter = [];
  List<int> sacramentTypeFilter = [];
  var isLoading = false;
  String queryParameter = "";
  int pageOffset = 0;
  String currentPage = "limit=$pageSize&offset=0";

  final PagingController<int, Sacraments> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();

    pagingController.addPageRequestListener((pageKey) {
      print("..$queryParameter....page change....444...$pageKey....");
      getSacramentList(queryParameter, pageKey);
    });
    getSacramentPropertyList();
  }

  void getSacramentList(String queryParam, int pageKey) async {
    try {
      WebService service = WebService();
      Map<String, String> headers = {"accept": "application/json"};
      final response = await service.getResponse("$sacramentListApi?$queryParam", headers);

      if (response is! Map<String, dynamic>) {
        print("Unexpected response format: $response");
        setState(() {
          isLoading = false;
        });
        return;
      }

      final status = response[statusKey];
      final data = response[dataKey];

      if (status == 200 && data != null) {
        final results = data[reslutsKey] ?? [];

        if (results is! List) {
          print("Invalid results format: $results");
          setState(() {
            isLoading = false;
          });
          return;
        }

        final list = results.map((item) => Sacraments.fromJson(item)).toList();

        if (pageKey == 0) {
          pagingController.itemList = [];
        }

        setState(() {
          sacramentList.addAll(list);
          isLoading = false;
        });

        final nextLocal = data[nextKey] ?? "";
        if (nextLocal.isEmpty) {
          pagingController.appendLastPage(list);
        } else {
          final nextPageKey = pageKey + list.length;
          pagingController.appendPage(list, nextPageKey);
        }
      } else if (status == 204) {
        pagingController.itemList = [];
        setState(() {
          sacramentList = [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("Error: ${response[messageKey]}");
      }
    } catch (e) {
      print("Error fetching sacrament list: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void getSacramentPropertyList() async {
    try {
      WebService service = WebService();
      Map<String, String> headers = {"accept": "application/json"};
      final response = await service.getResponse(prayerSacramentPropertiesAPi, headers);

      if (response is! Map<String, dynamic>) {
        print("Unexpected response format: $response");
        setState(() {
          isLoading = false;
        });
        return;
      }

      final status = response[statusKey];
      if (status == 200) {
        final data = SacramentProperties.fromJson(response);
        setState(() {
          properties = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("Error fetching properties: ${response[messageKey]}");
      }
    } catch (e) {
      print("Error fetching sacrament properties: $e");
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
      appBar: AppBar(
        backgroundColor: themeData.appNavBg,
        elevation: 4,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu_outlined,
              color: themeData.appNavTextColor,
              size: 28,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Sacraments",
          style: TextStyle(
            color: themeData.appNavTextColor,
            fontSize: AppConstants.headingFontSize,
            fontWeight: AppConstants.fontWeight,
          ),
        ),
        actions: [
          if (properties.modelList.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.filter_alt_outlined,
                color: themeData.appNavTextColor,
                size: 26,
              ),
              onPressed: () => _showFilterBottomSheet(context, themeData),
            ),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xff4e1208),
              ),
            )
          : _buildSacramentsList(themeData),
    );
  }

  Widget _buildSacramentsList(ThemeConfiguration themeData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: PagedListView<int, Sacraments>(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Sacraments>(
          itemBuilder: (context, item, index) => _buildSacramentCard(item, themeData),
          firstPageErrorIndicatorBuilder: (_) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  "Failed to load sacraments",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => pagingController.refresh(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff4e1208),
                  ),
                  child: Text("Retry", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          noItemsFoundIndicatorBuilder: (_) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 48, color: Color(0xff4e1208)),
                SizedBox(height: 16),
                Text(
                  "No sacraments found",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: themeData.listTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSacramentCard(Sacraments sacrament, ThemeConfiguration themeData) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => navigateToDetails(sacrament),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sacrament.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: themeData.listTextColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      sacrament.properties,
                      style: TextStyle(
                        fontSize: 16,
                        color: themeData.calendarBorderColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Color(0xff4e1208),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, ThemeConfiguration themeData) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return FilterWidget(
          filterProps: FilterProps(
            title: "Sacrament Filter",
            themeProps: ThemeProps(
              checkBoxTileThemeProps: CheckBoxTileThemeProps(
                activeCheckBoxColor: const Color(0xff4e1208),
              ),
              dividerThickness: 2,
              searchBarViewProps: SearchBarViewProps(
                filled: false,
              ),
            ),
            onFilterChange: (value) {
              print("..Applied......$value...");
              filterApply(value);
            },
            filters: properties.modelList.isNotEmpty ? filterList() : Container(),
          ),
          
        );
      },
    );
  }

  filterList() {
    return properties.modelList;
  }

  filterApply(value) {
    print("...${properties.modelList}...filterApply.....$value...");
    if (value.isNotEmpty) {
      resetAllFilters();
      int index = 0;
      for (var filter in value) {
        print("...${filter.applied}...filterApply...inner..${filter.filterTitle}...");
        FilterListModel data = properties.modelList[index];
        if (filter.filterTitle == data.title) {
          if (filter.applied.isNotEmpty) {
            print(".${filter.filterTitle}.....matching and filter available..-----...${filter.applied}...");
            if (filter.filterTitle == languageTitle) {
              addToLanguageFilter(filter.applied);
            } else if (filter.filterTitle == sacramentTypeTitle) {
              addToTypeFilter(filter.applied);
            }

            properties.modelList[index] = data.copyWith(previousApplied: filter.applied);
          } else {
            if (filter.filterTitle == languageTitle) {
              languageFilter = [];
            } else if (filter.filterTitle == sacramentTypeTitle) {
              sacramentTypeFilter = [];
            }

            properties.modelList[index] = data.copyWith(previousApplied: []);
          }
        }
        index++;
      }
    } else {
      for (int index = 0; index < properties.modelList.length; index++) {
        properties.modelList[index] = properties.modelList[index].copyWith(previousApplied: []);
      }

      resetAllFilters();
    }

    print("...$languageFilter......filter---$sacramentTypeFilter--- array..--");
    createFilterParameter();

    getSacramentList(queryParameter, 0);
  }

  addToLanguageFilter(dataList) {
    for (FilterItemModel item in dataList) {
      languageFilter.add(int.parse(item.filterKey));
    }
  }

  addToTypeFilter(dataList) {
    for (FilterItemModel item in dataList) {
      sacramentTypeFilter.add(int.parse(item.filterKey));
    }
  }

  resetAllFilters() {
    languageFilter = [];
    sacramentTypeFilter = [];
  }

  createFilterParameter() {
    queryParameter = "";
    if (languageFilter.isNotEmpty) {
      queryParameter = "language__in=${languageFilter.join(",")}&";
    }
    if (sacramentTypeFilter.isNotEmpty) {
      queryParameter += "sacrament__sacrament_type__in=${sacramentTypeFilter.join(",")}&";
    }
    print(".....final filtering data.......$queryParameter....");
  }

  navigateToDetails(sacrament) {
    if (kIsWeb) {
      // running on the web!
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HtmlViewWeb(
            name: sacrament.name,
            collectionName: "Sacrament",
            objectID: sacrament.id.toString(),
            pageType: "SA",
            htmlurl: "",
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HtmlViewInApp(
            name: sacrament.name,
            collectionName: "Sacrament",
            objectID: sacrament.id.toString(),
            pageType: "SL",
            htmlurl: "",
          ),
        ),
      );
    }
  }
}