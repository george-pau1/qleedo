// ignore_for_file: avoid_print

import 'package:auto_size_text/auto_size_text.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:qleedo/helper/push_notification_service.dart';
import 'package:qleedo/models/Prayer.dart';
import 'package:qleedo/models/saints.dart';
import 'package:qleedo/screens/calendar.dart';
import 'package:intl/intl.dart';
import 'package:qleedo/screens/html_view_inapp.dart';
import 'package:qleedo/screens/html_view_web.dart';
import 'package:qleedo/screens/saints_details.dart';
import 'package:qleedo/service/webservices_call.dart';
import 'package:table_calendar/table_calendar.dart' as Calendar;
import 'login_dashboard.dart';
import '../widgets/appbar.widget.dart';
import 'package:qleedo/index.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

final inputFormat = DateFormat("yyyy-MM-dd");
final inputFormat1 = DateFormat("yyyy-MM-dd");
final inputFormatAPI = DateFormat("dd-MM-yyyy");

class Dashboard extends StatefulWidget {
  static const routeName = '\Dashboard';
  static const isFirstTimeLoading = 'is_First_time_loading';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  // static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool isAlertDisplay = true;
  String todaysVerse = "";
  late AnimationController _animationController;
  // late Calendar.CalendarController _calendarController;
  bool isLoadingTodaysVerse = true, isLoadingTodayPrayer = true, isLoading = true, isLoadingSaints = true;
  Map<DateTime, List<dynamic>> events = {};
  List<dynamic> mainEvents = [];
  int lodingCount = 0;
  int skipCountEvent = 0;
  List<Saints> todaysSaintList = [];
  List<PrayerToday> todaysPrayerList = [];
  double saintsWidth = deviceWidth;
  
  @override
  void initState() {
    super.initState();
    eventsFixedList.clear();
    eventsVarientsList.clear();

    // _calendarController = Calendar.CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
    //_calendarController.setCalendarFormat(CalendarFormat.week);
    getTodaysVerse();
    //getEventList();
    //getSaintsList();
    getParishEvents();
    getTodaysSaints();
    getTodayPrayer();
    final themeData = Provider.of<ThemeConfiguration>(context, listen: false);
    registerPushNotification(themeData.user);
  }

  registerPushNotification(User user) async {
    bool isNetworkAvail = await isNetworkAvailable();
    //print("..$_isNetworkAvail..MyApp.....${user.isPushEnabled}...");
    if(isNetworkAvail){
      //  final pushNotificationService = PushNotificationService(_firebaseMessaging, updateTocken, navigateToPage);
      //  pushNotificationService.initialise(user);
    }
  }

  updateTocken(String token) async {
    final themeData = Provider.of<ThemeConfiguration>(context, listen: false);
    print("...updateTocken....update tocken.----.......$token....");

    if(!themeData.user.isPushEnabled){
      registerPushnotification(themeData.user, token);
    } else {
      print(".....push notification registration done");
    }
  }

  Future<void> registerPushnotification(User user, String token) async {
    try {
      const urlParameter = "$keyParseServerUrl/installations";
      final uri = Uri.parse(urlParameter);

      //Response response = await post(uri, headers: headers, body: body,);
      final response = await post(
        uri,
        headers: <String, String>{
          'Content-Type': contentType,
          'X-Parse-Application-Id': keyParseApplicationId,
          'X-Parse-REST-API-Key': restAPIKey
        },
        body: jsonEncode(<String, String>{
          "deviceType": kIsWeb ? "web" : Platform.isAndroid ? "android" : "ios",
          "pushType" : kIsWeb ? "" : Platform.isAndroid ? "gcm" : "",
          "appVersion": "1.2.3",
          "appIdentifier" : "com.mediaindia.qleedo",
          "appName" : "Qleedo", 
          "deviceToken": token,
        }),
      );

      print("...$response...registerPushnotification..response....second.....$urlParameter.....");
      final decodedResponse = jsonDecode(response.body).cast<String, dynamic>();
      print("...${response.statusCode}...registerPushnotification..response..$decodedResponse.....");
      //bool error = getdata["error"];
      String objectID = decodedResponse.containsKey("objectId") ? decodedResponse["objectId"] : "";
      print(".......response pusgh..33......$objectID");
      if (response.statusCode == 200) {
        User userdata = User(
          objectID: user.objectID,
          firstName: user.firstName,
          lastName: user.lastName,
          gender: user.gender,
          email: user.email,
          isLogined: user.isLogined,
          isPushEnabled: true,
          calendar: user.calendar,
          versifications: user.versifications,
          translation: user.translation,
          prayer: user.prayer,
          phoneNumber: user.phoneNumber,
          parishObjectID: user.parishObjectID,
          maritalStatus: user.maritalStatus,
          church: user.church,
          form: user.form,
          language: user.language,
          pushObjectID: objectID != "" ? objectID : "",
          username: user.username,
          isFirstTimeLoading: false
        );
        await setPrefrenceUser(isUSERLOGINED, userdata);
        Provider.of<ThemeConfiguration>(context, listen: false).updateUser(userdata);
        
      } else {
        //setSnackbar(msg);
      }
    } on TimeoutException catch (_) {
      
    }
  }

 

  DateTime? parseDate(String dateString) {
    // List of possible date formats
    List<String> dateFormats = [
      "yyyy-MM-dd",
      "dd-MM-yyyy",
      "MM/dd/yyyy",
      "yyyy/MM/dd",
      "dd MMM yyyy",
    ];

    for (String format in dateFormats) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (e) {
        // Continue trying other formats
      }
    }

    // If no format works, return null
    return null;
  }

  getParishEvents() async {
    WebService service = WebService();
    Map<String, String> headers = {"accept": "application/json"};

    // Fetch 
    final response = await service.getResponse(eventList, headers);

    print("GetParishEvents: $response");

    if (response['status'] == 200) {
      // Process the feast_date events
      Map<String, dynamic> feastDates = response['data']['feast_date'];

      feastDates.forEach((dateString, eventList) {
        try {
          // Parse the date
          DateTime eventDate = DateTime.parse(dateString);

          // Add the events to the calendar
          events[eventDate] = eventList;
        } catch (e) {
          print("Invalid date format: $dateString");
        }
      });

      print("Parsed Events: $events");
    } else {
      print("Failed to fetch events: ${response['message']}");
    }

    setState(() {
      isLoading = false;
    });
  }

  getTodaysVerse() async {
    todaysVerse = "";
    WebService service = WebService();
    Map<String, String> headers = {"accept": "application/json"};
    final response = await service.getResponse(todaysVerseApi, headers);
    //print(".....getTodaysVerse....${response.statusCode}...999..");
    if(response['status'] == 200){
      Map<String, dynamic> jsonData = response; //json.decode(utf8.decode(response.bodyBytes));
      var status = jsonData[statusKey];
      if(status == 200){
        todaysVerse = jsonData[dataKey]["text"];
        isLoadingTodaysVerse = false;
      } else {
        isLoadingTodaysVerse = false;
      }
    } else {
      isLoadingTodaysVerse = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    //  _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    Future.delayed(Duration.zero, () => _showAlert(context));
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppbarWidget(
        isSlideMenu: true,
        pageTitle: '',
        isTitleImage: true,
        isPlaying: false,
        isPlayDisplay: false,
        isLanguageEnabled: false,
        isLanguageSelect: () {
          print("........select language........");
          shopPopup();
        },
        isPlaySelected: () => {},
        updateBibleCache: () => {},
        pageType: 'HOM'
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await getTodaysVerse();
          await getParishEvents();
          await getTodaysSaints();
          await getTodayPrayer();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 16),
                _buildDateHeader(),
                const SizedBox(height: 16),
                // _buildTableCalendar(context),
                todaysPrayerList.isNotEmpty 
                  ? listTodaysPrayer(themeData) 
                  : const SizedBox.shrink(),
                const SizedBox(height: 16),
                todaysVerse != "" 
                  ? displayTodaysVerse(themeData) 
                  : const SizedBox.shrink(),
                const SizedBox(height: 16),
                isLoadingSaints 
                  ? showDotProgress(themeData, deviceWidth, 40) 
                  : todaysSaintList.isNotEmpty 
                    ? mainCategoryListView(themeData) 
                    : const SizedBox.shrink(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              formatDateValue(),
              style: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const Icon(
            Icons.today,
            color: Colors.indigo,
          ),
        ],
      ),
    );
  }

  displayTodaysVerse(themeData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.format_quote, color: Colors.indigo),
                const SizedBox(width: 8),
                const Text(
                  'Today\'s Verse',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.format_quote, color: Colors.indigo),
              ],
            ),
            const SizedBox(height: 16),
            isLoadingTodaysVerse
                ? showDotProgress(themeData, deviceWidth, 40)
                : Text(
                    todaysVerse,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  listTodaysPrayer(ThemeConfiguration appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.access_time_rounded, color: Colors.indigo),
              const SizedBox(width: 8),
              const Text(
                'Prayer of the Hour',
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.separated(
            itemCount: todaysPrayerList.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return todaysPrayer(todaysPrayerList[index], appTheme);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 12);
            },
          ),
        ),
      ],
    );
  }

  todaysPrayer(PrayerToday prayerDetails, ThemeConfiguration appTheme) {
    return GestureDetector(
      onTap: () {
        todayPrayerAction(prayerDetails);
        print("........prayer object.........");
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        child: SizedBox(
          width: deviceWidth * 0.75,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      appTheme.calendarBorderColor,
                      appTheme.calendarBorderColor.withOpacity(0.7)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: appTheme.calendarBorderColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(12),
                width: 100,
                height: 100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          prayerDetails.hour,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        prayerDetails.day,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prayerDetails.name,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        prayerDetails.properties,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  todayPrayerAction(PrayerToday prayerDetails) {
    if (kIsWeb) {
      // running on the web!
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HtmlViewWeb(
            name: prayerDetails.name,
            collectionName: "",
            objectID: prayerDetails.id.toString(),
            pageType: "PL",
            htmlurl: "",
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HtmlViewInApp(
            objectID: prayerDetails.id.toString(),
            name: prayerDetails.name,
            collectionName: "",
            pageType: "PL",
            htmlurl: "",
          ),
        ),
      );
    }
  }

  mainCategoryListView(ThemeConfiguration themedata) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.event, color: Colors.indigo),
              const SizedBox(width: 8),
              const Text(
                "Occasions",
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: todaysSaintList.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print("..$index...todaysSaint.....${todaysSaintList[index]}....");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SaintsDetailsView(
                        selectedSaints: todaysSaintList[index],
                        type: "D",
                      ),
                    ),
                  );
                },
                child: showOccasion(themedata, todaysSaintList[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget showOccasion(ThemeConfiguration themedata, Saints todaysSaint) {
    return Container(
      width: saintsWidth,
      margin: const EdgeInsets.only(right: 15),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: 'saint_${todaysSaint.id}',
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(todaysSaint.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: themedata.appNavBg,
                gradient: LinearGradient(
                  colors: [themedata.appNavBg, themedata.appNavBg.withOpacity(0.9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Text(
                todaysSaint.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: themedata.appNavTextColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shopPopup() {
    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Text("First"),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text("Second"),
        )
      ],
    );
  }

  void _onDaySelected(
    BuildContext context, DateTime day, List events, List holidays) {
    var datenow = DateTime.now();
    print('CALLBACK: ......$day......._onDaySelected..............$datenow.......');
    //getPrayerDetails();
    //FirebaseCrashlytics.instance.crash();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScheduledEvents(selectedDate: day)),
    );
  }

  void _onCalendarCreated(
    DateTime first, DateTime last, Calendar.CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  void _onVisibleDaysChanged(
    DateTime first, DateTime last, Calendar.CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _showAlert(BuildContext context) async {
    //User user = getStore().state.userState.user;
    //print(
    //  "..${user.email}......show alert..${getStore().state.userState}............55555....$user.....");
    bool isAppLoadingFirst = true;
    if (isAppLoadingFirst == false) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Qleedo'),
            content: const Text('Enjoy Qleedo''s full features! Please register your account to customize your experience.'),actions: 
              <Widget>[
              TextButton(
                child: const Text('Not Now'),
                onPressed: () {
                  Navigator.of(context).pop();
                  //sharedPref.setBool(isFirstTimeLoading, false);
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context)
                    .popAndPushNamed(LoginDashboard.routeName);
                  //sharedPref.setBool(isFirstTimeLoading, false);
                },
              )
            ],
          );
        },
      );
    }
  }

  String formatDateValue() {
    String dateFirst = DateFormat('dd MMMM y').format(DateTime.now());
    String dayStr = DateFormat('EEEE').format(DateTime.now());
    String timeStr = DateFormat('jm').format(DateTime.now());
    return "$dateFirst | $dayStr | $timeStr";
  }

  dateTileBuilder(
    date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    Color fontColor = isDateOutOfRange ? Colors.black26 : Colors.black87;
    TextStyle normalStyle =
        TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = const TextStyle(
        fontSize: 17, fontWeight: FontWeight.w800, color: Colors.black87);
    TextStyle dayNameStyle = TextStyle(fontSize: 14.5, color: fontColor);
    List<Widget> children = [
      Text(dayName, style: dayNameStyle),
      Text(date.day.toString(),
          style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    if (isDateMarked == true) {
      children.add(getMarkedIndicatorWidget());
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate ? Colors.transparent : Colors.white70,
        borderRadius: const BorderRadius.all(Radius.circular(60)),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  getMarkedIndicatorWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 1, right: 1),
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
        ),
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        )
      ],
    );
  }

  void calendarTapped(CalendarTapDetails details) {
    print(".........${details.targetElement}......");
    if (details.targetElement == CalendarElement.appointment) {
      Appointment? appointment;
      if (details.appointments![0] is Appointment) {
        appointment = details.appointments![0];
        eventNavigation(appointment as Appointment);
      }
    }
  }

  eventNavigation(Appointment event) {
    if (kIsWeb) {
      // running on the web!
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HtmlViewWeb(
            name: event.subject,
            collectionName: "Lection",
            objectID: event.id.toString(),
            pageType: "CAL",
            htmlurl: "",
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HtmlViewInApp(
            name: event.subject,
            collectionName: "Lection",
            objectID: event.id.toString(),
            pageType: "CAL",
            htmlurl: "",
          ),
        ),
      );
    }
  }

  getTodayPrayer() async {
    WebService service = WebService();
    var inputFormat = DateFormat('HH:mm:ss');
    var dateNow = DateTime.now();
    var formatteDate = inputFormat.format(dateNow);
    Map<String, String> headers = {"accept": "application/json"};
    final response = await service.getResponse("$todayPrayers?day=${dateNow.weekday}&time=$formatteDate", headers);
    Map<String, dynamic> jsonData = response;
    var status = jsonData[statusKey];
    print("....${dateNow.day}...getTodayPraye--44---${dateNow.weekday}----r.333.-..${dateNow.month}...-44------$formatteDate-----..$jsonData..");
    if(status == 200) {
      var festList = jsonData[dataKey];
      var list = (festList as List).map((data) => PrayerToday.fromJson(data)).toList();
      setState(() {
        todaysPrayerList = list;
        isLoadingTodayPrayer = false;
      });
    } else {
      //data = new BaseModel(message: jsonData[messageKey], status: false, data: []);
      setState(() {
        isLoadingTodayPrayer = false;
      });
    }
  }

  getTodaysSaints() async {
    WebService service = WebService();
    var inputFormat = DateFormat('yyyy-MM-dd');
    var dateNow = DateTime.now();
    var formatteDate = inputFormat.format(dateNow);
    Map<String, String> headers = {"accept": "application/json"};
    final response = await service.getResponse("$todaySaints?day=${dateNow.day}&month=${dateNow.month}", headers);
    Map<String, dynamic> jsonData = response;//json.decode(response.body);
    var status = jsonData[statusKey];
    print("....${dateNow.day}...getTodaysSaints.333.-..${dateNow.month}...-44----..$jsonData..");
    if(status == 200) {
      var festList = jsonData[dataKey];
      var list = (festList as List).map((data) => Saints.fromJson(data)).toList();
      setState(() {
        todaysSaintList = list;
        isLoadingSaints = false;
      });
      if(todaysSaintList.length == 1) {
        saintsWidth = deviceWidth * 0.90;
      } else {
        saintsWidth = deviceWidth * 0.80;
      }
    } else {
      //data = new BaseModel(message: jsonData[messageKey], status: false, data: []);
      setState(() {
        isLoadingSaints = false;
      });
    }
  }
}