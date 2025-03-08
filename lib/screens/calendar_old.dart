// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:qleedo/screens/html_view_inapp.dart';
// import 'package:table_calendar/table_calendar.dart';
// import '../widgets/appbar.widget.dart';
// import '../widgets/drawer.dart';
// import 'package:qleedo/index.dart';
// import 'package:qleedo/screens/html_view.dart';
// import 'package:qleedo/screens/html_view_web.dart';



// final inputFormat = DateFormat("yyyy-MM-dd");
// final inputFormat1 = DateFormat("yyyy-MM-dd");


// class MonthCalendarView extends StatefulWidget {
//   static const routeName = '\CalendarView';
//   MonthCalendarView({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MonthCalendarView>
//     with TickerProviderStateMixin {
//   Map<DateTime, List<dynamic> > _events = {};
//   List<EventFeast> _selectedEvents = [];
//   late AnimationController _animationController;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   late CalendarController _calendarController;

//   @override
//   void initState() {
//     super.initState();
//     final _selectedDay = DateTime.now();
//     getEventList();

//     //_selectedEvents = _events[_selectedDay] ?? [];
//     _calendarController = CalendarController();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );

//     _animationController.forward();
//   }

//   void getEventList() async {

//     var urlParameters = '$keyParseServerUrl/classes/FixedFeasts?where={"Status" : "A"}&order=Feast_Date';
//     final uri = Uri.parse(urlParameters);
//     final response = await get(
//       uri,
//       headers: <String, String>{
//         'Content-Type': contentType,
//         'X-Parse-Application-Id': keyParseApplicationId,
//         'X-Parse-REST-API-Key': restAPIKey
//       },);



//     if (response.statusCode == 200) {
//       var getdata = json.decode(response.body);
//       var list = getdata["results"] as List;
//       groupEventsByDate(list);

//     } else {
//       //print("......getPrayerCollectio....Error.....${response.statusCode}....");
//     }
//   }

//   groupEventsByDate(list) {
//     int day = -1, month = -1, nextIndex = 0, loopLength = list.length;
//     List<EventFeast> strList = [];
//     strList.clear();
//     Map<DateTime, List> _holidays = {};
//     for (int i = 0; i < loopLength; i++) {
//       nextIndex = i + 1;
//       nextIndex = nextIndex >= loopLength ? loopLength - 1 : nextIndex;

//       var nextRecord = list[nextIndex];
//       var object = list[i];
//       DateTime eventDate = DateTime.parse(object['Feast_Date']['iso']);
//       DateTime eventDateNext = DateTime.parse(nextRecord['Feast_Date']['iso']);

//       var dateStrCurrent = inputFormat1.format(eventDate);
//       var dateStrNext = inputFormat1.format(eventDateNext);
//       DateTime datekey = inputFormat1.parse(dateStrCurrent);
//       DateTime today = DateTime.now();
//       DateTime datesKey = DateTime(today.year, datekey.month, datekey.day);

//       if (dateStrCurrent == dateStrNext) {
//         strList.add(EventFeast(name:object["name"], code: object["code"], date: datesKey ));
//       } else {
//         strList.add(EventFeast(name:object["name"], code: object["code"], date: datesKey  ));
//         _holidays[datesKey] = strList.toList();
//         strList.clear();
//       }

//       day = eventDate.day;
//       month = eventDate.month;
//     }

//     setState(() {
//       _events = _holidays;
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _onDaySelected(DateTime day, List events, List holidays) {
//     //print("..$holidays..._onDaySelected....9999...$events.....$day.");
//     setState(() {
//       _selectedEvents = events.length == 0 ? [] : events as List<EventFeast>;
//     });
//     //print("..$_selectedEvents..._onDaySelected....101010...$events.....$day.");

//   }

//   void _onVisibleDaysChanged(
//       DateTime first, DateTime last, CalendarFormat format) {
//     //print('CALLBACK: _onVisibleDaysChanged');
//   }

//   void _onCalendarCreated(
//       DateTime first, DateTime last, CalendarFormat format) {
//     //print('CALLBACK: _onCalendarCreated');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeData = Provider.of<ThemeConfiguration>(context);

//     return Scaffold(
//       appBar: AppbarWidget(
//           isSlideMenu: true,
//           pageTitle: '',
//           isTitleImage: true,
//           isPlaying : false,
//         isPlayDisplay: false,
//         isLanguageEnabled: false,
//         isLanguageSelect: ()=> {},
//         isPlaySelected: ()=> {},
//         updateBibleCache:()=> {} ,
//           pageType: 'CAL'),
//       drawer: AppDrawer(),
//       body: Column(
//         mainAxisSize: MainAxisSize.max,
//         children: <Widget>[
//           // Switch out 2 lines below to play with TableCalendar's settings
//           //-----------------------
//           _buildTableCalendar(themeData),
//           //_buildTableCalendarWithBuilders(),
//           const SizedBox(height: 8.0),
//           _selectedEvents != null && _selectedEvents.length > 0 ?
//           Expanded(child: _buildEventList(themeData)) : Container(),
//         ],
//       ),
//     );
//   }

//   // Simple TableCalendar configuration (using Styles)
//   Widget _buildTableCalendar(ThemeConfiguration themeData) {
//     return TableCalendar(
      
//       initialSelectedDay: DateTime.now(),
//       calendarController: _calendarController,
//       events: _events,
//       //holidays: _holidays,
//       startingDayOfWeek: StartingDayOfWeek.monday,
//       headerVisible: true,
//       rowHeight: 65.0,
//       calendarStyle: CalendarStyle(
//         selectedColor: Colors.deepOrange[400] as Color,
//         todayColor: Colors.deepOrange[200] as Color,
//         markersColor: Colors.brown[700] as Color,
//         outsideDaysVisible: false,

//       ),
//       headerStyle: HeaderStyle(
//         formatButtonVisible: false,
//         formatButtonTextStyle:
//             TextStyle().copyWith(color: themeData.appNavBg, fontSize: 15.0),
//         formatButtonDecoration: BoxDecoration(
//           color: Colors.deepOrange[400],
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         leftChevronIcon: Icon(
//           Icons.arrow_back,
//           size: 30,
//           color: themeData.appNavBg,
//         ),
//         rightChevronIcon: Icon(
//           Icons.arrow_forward,
//           size: 30,
//           color: themeData.appNavBg,
//         ),
//         centerHeaderTitle: true,
//         titleTextStyle: TextStyle().copyWith(
//             color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.bold),
//       ),
//       builders: CalendarBuilders(
//         selectedDayBuilder: (context, date, _) {
//           return FadeTransition(
//             opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
//             child: Container(
//               alignment: Alignment.center,
//               margin: const EdgeInsets.all(4.0),
//               //width: 58,
//               //height: 58,
//               decoration: new BoxDecoration(
//                 color: themeData.calendarSelectedColor,
//                 shape: BoxShape.circle,
//               ),
//               child: Text(
//                 '${date.day}',
//                 textAlign: TextAlign.center,
//                 style: TextStyle().copyWith(fontSize: 16.0),
//               ),
//             ),
//           );
//         },
//         todayDayBuilder: (context, date, _) {
//           return Container(
//             margin: const EdgeInsets.all(4.0),
//             alignment: Alignment.center,
//             //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//             decoration: new BoxDecoration(
//                 color: themeData.calendarTodaysColor,
//                 shape: BoxShape.circle,
//             ),
//             child: Text(
//               '${date.day}',
//               style: TextStyle().copyWith(fontSize: 16.0, color: themeData.calendarBorderColor ),
//             ),
//           );
//         },
//         markersBuilder: (context, date, events, holidays) {
//           final children = <Widget>[];

//           //print("...$date...event.......$holidays.... marker.....$events.....");

//           if (events.isNotEmpty) {
//             //print("......event add......");
//             children.add(
//                _buildEventsMarker(date, events, themeData),
//             );
//           }

//           if (holidays.isNotEmpty) {
//             children.add(
//               Positioned(
//                 right: -2,
//                 top: -2,
//                 child: _buildHolidaysMarker(),
//               ),
//             );
//           }

//           return children;
//         },
//       ),
//       onDaySelected: _onDaySelected,
//       onVisibleDaysChanged: _onVisibleDaysChanged,
//       onCalendarCreated: _onCalendarCreated,
//     );
//   }

//   List<dynamic> _getEventsForDay(DateTime day) {
//     return _events[day] ?? [];
//   }

//   // More advanced TableCalendar configuration (using Builders & Styles)
//   /*Widget _buildTableCalendarWithBuilders() {
//     return TableCalendar(
//       //locale: 'pl_PL',
//       calendarController: _calendarController,
//       events: _events,
//       holidays: _holidays,
//       initialCalendarFormat: CalendarFormat.month,
//       formatAnimation: FormatAnimation.slide,
//       startingDayOfWeek: StartingDayOfWeek.sunday,
//       availableGestures: AvailableGestures.all,
//       availableCalendarFormats: const {
//         CalendarFormat.month: '',
//         CalendarFormat.week: '',
//       },
//       calendarStyle: CalendarStyle(
//         outsideDaysVisible: false,
//         weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
//         holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
//       ),
//       daysOfWeekStyle: DaysOfWeekStyle(
//         weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
//       ),
//       headerStyle: HeaderStyle(
//         centerHeaderTitle: true,
//         formatButtonVisible: false,
//       ),
//       builders: CalendarBuilders(
//         selectedDayBuilder: (context, date, _) {
//           return FadeTransition(
//             opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
//             child: Container(
//               //margin: const EdgeInsets.all(4.0),
//               // padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//               color: Colors.deepOrange[300],
//               child: Text(
//                 '${date.day}',
//                 style: TextStyle().copyWith(fontSize: 16.0),
//               ),
//             ),
//           );
//         },
//         todayDayBuilder: (context, date, _) {
//           return Container(
//            // margin: const EdgeInsets.all(4.0),
//             //padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//             color: Colors.amber[400],
//             //width: 100,
//             //height: 100,
//             child: Text(
//               '${date.day}',
//               style: TextStyle().copyWith(fontSize: 16.0),
//             ),
//           );
//         },
//         markersBuilder: (context, date, events, holidays) {
//           final children = <Widget>[];

//           if (events.isNotEmpty) {
//             children.add(
//               Positioned(
//                 left: 0,
//                 top: 0,
//                 child: _buildEventsMarker(date, events),
//               ),
//             );
//           }

//           if (holidays.isNotEmpty) {
//             children.add(
//               Positioned(
//                 right: -2,
//                 top: -2,
//                 child: _buildHolidaysMarker(),
//               ),
//             );
//           }

//           return children;
//         },
//       ),
//       onDaySelected: (date, events, holidays) {
//         _onDaySelected(date, events, holidays);
//         _animationController.forward(from: 0.0);
//       },
//       onVisibleDaysChanged: _onVisibleDaysChanged,
//       onCalendarCreated: _onCalendarCreated,
//     );
//   }*/

//   Widget _buildEventsMarker(DateTime date, List events,ThemeConfiguration themeData) {
//     return Container(
//       margin: const EdgeInsets.all(4.0),
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border:Border.all(color: themeData.calendarBorderColor, width: 3),)
//     );
//   }

//   Widget _buildHolidaysMarker() {
//     return Icon(
//       Icons.add_box,
//       size: 20.0,
//       color: Colors.blueGrey[800],
//     );
//   }

//   Widget _buildEventList(ThemeConfiguration themeData) {
//     return Container(
//         margin: EdgeInsets.symmetric(vertical: 4, horizontal: 25),
//         child: ListView.separated(
//             separatorBuilder: (context, index) => Divider(
//                   height: 2,
//                   color: themeData.appNavBg,
//                 ),
//             itemCount: _selectedEvents.length,
//             itemBuilder: (BuildContext ctxt, int index) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children:[
//                 index == 0 ?
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   decoration: BoxDecoration(
//                         border: Border.all(width: 0.2),
//                         color: themeData.appNavBg
//                       ),
//                   margin:const EdgeInsets.symmetric(vertical: 4.0),
//                   padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//                   child: Text("Events", style: TextStyle(color: themeData.textHeading, fontSize: 18, fontWeight: FontWeight.w800),),
//                 ) : Container(),
//                 ListTile(
//                       title: Text(_selectedEvents[index].name),
//                       onTap: () { onClickEvent(_selectedEvents[index]); },
//                       trailing: Icon(
//                         Icons.arrow_forward,
//                         size: 20,
//                         color: themeData.appNavBg,
//                       )),
//                 ],
//               );
//             }));
//   }

//   onClickEvent(EventFeast event){
//       if (kIsWeb) {
//                       // running on the web!
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => HtmlViewWeb(
//                                     name: event.name,
//                                     collectionName: "Lection",
//                                     objectID: event.code,
//                                     pageType: "CAL",
//                                     htmlurl: "",
//                             ),
//                           ));
//       } else{
//                  Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => HtmlViewInApp(
//                                     name: event.name,
//                                     collectionName: "Lection",
//                                     objectID: event.code,
//                                     pageType: "CAL",
//                                     htmlurl: "",
//                                     )));
//       }                   

//   }
// }

// class EventFeast{
//   final String name;
//   final String code;
//   final DateTime date;

//   const EventFeast({
//     required this.name,
//     required this.code,
//     required this.date,
//   }); 
// }

// class Event {
//   final String title;

//   const Event(this.title);

//   @override
//   String toString() => title;
// }
