import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:qleedo/models/prayer.dart';
import 'package:qleedo/screens/prayer_selected_list.dart';
import 'package:qleedo/index.dart' hide SearchBar;

class SearchScreen extends StatefulWidget {
  static const routeName = '\SearchScreen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  int _startingTabCount = 0;
  var isLoading = false;
  List<PrayerCollection> prayerCollection = [];
  List<PrayerSet> prayerSet = [];

  List<Tab> _tabs = [];
  List<Widget> _generalWidgets = [];
  late TabController _tabController;
  late SearchBar searchBar;

  @override
  void initState() {
    //getPrayerCollection();
    super.initState();
    createSearchWidget();
    _tabController = new TabController(length: 2, vsync: this);
  }


  tabbarView(){
    _tabs.clear();
    _tabs.add(getTab("Prayers"));
    _tabs.add(getTab("Sacraments"));
    _tabController = getTabController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  createSearchWidget() {
    searchBar = new SearchBar(
        inBar: false,
        showClearButton: true,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  AppBar buildAppBar(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    return  AppBar(
        backgroundColor: themeData.appNavBg,
          title: Text(
            "User Preference",
            style: TextStyle(
                color: themeData.appNavTextColor,
                fontSize: AppConstants.headingFontSize,
                fontWeight: AppConstants.fontWeight),
          ),
        actions: [searchBar.getSearchAction(context)]);
  }

  onSubmitted(String value) {

  }

  /*void getPrayerCollection() async {

    var urlParameters = '$keyParseServerUrl/classes/PrayerCollections?where={"grpId" : "P"}&order=prayerCollectionId';
    final uri = Uri.parse(urlParameters);

    final response = await get(
      uri,
      headers: <String, String>{
        'Content-Type': contentType,
        'X-Parse-Application-Id': keyParseApplicationId,
        'X-Parse-REST-API-Key': restAPIKey
      },);


    if (response.statusCode == 200) {
      var getdata = json.decode(response.body);
      var data = getdata["results"];
      var prayerCollect =
              (data as List).map((data) => new PrayerCollection.fromJson(data)).toList();
      this.setState(() {
        prayerCollection = prayerCollect;
        _startingTabCount = prayerCollect.length;
        //isLoading = false;
      });
      _tabs = getTabs(_startingTabCount);
      _tabController = getTabController();
      getPrayerSet();
    } else {
      print("......getPrayerCollectio....Error.....${response.statusCode}....");
    }
  }

  void getPrayerSet() async {

    var urlParameters = '';
    if (_tabController.index == 2) {
        urlParameters = '$keyParseServerUrl/classes/PrayerSets?where={"code" : {"\$in" : ["1","2","3"]}}&order=timeIn24hr';
    }else{
        urlParameters = '$keyParseServerUrl/classes/PrayerSets?where={"code":{"\$exists":true}}&order=timeIn24hr';
    }
    final uri = Uri.parse(urlParameters);
    final response = await get(
      uri,
      headers: <String, String>{
        'Content-Type': contentType,
        'X-Parse-Application-Id': keyParseApplicationId,
        'X-Parse-REST-API-Key': restAPIKey
      },);


    if (response.statusCode == 200) {
      var getdata = json.decode(response.body);
      var data = getdata["results"];
      var prayerCollect =
              (data as List).map((data) => new PrayerSet.fromJson(data)).toList();
      this.setState(() {
        prayerSet = prayerCollect;
        isLoading = false;
      });
    } else {
      print("......getPrayerCollectio....Error.....${response.statusCode}....");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
      double deviceHeight = MediaQuery.of(context).size.height;
     double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: searchBar.build(context),
      drawer: AppDrawer(),
      body: isLoading ? 
            showCircularProgress(themeData,deviceWidth,deviceHeight)
            : contentWidget(themeData)
    );
  }

  Widget contentWidget(ThemeConfiguration themedata){
    return SingleChildScrollView(
      child: Container(
        child: DefaultTabController(
              length: 2, // length of tabs
              initialIndex: 0,
              child: Column(
          children: [
            Container(
                  child: TabBar(
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(text: 'Prayers'),
                      Tab(text: 'Sacraments'),
                    ],
                    controller: _tabController,
                  ),
            ),
            Container(
               height : deviceHeight * 0.90,
               //color: Colors.amber,
              child: TabBarView(
                children: <Widget>[
                  Container(child: Text('No Data Available'), height : deviceHeight * 0.90,padding: EdgeInsets.only(left: 10),), 
                  Container(child: Text('No Data Available'), height : deviceHeight * 0.90,padding: EdgeInsets.only(left: 10),)
              ],
              controller: _tabController,),
            )
          ],
        ),
        ),
      )
    );
  }



  onTabChange(index) {
    setState(() {
      isLoading = true;
    });
    //getPrayerSet();
  }

  TabController getTabController() {
    return TabController(length: _tabs.length, vsync: this)
      ..addListener(_updatePage);
  }

  Tab getTab(String widgetNumber) {
    return Tab(
      text: "$widgetNumber",

    );
  }

  Widget getWidget(themeData) {
    /*return Center(
      child: Text("Widget nr: $widgetNumber"),
    );*/
    return ListView.builder(
      itemCount: prayerSet.length,
      itemBuilder: (context, position) {
        return GestureDetector(
            child: Card(
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      prayerSet[position].name,
                      style: TextStyle(fontSize: 22.0, color: themeData.listTextColor),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: themeData.listTextColor,
                      )),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrayerListView(
                      prayerSet: prayerSet[position].code,
                      prayerCollection:
                          prayerCollection[_tabController.index].code,
                      prayerCollectionName: prayerSet[position].name,
                    ),
                  ));
            });
      },
    );
  }

  List<Tab> getTabs() {
    _tabs.clear();
    _tabs.add(getTab("Prayers"));
    _tabs.add(getTab("Sacraments"));

    return _tabs;
  }

  List<Widget> getWidgets(themeData) {
    _generalWidgets.clear();
    for (int i = 0; i < _tabs.length; i++) {
      _generalWidgets.add(getWidget(themeData));
    }
    return _generalWidgets;
  }



  void _updatePage() {
    setState(() {});
  }

  //Tab helpers

  bool isFirstPage() {
    return _tabController.index == 0;
  }

  bool isLastPage() {
    return _tabController.index == _tabController.length - 1;
  }

  void goToPreviousPage() {
    _tabController.animateTo(_tabController.index - 1);
  }

  void goToNextPage() {
    isLastPage()
        ? showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text("End reached"),
                content: Text("Thank you for playing around!")))
        : _tabController.animateTo(_tabController.index + 1);
  }


}
