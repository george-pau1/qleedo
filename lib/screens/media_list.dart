
import 'package:amazon_like_filter/props/filter_item_model.dart';
import 'package:amazon_like_filter/props/filter_list_model.dart';
import 'package:amazon_like_filter/props/filter_props.dart';
import 'package:amazon_like_filter/widgets/filter_widget.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qleedo/index.dart' hide SearchBar;
import 'package:qleedo/models/Media.dart';
import 'package:qleedo/screens/media_details.dart';
import 'package:qleedo/service/webservices_call.dart';




class MediaList extends StatefulWidget {
  static const routeName = '\MediaList';

  const MediaList({super.key});

  @override
  _MediaListState createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> with TickerProviderStateMixin {
  int startingTabCount = 0;
  var isLoading = false;
  List<Media> mediaList = [];
  List<Media> searchList = [];
  final searchController = TextEditingController();
  late SearchBar searchBar;
  final GlobalKey key = GlobalKey();
   String queryParameter = ""; 
  int pageOffset = 0;
  String currentPage="limit=$pageSize&offset=0";

  //Filter UI
  List<int> prayerFilter = [];
  List<int> sacramentFilter = [];
  List<int> festivalFilter = [];
  MediaProperties properties = MediaProperties.empty();


  final PagingController<int, Media> pagingController =
      PagingController(firstPageKey: 1);


  @override
  void initState() {
    super.initState();
    print(".....get,.....before call......");
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage("",pageKey);
    });
    createSearchWidget();
    getMediaPropertyList();
 
  }

  _fetchPage(queryParam ,int pageKey) async { 
    WebService service = WebService();
    var paramsUrl = queryParam != "" ? queryParam : currentPage;
    var urlParams = "$mediaApi?$paramsUrl";
    Map<String, String> headers = {"accept": "application/json"};
    final response = await service.getResponse(urlParams, headers);
    //print(".......getState.......$urlParams... response.....first...${response.statusCode}....");
    Map<String, dynamic> jsonData = response; //json.decode(response.body);
    var status = jsonData[statusKey];
    if(pageKey == 0){
      pagingController.itemList = [];
    }
    print("..$mediaList.....getState response....$status....$jsonData....");
    if(status == 200){
        var data = jsonData[dataKey];
        var previousLocal = data[previousKey] ?? "";
        var nextLocal = data[nextKey] ?? "";
        var count = data[countKey] ?? 0;
        print("..$previousLocal....inner paining...6666...$nextLocal......");
        var previousPage = previousLocal != "" ? previousLocal.replaceAll("$qleedoAPIUrl$saintsApi?",'') : '';
        var nextPage = nextLocal != "" ? nextLocal.replaceAll("$qleedoAPIUrl$saintsApi?",'') : '';
        var saintsLists = data[reslutsKey] as List;
        print("..$nextPage....ouutter paining.-009090---${saintsLists.length}----.66667868...$saintsLists...$previousPage.......");
        var listData = saintsLists.map((data) => Media.fromJson(data)).toList();
        print("..$listData.....getState response..44..666....${listData.length}....");
        if (nextPage == "") {
        pagingController.appendLastPage(listData );
        } else {
          currentPage = nextPage;
          final nextPageKey = pageKey + listData.length;
          pagingController.appendPage(listData , nextPageKey);
        }

  }else if (status == 204){
      pagingController.itemList = [];
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
      var size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: searchBar.build(context),
        drawer: AppDrawer(),
        body: isLoading
            ? showCircularProgress(themeData, deviceWidth, deviceHeight)
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                //child: threeList(context, themeData))
                child: PagedGridView<int, Media>(
        pagingController: pagingController,
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: (size / 300),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
            ),
        builderDelegate: PagedChildBuilderDelegate<Media>(
          itemBuilder: (context, item, index) => mediaWidget(item,themeData),
        ),
      ),
                ),
                
      floatingActionButton: properties.modelList.isNotEmpty
            ? FloatingActionButton(
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return FilterWidget(
                          filterProps: FilterProps(
                        title: "Media Filter",
                        themeProps: ThemeProps(
                            checkBoxTileThemeProps: CheckBoxTileThemeProps(
                              activeCheckBoxColor: const Color(
                                0xff4e1208,
                              ),
                            ),
                            dividerThickness: 5,
                            searchBarViewProps: SearchBarViewProps(
                              filled: false,
                            )),
                        onFilterChange: (value) {
                          print("..Applied......$value...");
                          filterApply(value);
                        },
                        filters: properties.modelList.isNotEmpty
                            ? filterList()
                            : Container(),
                      ));
                    },
                  );
                },
                tooltip: 'Increment',
                child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(
                      0xff4e1208,
                    ),
                    child: Icon(Icons.filter_alt_outlined, color: Colors.white))
                //child: const Icon(Icons.filter_alt_outlined, color: Color(0xff4e1208,),),
                )
            : Container()
                );
  }

  mediaWidget(Media data,ThemeConfiguration themedata){
    var size = MediaQuery.of(context).size.width;
    return GestureDetector(
            onTap: () {
              onSelectMedia(data);
            },
            child: Card(
              color: Color(0xffA24949),
              child: Container(
                alignment: Alignment.center,
                decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width : 2.0, color: Color(0xffA24949)),
                      image: DecorationImage(
                          image: NetworkImage(data.url),
                          fit: BoxFit.cover),
                    ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: size * 0.02),
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          width: size * 0.46,
                          color: themedata.appNavBg,
                          alignment: Alignment.bottomCenter,
                          child: Center(
                            child: Text(
                              data.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: themedata.appNavTextColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          );
  }


  Widget mediaItemView(BuildContext context, ThemeConfiguration themedata) {
    var size = MediaQuery.of(context).size.width;
    print("...${searchList.length}...threeList....");
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      childAspectRatio: (size / 260),
      shrinkWrap: true,
      children: List.generate(
        searchList.length,
        (index) {
          return GestureDetector(
            onTap: () {
              onSelectMedia(searchList[index]);
            },
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: size * 0.95,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: themedata.appNavBg,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 55.0,
                        backgroundImage:
                            NetworkImage(searchList[index].url),
                        //backgroundImage: NetworkImage(
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: size * 0.02),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        width: size * 0.46,
                        color: themedata.appNavBg,
                        alignment: Alignment.bottomCenter,
                        child: Center(
                          child: Text(
                            searchList[index].name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: themedata.appNavTextColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 12),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  onSelectMedia(Media data) {
    print("...${data.id}...onSelectMedia........$data...");
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MediaDetailsView(
            selectedMedia: data,
            typeSelected: "D",
          ),
        ));
  }


  createSearchWidget() {
    searchBar =  SearchBar(
        inBar: false,
        showClearButton: true,
        closeOnSubmit : false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        //onChanged: onSubmitted,
        onCleared: () {
          print("cleared");
          currentPage="limit=$pageSize&offset=0";
          var searchParam = "limit=$pageSize&offset=0";
          _fetchPage(searchParam,0);
          
        },
        onClosed: () {
          print("closed");
          setState(() {
            searchList = mediaList;
          });
        });
  }

  AppBar buildAppBar(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    return  AppBar(
          backgroundColor: themeData.appNavBg,
          title: Text(
            "Media Listing",
            style: TextStyle(
                color: themeData.appNavTextColor,
                fontSize: AppConstants.headingFontSize,
                fontWeight: AppConstants.fontWeight),
          ),
          leading: Builder(
            builder: (context) => // Ensure Scaffold is in context
                IconButton(
                    icon: Icon(
                      Icons.menu_outlined,
                      color: themeData.appNavTextColor,
                      size: 35,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer()),
          ),
          actions: [searchBar.getSearchAction(context)]
        );
  }

  onSubmitted(String value) {
    print("......data search....$value...");
    currentPage = "";
    var searchParam = value.isNotEmpty ? "limit=$pageSize&offset=0&search=$value" : "limit=$pageSize&offset=0";
    _fetchPage(searchParam,0);
  }

  getMediaPropertyList() async {
    WebService service = WebService();
    Map<String, String> headers = {"accept": "application/json"};
    final response =
        await service.getResponse("$dynamicDataList?type=medias", headers);
    Map<String, dynamic> jsonData = response; //json.decode(response.body);
    var status = jsonData[statusKey];
    print("...getTodaysSaints.333...$jsonData..");
    if (status == 200) {
      var data = MediaProperties.fromJson(jsonData);

      setState(() {
        properties = data;
      });
    } else {
      //data = new BaseModel(message: jsonData[messageKey], status: false, data: []);
    }
  }

  filterList() {
    return properties.modelList;
  }

  filterApply(value){
    print("...${properties.modelList}...filterApply.....$value...");
    if(value.isNotEmpty){
      resetAllFilters();
      int index=0;
      for(var filter in value){
          print("...${filter.applied}...filterApply...inner..${filter.filterTitle}...");
          FilterListModel data = properties.modelList[index];
          if(filter.filterTitle == data.title){
            if(filter.applied.isNotEmpty){
              print(".${filter.filterTitle}.....matching and filter available..-----...${filter.applied}...");
              if(filter.filterTitle == prayerTitle){
                addToPrayerFilter(filter.applied);
              }else if(filter.filterTitle == sacramentTitle){
                addToSacramentFilter(filter.applied);
              }
              else if(filter.filterTitle == festivalTitle){
                addToFestivalFilter(filter.applied);
              }
              

              properties.modelList[index] = data.copyWith(previousApplied: filter.applied);

            }else{

              if(filter.filterTitle == prayerTitle){
                prayerFilter = [];
              }else if(filter.filterTitle == sacramentTitle){
                sacramentFilter = [];
              }
              else if(filter.filterTitle == festivalFilter){
                festivalFilter = [];
              }
 
              properties.modelList[index] = data.copyWith(previousApplied: []);

            }
          }
        index++;
      }
    }else{
      int index =0;
      for(FilterListModel filter in properties.modelList){
          properties.modelList[index] = filter.copyWith(previousApplied: []);
          index++;
      }
      resetAllFilters();
    }

    print("...$prayerFilter......filter---$sacramentFilter--- array.....$festivalFilter..........--");
    createFilterParameter();
    currentPage="limit=$pageSize&offset=0";
    _fetchPage(queryParameter+currentPage,0);

  }


  addToFestivalFilter(dataList){
    for(FilterItemModel item in dataList){
       festivalFilter.add(int.parse(item.filterKey));          
    }
  }

  addToSacramentFilter(dataList){
    for(FilterItemModel item in dataList){
       sacramentFilter.add(int.parse(item.filterKey));          
    }
  }

  addToPrayerFilter(dataList){
    for(FilterItemModel item in dataList){
       prayerFilter.add(int.parse(item.filterKey));          
    }
  }

  resetAllFilters(){
      prayerFilter =[];
      sacramentFilter = [];
      festivalFilter = [];
  }

  createFilterParameter(){
    queryParameter = "";
    if(prayerFilter.isNotEmpty){
      queryParameter = "prayer__in=${prayerFilter.join(",")}&";
    }
    if(sacramentFilter.isNotEmpty){
      queryParameter += "sacrament__in=${sacramentFilter.join(",")}&";
    }
    if(festivalFilter.isNotEmpty){
      queryParameter += "festival__in=${festivalFilter.join(",")}&";
    }

    print(".....final filtering data.......$queryParameter....");
  }

  
}

