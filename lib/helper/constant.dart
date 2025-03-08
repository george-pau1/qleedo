



import 'package:qleedo/index.dart';
import 'package:qleedo/models/saints.dart';
import 'package:qleedo/models/common.dart';

double deviceHeight = 0;
double deviceWidth = 0;
final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);

//Production Sashido Keys
const String keyParseApplicationId = "AcHG0EJiXqflSC7NbZ5PYtod4mSBfy7u0MqBjj0Z";
const String keyParseMasterKey = "hwySVBGm20Xv8F0jc0lhnWIAI0Y3R1XoDAsjlNnC";
const String keyParseServerUrl = "https://pg-app-cwmbz0wd7eqrjvx5cr32ftd4gsdp3j.scalabl.cloud/1";
const String keyClientKey= "U9Yua0QVFW7oLRwH73whkCOlSCffUsOifKwfuMqV";
const String keyLiveQueryKey = "wss://pg-app-cwmbz0wd7eqrjvx5cr32ftd4gsdp3j.scalabl.cloud/1/";
const String restAPIKey = "Puqq9HpXVf0WUkBbHXNX8hwybv88xejYepluuUap";
//const String qleedoAPIUrl = "http://35.229.62.19:8080/api/client/";
//const String qleedoMediaPath = "http://35.229.62.19:8080";
const String qleedoAPIUrl = "http://20.42.103.225:8080/api/client/";
const String qleedoMediaPath = "http://ec2-16-171-133-143.eu-north-1.compute.amazonaws.com";

/*
final String keyParseApplicationId = "AcHG0EJiXqflSC7NbZ5PYtod4mSBfy7u0MqBjj0Z";
final String keyParseMasterKey = "BXIRq0T5jkbJlJxKwVy4AkNSrFNBhm76Cfp9SPhM";
final String keyParseServerUrl = "https://pg-app-ewpudi96b1rdtdbljc0qsruer3uqy4.scalabl.cloud/1";
final String keyClientKey= "kzOwRZHcYDUUTDXnVgD5VyihhM9PBcCNSmhp3fl9";
final String keyLiveQueryKey = "wss://pg-app-ewpudi96b1rdtdbljc0qsruer3uqy4.scalabl.cloud/1/";
final String restAPIKey = "Ki3fv5XMDeNzEpYeRt52K10uJmMGdC9PPSpNhglV";*/


const String calendarEventsUrl = 'classes/FixedFeasts?where={"Status" : "A"}&order=Feast_Date';
const String calendarEventsWithLimitUrl = '/classes/FixedFeasts?where={"Status" : "A"}&order=Feast_Date&limit=500';
const String calendarEventsWithSkipCountUrl = '/classes/FixedFeasts?where={"Status" : "A"}&order=Feast_Date&limit=500&skip=';

const String contentType = "application/json";
const String isUSERLOGINED = "isUserLogined";

FontWeight fontRegular = FontWeight.w400;
FontWeight fontSemiBold = FontWeight.w600;
FontWeight fontMedium = FontWeight.w500;
FontWeight fontBold = FontWeight.bold;
FontWeight fontLight = FontWeight.w200;
const applicationName = "Qleedo";

List<dynamic> eventsFixedList = [];
List<dynamic> eventsVarientsList = [];
List<Saints> saintsListMain = [];


List<Season> seasonList = [];
List<Version> versionList = [];
List<Translation> translationList = [];
List<Suitable> suitableList = [];

abstract class AppConstants {
  //Live Production
  static const  String keyAppName = "";

  //Development
  /*static const String keyAppName = "";
  static const String keyParseApplicationId = "pe6dbYLHMXuy3eb2GYT4EFFOS4phAP4MPhQCNm9f";
  static const String keyParseMasterKey = "BXIRq0T5jkbJlJxKwVy4AkNSrFNBhm76Cfp9SPhM";
  static const String keyParseServerUrl = "https://pg-app-ewpudi96b1rdtdbljc0qsruer3uqy4.scalabl.cloud/1/";*/



  static const String chooseThemeLbl="Choose Theme";

  static const double headingFontSize = 20.0;
  static const FontWeight fontWeight = FontWeight.w900;

  //static const String SACREMENTURL = keyParseServerUrl+"classes/Sacrament";
  static const int timeOut = 50;

  

}

  // rest api url path
  const String groupedMediaList = "group_media";
  const String mediaFestivalUrl="festival_with_media_list/";
  const String mediaResourceUrl="mediaresources/";
  const String mediaApi="media/";
  const String saintsApi="saints/";
  const String todaySaints="todays_saints/";
  const String todayPrayers="todays_prayer/";
  const String mediaByFest="?festival__festival__icontains=";
  const String eventList="event_list_monthly/";
  const String eventDetails ="events/";
  const String parishList ="find_parish/";
  const String statusKey = 'status';
  const String messageKey = 'message';
  const String dataKey = 'data';
  const String languageKey = 'languages';
  const String collectionKey = 'prayer_subcollections';
  const String translationsKey = 'translations';
  const String hoursKey = 'hours';
  const String daysKey = 'days';
  const String sacramentTypesKey = 'sacrament_types';
  const String reslutsKey = 'results';
  const String previousKey = 'previous';
  const String nextKey = 'next';
  const String countKey = 'count';
  const String eventIdPrefix ='EVENT_ID_PREFIX';
  const String eventIdParish ='EVENT_ID_PARISH';
  const String todaysVerseApi ='today_verse';
  const String prayerListApi = 'prayer_translated/';
  const String prayerSacramentPropertiesAPi = 'prayer_and_sacrament_properties/';
  const String sacramentListApi = 'sacrament_translated/';
  const String dynamicDataList = 'dynamic_data/';
  const String prayerKey = 'prayers';
  const String sacramentKey = 'sacraments';
  const String festivalKey = 'festivals';


  const String jqueryScriptForPrayer = '''<!DOCTYPE html><html style="-webkit-text-size-adjust: none;-webkit-tap-highlight-color: rgba(0,0,0,0);"> <head><script src="https://code.jquery.com/jquery-1.11.2.min.js" type="text/javascript"></script>''';
  
  const String jsScriptTag = '''<script type="text/javascript">\$(document).ready(function() { for(var i = 0; i<document.getElementsByName("qleedohideDivname").length; i++) { document.getElementsByName("qleedohideDivname")[i].style.display = "none"; } onClicker = function(id) {\$(id).slideToggle("slow", "swing"); }});</script>''';

  const String cssStyleTag = '''<style> body { background-color:transparent;color: #000000;font-size: medium; font-family: Helvetica; line-height: 1.43;} div.clergry_note { display: none } div.special_prayer { display: none; } </style>''';


  const String cssStyleTagClergy = '''<style> body { background-color:transparent; color: #000000; font-size: medium;  font-family: Helvetica; line-height: 1.43; } div.clergry_note { height: auto; font-size: 100%; padding: 7px; background: #f2e4d7; } { display: none; } </style>''';

  const String lectionHtmlStart = '''<style>  h4{ margin-top: 10px; margin-bottom: 10px; line-height: 1.1; } h3{ margin-top: 30px; margin-bottom: 10px; line-height: 1.1;  } p { margin: 0 0 10px;  } </style>''';
  const String prayerEndTag = "</body></html>";

  const String cssEndTag = "</style></head><body>";
  const String mimeType = "text/html";
  const String encoding = "UTF-8";
  const String emptyHtml = '''<!DOCTYPE html><html><title>Online HTML Editor</title><head></head><body><h1>Prayer</h1><div>Bible reading not available</div></body></html>''';
  const int pageSize = 10;

  //Prayer Filter
  const String languageTitle = "Language";
  const String collectionTitle = "Collections";
  const String translationTitle = "Translation";
  const String daysTitle = "Days";
  const String hoursTitle = "Hours";
  const String sacramentTypeTitle = "Sacrament Type";
  const String prayerTitle = "Prayer";
  const String sacramentTitle = "Sacrament";
  const String festivalTitle = "Festival";

