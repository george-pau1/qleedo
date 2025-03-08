
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qleedo/models/Parishs.dart';
import 'package:qleedo/screens/parish_view.dart';
import 'package:qleedo/service/webservices_call.dart';
import 'package:qleedo/index.dart' hide SearchBar;

class ParishList extends StatefulWidget {
  static const routeName = '\ParishList';

  const ParishList({
    Key? key,
  }) : super(key: key);

  @override
  _ParishViewState createState() => _ParishViewState();
}

class _ParishViewState extends State<ParishList> {
  bool isLoading = true;
  String queryParameter = ""; 
  int pageOffset = 0;
  String currentPage="limit=$pageSize&offset=0";
  final searchController = TextEditingController();
  late SearchBar searchBar;
  final PagingController<int, Parishs> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) {
      fetchPage("",pageKey);
    });
    createSearchWidget();
  }

  fetchPage(queryParam ,int pageKey) async { 
    WebService service = WebService();
    var paramsUrl = queryParam != "" ? queryParam : currentPage;
    var urlParams = "$parishList?$paramsUrl";
    Map<String, String> headers = {"accept": "application/json"};
    final response = await service.getResponse(urlParams, headers);
    //print(".......getState.......$urlParams... response.....first...${response.statusCode}....");
    Map<String, dynamic> jsonData = response; //json.decode(response.body);
    var status = jsonData[statusKey];
    if(pageKey == 0){
      pagingController.itemList = [];
    }
    print(".......getState response....$status....$jsonData....");
    if(status == 200){
        var data = jsonData[dataKey];
        var previousLocal = data[previousKey] ?? "";
        var nextLocal = data[nextKey] ?? "";
        var count = data[countKey] ?? 0;
        print("..$previousLocal....inner paining...6666...$nextLocal......");
        var previousPage = previousLocal != "" ? previousLocal.replaceAll(qleedoAPIUrl+parishList,'') : '';
        var nextPage = nextLocal != "" ? nextLocal.replaceAll(qleedoAPIUrl+parishList,'') : '';
        var saintsLists = data[reslutsKey] as List;
        print("..$nextPage....ouutter paining.-009090---${saintsLists.length}----.66667868...$saintsLists...$previousPage.......");
        var listData = saintsLists.map((data) => Parishs.fromJson(data)).toList();
        print("..$listData.....getState response..44..666....${listData.length}....");
        if (nextPage == "") {
          pagingController.appendLastPage(listData );
        } else {
          currentPage = nextPage;
          final nextPageKey = pageKey + listData.length;
          pagingController.appendPage(listData , nextPageKey);
        }

    }
  }



  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: themeData.appNavBg,
        title: Text(
          "Prish List",
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
      ),*/
      appBar: searchBar.build(context),
      drawer: AppDrawer(),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: PagedListView<int, Parishs>(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<Parishs>(
            itemBuilder: (context, item, index) =>
                saintsItemView(item, themeData),
          ),
        ),
    );
  }

  createSearchWidget() {
    searchBar =  SearchBar(
        inBar: false,
        showClearButton: true,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        //onChanged: onSubmitted,
        onCleared: () {
          print("cleared");
          currentPage="limit=$pageSize&offset=0";
          var searchParam = "limit=$pageSize&offset=0";
          fetchPage(searchParam,0);
          
        },
        onClosed: () {
          print("closed");
          
        });
  }

  saintsItemView(Parishs parish, themeData) {
    return GestureDetector(
        child: Card(
          margin: const EdgeInsets.all(7),
          child: Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                      parish.name,
                      style:
                          TextStyle(fontSize: 22.0, color: themeData.textColor,fontWeight: FontWeight.bold),
                    ),

                    parish.phoneNo != "" ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 5,),
                      child: Text(
                        parish.phoneNo,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: themeData.calendarBorderColor),
                      ),
                    ) :  Container(),
                    parish.address1 != "" ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 5,),
                      child: Text(
                        "${parish.address1} | ${parish.address2} | ${parish.zipcode} ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: themeData.textColor),
                      ),
                    ) : Container()
                  ])),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                alignment: Alignment.center,
                child :Icon(
                    Icons.location_pin,
                    color: themeData.textColor,
                    size: 35,
                  )
              )
            ],
          ),
        ),
        onTap: () {
          print("....$kIsWeb.....parish selected list......${parish.id}.....");
          parishClickAction(parish);
        });
  }

  parishClickAction(Parishs parish) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParishView(selectedParish: parish,),
          ));
    
  }

  AppBar buildAppBar(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    return  AppBar(
          backgroundColor: themeData.appNavBg,
          title: Text(
            "Parish Listing",
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
    fetchPage(searchParam,0);

  }


}
