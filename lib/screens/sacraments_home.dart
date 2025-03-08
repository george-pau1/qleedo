import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qleedo/models/prayer.dart';
import 'package:qleedo/screens/html_view.dart';
import 'package:qleedo/screens/html_view_inapp.dart';
import 'package:qleedo/screens/sacraments_selected_list.dart';
import 'package:qleedo/index.dart';
import 'package:qleedo/screens/html_view_web.dart';
import 'package:http/http.dart';

class SacramentsHome extends StatefulWidget {
  static const routeName = '/SacramentHomes';

  @override
  _SacramentsHomeState createState() => _SacramentsHomeState();
}

class _SacramentsHomeState extends State<SacramentsHome>
    with TickerProviderStateMixin {
  int _startingTabCount = 0;
  var isLoading = false;
  var _isNetworkAvail = true;
  List<PrayerCollection> prayerCollection = [];
  List<SacramentsOld> sacramentCollection = [];

  List<Tab> _tabs = [];
  late TabController _tabController;
  var selectedSacramentCode = '';
  var isResultEmpty = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getSacramentsGroup();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getSacramentCollection(String code) async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      setState(() {
        _isNetworkAvail = true;
        isLoading = true;
      });

      var urlParameters = '$keyParseServerUrl/classes/SacramentCategory?where={"sacramentCode":"$code"}&order=sortOrder';
      final uri = Uri.parse(urlParameters);
      final response = await get(
        uri,
        headers: <String, String>{
          'Content-Type': contentType,
          'X-Parse-Application-Id': keyParseApplicationId,
          'X-Parse-REST-API-Key': restAPIKey
        },
      );

      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        var data = getdata["results"];
        var prayerCollect =
            (data as List).map((data) => SacramentsOld.fromJsonSacrament(data)).toList();
        setState(() {
          sacramentCollection = prayerCollect;
          selectedSacramentCode = prayerCollect[0].collection;
          isLoading = false;
        });
      } else {
        print("Error fetching sacrament collection: ${response.statusCode}");
        setState(() {
          isLoading = false;
          isResultEmpty = true;
        });
      }
    } else {
      setState(() {
        _isNetworkAvail = false;
        isLoading = false;
      });
    }
  }

  Future<void> getSacramentsGroup() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      setState(() {
        _isNetworkAvail = true;
        isLoading = true;
      });
      
      var urlParameters = '$keyParseServerUrl/classes/PrayerCollections?where={"grpId":"S"}&order=prayerCollectionId';
      final uri = Uri.parse(urlParameters);
      final response = await get(
        uri,
        headers: <String, String>{
          'Content-Type': contentType,
          'X-Parse-Application-Id': keyParseApplicationId,
          'X-Parse-REST-API-Key': restAPIKey
        },
      );

      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        var data = getdata["results"];
        var prayerCollect =
            (data as List).map((data) => PrayerCollection.fromJson(data)).toList();

        setState(() {
          prayerCollection = prayerCollect;
          _startingTabCount = prayerCollect.length;
          selectedSacramentCode = prayerCollect[0].code;
          isLoading = false;
        });
        
        _tabs = getTabs(_startingTabCount);
        _tabController = getTabController();
        getSacramentCollection('SC');
      } else {
        print("Error fetching prayer collection: ${response.statusCode}");
        setState(() {
          isLoading = false;
          isResultEmpty = true;
        });
      }
    } else {
      setState(() {
        _isNetworkAvail = false;
        isLoading = false;
      });
    }
  }

  Future<void> getSacramentSet() async {
    setState(() {
      isLoading = true;
    });

    var urlParameters = '$keyParseServerUrl/classes/Sacrament?where={"Collection":"$selectedSacramentCode","Status":"A"}';
    final uri = Uri.parse(urlParameters);
    final response = await get(
      uri,
      headers: <String, String>{
        'Content-Type': contentType,
        'X-Parse-Application-Id': keyParseApplicationId,
        'X-Parse-REST-API-Key': restAPIKey
      },
    );

    if (response.statusCode == 200) {
      var getdata = json.decode(response.body);
      var data = getdata["results"];

      var prayerCollect =
          (data as List).map((data) => SacramentsOld.fromJson(data)).toList();
      setState(() {
        sacramentCollection = prayerCollect;
        isLoading = false;
        isResultEmpty = false;
      });
    } else {
      print("Error fetching sacrament set: ${response.statusCode}");
      setState(() {
        sacramentCollection = [];
        isLoading = false;
        isResultEmpty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: themeData.appNavBg,
        elevation: 0,
        title: Text(
          "Sacraments",
          style: TextStyle(
            color: themeData.appNavTextColor,
            fontSize: AppConstants.headingFontSize,
            fontWeight: AppConstants.fontWeight,
            letterSpacing: 0.5,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: themeData.appNavTextColor,
              size: 28,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        bottom: prayerCollection.isNotEmpty
            ? PreferredSize(
                preferredSize: Size.fromHeight(48),
                child: TabBar(
                  labelColor: themeData.appNavTextColor,
                  unselectedLabelColor: themeData.appNavTextColor.withOpacity(0.6),
                  indicatorColor: themeData.appNavTextColor,
                  indicatorWeight: 3,
                  isScrollable: true,
                  tabs: _tabs,
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  controller: _tabController,
                  onTap: onTabChange,
                ),
              )
            : null,
      ),
      drawer: AppDrawer(),
      body: !_isNetworkAvail
          ? _buildNoInternet()
          : isLoading
              ? _buildLoadingIndicator(themeData, deviceWidth, deviceHeight)
              : _buildSacramentList(themeData),
    );
  }

  Widget _buildLoadingIndicator(ThemeConfiguration themeData, double width, double height) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(themeData.appNavBg),
          ),
          SizedBox(height: 16),
          Text(
            "Loading...",
            style: TextStyle(
              color: themeData.listTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoInternet() {
    final themeData = Provider.of<ThemeConfiguration>(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              "No Internet Connection",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: themeData.listTextColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Please check your connection and try again",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: themeData.listTextColor.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                bool avail = await isNetworkAvailable();
                if (avail) {
                  getSacramentsGroup();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeData.appNavBg,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Try Again",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSacramentList(ThemeConfiguration themeData) {
    if (sacramentCollection.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No items available',
              style: TextStyle(
                fontSize: 18,
                color: themeData.listTextColor.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListView.builder(
        itemCount: sacramentCollection.length,
        itemBuilder: (context, position) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildSacramentCard(position, themeData),
          );
        },
      ),
    );
  }

  Widget _buildSacramentCard(int position, ThemeConfiguration themeData) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToDetail(position),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Row(
            children: [
              SizedBox(width: 8),
              Icon(
                Icons.article_rounded,
                color: themeData.appNavBg,
                size: 24,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  sacramentCollection[position].name,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: themeData.listTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: themeData.listTextColor.withOpacity(0.5),
                size: 16,
              ),
              SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(int position) {
    final item = sacramentCollection[position];
    
    if (item.collection == 'SL' || item.collection == 'QY') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SacramentListView(
            sacramentCollection: item.collection,
            sacramentCollectionName: item.name,
          ),
        ),
      );
    } else {
      if (kIsWeb) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HtmlViewInApp(
              name: item.name,
              collectionName: "Sacrament",
              objectID: item.objectID,
              pageType: "SA",
              htmlurl: item.sacramentUrl,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HtmlView(
              name: item.name,
              collectionName: "Sacrament",
              objectID: item.objectID,
              pageType: "SA",
              htmlurl: item.sacramentUrl,
            ),
          ),
        );
      }
    }
  }

  void onTabChange(int index) {
    setState(() {
      isLoading = true;
      selectedSacramentCode = prayerCollection[index].code;
      sacramentCollection = [];
    });
    
    if (prayerCollection[index].code == 'SC') {
      getSacramentCollection('SC');
    } else if (prayerCollection[index].code == 'FE') {
      getSacramentCollection('FE');
    } else {
      getSacramentSet();
    }
  }

  TabController getTabController() {
    return TabController(length: _tabs.length, vsync: this)
      ..addListener(_updatePage);
  }

  List<Tab> getTabs(int count) {
    _tabs.clear();
    for (int i = 0; i < count; i++) {
      PrayerCollection prayer = prayerCollection[i];
      _tabs.add(Tab(text: prayer.name));
    }
    return _tabs;
  }

  void _updatePage() {
    setState(() {});
  }
}