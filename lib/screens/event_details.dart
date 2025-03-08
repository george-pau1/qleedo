

import 'package:qleedo/models/prayer.dart';
import 'package:qleedo/models/saints.dart';
import 'package:qleedo/index.dart';

class EventsDetailsView extends StatefulWidget {
  static const routeName = '\EVENTSDETAILS';
  Saints selectedSaints;
    
  EventsDetailsView({Key? key, required this.selectedSaints}) : super(key: key);


  @override
  _EventsDetailsViewState createState() => _EventsDetailsViewState();
}

class _EventsDetailsViewState extends State<EventsDetailsView>
    with TickerProviderStateMixin {
  int _startingTabCount = 0;
  var isLoading = true;
  List<PrayerCollection> prayerCollection = [];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void getPrayerCollection() async {
    
    /*QueryBuilder<ParseObject>(ParseObject('PrayerCollections'))
          ..whereEqualTo('grpId', 'P')
          ..orderByAscending('prayerCollectionId');*/
    
    var urlParameters = '$keyParseServerUrl/PrayerCollections?where={grpId :P}&order=prayerCollectionId';
    final uri = Uri.parse(urlParameters);
    final response = await get(
      uri,
      headers: <String, String>{
        'Content-Type': contentType,
        'X-Parse-Application-Id': keyParseApplicationId,
        'X-Parse-REST-API-Key': restAPIKey
      },);

    if (response.statusCode == 200) {
      print(
          "..$response....getPrayerCollectiongetPrayerCollection...response..${response.statusCode}....");
      var getdata = json.decode(response.body);

      var list = getdata.result as List;
      print("........object transfer......$list...");
      var prayerCollect =
          list.map((i) => PrayerCollection.fromJson(i)).toList();
      print(
          "..$prayerCollect....prayerCollection.66666..response..${prayerCollect.length}....");
      this.setState(() {
        prayerCollection = prayerCollect;
        _startingTabCount = prayerCollect.length;
        //isLoading = false;
      });
      //_tabs = getTabs(_startingTabCount);
      //_tabController = getTabController();
    } else {
      print("......getPrayerCollectio....Error.....${response.statusCode}....");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.appNavBg,
        leading: navBackButton(themeData, context),
        title: Text(widget.selectedSaints.name,
          style: TextStyle(color: themeData.textHeading, fontSize: AppConstants.headingFontSize, fontWeight: AppConstants.fontWeight),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
                    children: [
                      CircleAvatar(
                        radius: 85,
                        backgroundColor: themeData.appNavBg,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 80.0,
                          backgroundImage: NetworkImage(widget.selectedSaints.imageUrl),
                          //backgroundImage: NetworkImage(
                        ),
                      ),
                      Container(
                          width: size * 0.70,
                          height: 40,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage("assets/images/saints/saintname.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Text(
                            widget.selectedSaints.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: themeData.textHeading),
                          )),
                      SizedBox(height: 20,),
                      Text(
                            widget.selectedSaints.description,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: themeData.textColor, fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                      SizedBox(height: 15,),
                    ],
                  ),
        ),
      ),
    );
  }

}