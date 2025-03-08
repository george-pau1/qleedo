import 'package:localstorage/localstorage.dart';
//import 'package:qleedo/firebase_options.dart';
import 'package:qleedo/models/Media.dart';
import 'package:qleedo/models/common.dart';
import 'package:qleedo/models/index.dart';
import 'package:qleedo/screens/media_details.dart';
import 'package:qleedo/screens/media_list.dart';
import 'package:qleedo/screens/prayer_list.dart';
import 'package:qleedo/screens/sacraments_list.dart';
import 'package:qleedo/screens/saints_home.dart';
import 'package:flutter/services.dart';
import 'package:qleedo/screens/search.dart';
import 'package:qleedo/screens/settings.dart';

import 'screens/bible.dart';
import 'screens/dashboard.dart';
import 'screens/forgot_password.dart';
import 'screens/login.dart';
import 'screens/login_dashboard.dart';
import 'screens/signup.dart';
import 'package:qleedo/index.dart';
//import 'screens/calendar_old.dart';
import 'screens/html_view.dart';
import 'screens/prayer_selected_list.dart';
import 'screens/prayer_home.dart';
import 'package:qleedo/screens/parish_list.dart';
//import 'package:firebase_core/firebase_core.dart';

import 'package:shared_preferences/shared_preferences.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();
  print("befoew initialisation");

  // FirebaseApp app = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //   print('Initialized default app $app from Android resource');
  

  User user = await getPrefrenceUser(isUSERLOGINED);
  UserBible? bible = await getPrefrenceBible(isUSERLOGINED);
  ThemeConfiguration theme = new ThemeConfiguration();
  theme.setDarkTheme(user,bible!);


  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft,
  DeviceOrientation.landscapeRight,])
      .then((value) => runApp(
            ChangeNotifierProvider.value(
              value: theme,
              child: MyApp(),
            ),
          ));
}

class MyApp extends StatefulWidget {
  
  MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    getBasicAPI();

  }


  getBasicAPI(){
     getSuitableDays();
     getSeason();
     getVersion();
     getTranslation();

  }

  void getSuitableDays() async {
  final prefs = await SharedPreferences.getInstance();
  var urlParameters = '$keyParseServerUrl/classes/SuitableDays';
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
    var data = getdata["results"] as List;

    await prefs.setString('suitablelist', json.encode(data));
    suitableList = data.map((data) => Suitable.fromJson(data)).toList();

    print("...${suitableList.length}.....get suitable...inner....${data.length}.....");
  } else {
    print("......getPrayerCollection....Error.....${response.statusCode}....");
  }
}


  void getSeason() async {
  final prefs = await SharedPreferences.getInstance();
  var urlParameters = '$keyParseServerUrl/classes/Season';
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
    var data = getdata["results"] as List;

    await prefs.setString('seasonlist', json.encode(data));
    seasonList = data.map((data) => Season.fromJson(data)).toList();

    print("...${seasonList.length}.....get getSeason...inner....${data.length}....");
  } else {
    print("......getPrayerCollection....Error.....${response.statusCode}....");
  }
}



  

void getVersion() async {
  final prefs = await SharedPreferences.getInstance();
  var urlParameters = '$keyParseServerUrl/classes/Versions';
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
    var data = getdata["results"] as List;

    await prefs.setString('versionlist', json.encode(data));
    versionList = data.map((item) => Version.fromJson(item)).toList();

    print("...${versionList.length}.....get getVersion...inner....${data.length}....");
  } else {
    print("......getVersion....Error.....${response.statusCode}....");
  }
}


  

void getTranslation() async {
  final prefs = await SharedPreferences.getInstance();
  var urlParameters = '$keyParseServerUrl/classes/Translation';
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
    var data = getdata["results"] as List;

    await prefs.setString('translationlist', json.encode(data));
    translationList = data.map((item) => Translation.fromJson(item)).toList();

    print("...${translationList.length}.....get Translation...inner....${data.length}...");
  } else {
    print("......getTranslation....Error.....${response.statusCode}....");
  }
}




  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    //FlutterStatusbarcolor.setStatusBarColor(themeData.appNavBg);
    return MaterialApp(
        title: 'Qleedo',
        theme: ThemeData(
            //appBarTheme: AppBarTheme(color: Color.fromRGBO(93, 48, 15, 1), brightness:Brightness.dark, ),
            fontFamily: 'Lato'),
        home: Dashboard(),
        routes: {
          LoginPage.routeName: (context) => LoginPage(),
          ForgotPassword.routeName: (context) => ForgotPassword(),
          SignupPage.routeName: (context) => SignupPage(),
          LoginDashboard.routeName: (context) => LoginDashboard(),
          BiblePage.routeName: (context) => BiblePage(),
          Dashboard.routeName: (context) => Dashboard(),
   //       MonthCalendarView.routeName: (context) => MonthCalendarView(title: '',),
          HtmlView.routeName: (context) => HtmlView(name: '', objectID: '', pageType: '', collectionName: '',htmlurl: '',),
          PrayerListView.routeName: (context) => PrayerListView(
                prayerSet: '',
                prayerCollection: '',
                prayerCollectionName: '',
              ),
          PryerList.routeName: (context) => const PryerList(),
          SacramentList.routeName: (context) => SacramentList(),
          SaintsList.routeName: (context) => SaintsList(),
          MediaList.routeName: (context) => MediaList(),
          MediaDetailsView.routeName: (context) => MediaDetailsView(selectedMedia: Media.init(), typeSelected: ""),
          ParishList.routeName: (context) => ParishList(),
          SearchScreen.routeName: (context) => SearchScreen(),
          ExampleApp.routeName: (context) => ExampleApp(),
        },
      
    );
  }
}
