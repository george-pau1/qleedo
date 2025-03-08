import 'package:qleedo/models/prayer.dart';
import 'package:qleedo/screens/prayer_selected_list.dart';
import 'package:qleedo/index.dart';
import 'package:amazon_like_filter/amazon_like_filter.dart';


class PrayerHome extends StatefulWidget {
  static const routeName = '\PrayerHome';

  @override
  _PrayerHomeState createState() => _PrayerHomeState();
}

class _PrayerHomeState extends State<PrayerHome> with TickerProviderStateMixin {
  int _startingTabCount = 0;
  var isLoading = true;
  List<PrayerCollection> prayerCollection = [];
  List<PrayerSet> prayerSet = [];

  List<Tab> _tabs = [];
  List<Widget> generalWidgets = [];
  late TabController _tabController;

  @override
  void initState() {
    getPrayerCollection();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void getPrayerCollection() async {

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
              (data as List).map((data) =>  PrayerCollection.fromJson(data)).toList();
      setState(() {
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
    if (_tabController.index == 1) {
        urlParameters = '$keyParseServerUrl/classes/PrayerSets?where={"code" : {"\$in" : ["0","1","3"]}}&order=timeIn24hr';
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
              (data as List).map((data) =>  PrayerSet.fromJson(data)).toList();
      setState(() {
        prayerSet = prayerCollect;
        isLoading = false;
      });
    } else {
      print("......getPrayerCollectio....Error.....${response.statusCode}....");
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
        title: Text("Prayers", style: TextStyle(color: themeData.appNavTextColor, fontSize: AppConstants.headingFontSize, fontWeight: AppConstants.fontWeight),),
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
        bottom: prayerCollection.isNotEmpty ? TabBar(
            labelColor: themeData.appNavTextColor,
            isScrollable: true,
            tabs: _tabs,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: themeData.appNavTextColor),
            controller: _tabController,
            onTap: (int index) {
              onTabChange(index);
            }) : null,
      ),
      //drawer: AppDrawer(),
      body: isLoading ? 
            showCircularProgress(themeData,deviceWidth,deviceHeight)
            :getWidget(themeData) ,
            floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return FilterWidget(
                  filterProps: FilterProps(
                themeProps: ThemeProps(
                    checkBoxTileThemeProps: CheckBoxTileThemeProps(
                      activeCheckBoxColor: Colors.green,
                    ),
                    dividerThickness: 5,
                    searchBarViewProps: SearchBarViewProps(
                      filled: false,
                    )),
                onFilterChange: (value) {
                  
                  print('Applied filer - ${value.map((e) => e.toMap())}');
                },
                filters:  [
                  FilterListModel(
                    filterOptions: [
                      FilterItemModel(
                          filterTitle: 'Education', filterKey: 'education'),
                      FilterItemModel(
                        filterTitle: 'Information Technology',
                        filterKey: 'it',
                      ),
                      FilterItemModel(
                          filterTitle: 'Sports', filterKey: 'sports'),
                      FilterItemModel(
                          filterTitle: 'Transport', filterKey: 'transport'),
                    ],
                    previousApplied: [],
                    title: 'Industry',
                    filterKey: 'industry',
                  ),
                  FilterListModel(
                    filterOptions: [
                      FilterItemModel(
                          filterTitle: 'Utter Pradesh', filterKey: 'up'),
                      FilterItemModel(
                        filterTitle: 'Madhya Pradesh',
                        filterKey: 'mp',
                      ),
                      FilterItemModel(filterTitle: 'Hariyana', filterKey: 'hr'),
                      FilterItemModel(filterTitle: 'Bihar', filterKey: 'bihar'),
                    ],
                    previousApplied: [],
                    title: 'State',
                    filterKey: 'state',
                  )
                ],
              ));
            },
          );
        },
        tooltip: 'Increment',
        child :const CircleAvatar(
      radius: 50,
      backgroundColor: Color(0xff4e1208,),
      child: Icon(Icons.filter_alt_outlined, color:Colors.white )
)
        //child: const Icon(Icons.filter_alt_outlined, color: Color(0xff4e1208,),),
      ),
    );
  }



  onTabChange(index) {
    setState(() {
      isLoading = true;
    });
    getPrayerSet();
  }

  TabController getTabController() {
    return TabController(length: _tabs.length, vsync: this)
      ..addListener(_updatePage);
  }

  Tab getTab(String widgetNumber) {
    return Tab(
      text: widgetNumber,

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

  List<Tab> getTabs(int count) {
    //print(".........getTabs........$count...");
    _tabs.clear();
    for (int i = 0; i < count; i++) {
      PrayerCollection prayer = prayerCollection[i];
      _tabs.add(getTab(prayer.name));
    }
    return _tabs;
  }

  List<Widget> getWidgets(themeData) {
    generalWidgets.clear();
    for (int i = 0; i < _tabs.length; i++) {
      generalWidgets.add(getWidget(themeData));
    }
    return generalWidgets;
  }

  void addIfCanAnotherTab() {
    if (_startingTabCount == _tabController.length) {
      showWarningTabAddDialog();
    } else {
      addAnotherTab();
    }
  }

  void addAnotherTab() {
    _tabs = getTabs(_tabs.length + 1);
    _tabController.index = 0;
    _tabController = getTabController();
    _updatePage();
  }

  void removeTab() {
    _tabs = getTabs(_tabs.length - 1);
    _tabController.index = 0;
    _tabController = getTabController();
    _updatePage();
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
            builder: (context) => const AlertDialog(
                title: Text("End reached"),
                content: Text("Thank you for playing around!")))
        : _tabController.animateTo(_tabController.index + 1);
  }

  void showWarningTabAddDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Cannot add more tabs"),
              content: const Text("Let's avoid crashing, shall we?"),
              actions: <Widget>[
                TextButton(
                    child: const Text("Crash it!"),
                    onPressed: () {
                      addAnotherTab();
                      Navigator.pop(context);
                    }),
                TextButton(
                    child: const Text("Ok"), onPressed: () => Navigator.pop(context))
              ],
            ));
  }
}
