import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qleedo/index.dart';
import 'package:qleedo/screens/html_view_inapp.dart';
import 'package:qleedo/screens/html_view_web.dart';
import 'package:qleedo/service/webservices_call.dart';
import 'package:qleedo/widgets/appbar.widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final inputFormat = DateFormat("yyyy-MM-dd");
final inputFormat1 = DateFormat("yyyy-MM-dd");

class ScheduledEvents extends StatefulWidget {
  final DateTime selectedDate;
  const ScheduledEvents({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _ScheduledEventsState createState() => _ScheduledEventsState();
}

class _ScheduledEventsState extends State<ScheduledEvents> with TickerProviderStateMixin {
  _DataSource events = _DataSource([]);
  bool isLoading = false;
  
  int lodingCount = 0; 
  int skipCountEvent = 0;
  List<Appointment> mainEvents = [];
  int currentMonth = -1;
  int currentYear = -1;
  
  late TabController _tabController;
  CalendarView _currentView = CalendarView.month;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    currentMonth = widget.selectedDate.month;
    currentYear = widget.selectedDate.year;
    var parishParams = "?month=${widget.selectedDate.month}&year=${widget.selectedDate.year}";
    print("....${eventsFixedList.length}....inti calendar..---$parishParams--.8888888..${eventsVarientsList.length}...");
    getParishEvents(parishParams);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    return Scaffold(
      backgroundColor: themeData.bgColor,
      appBar: AppbarWidget(
        isSlideMenu: true,
        pageTitle: '',
        isTitleImage: true,
        isPlaying: false,
        isPlayDisplay: false,
        isLanguageEnabled: false,
        isLanguageSelect: () => {},
        isPlaySelected: () => {},
        updateBibleCache: () => {},
        pageType: 'HOM',
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _buildCalendarHeader(themeData),
            Expanded(
              child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: themeData.brandColor,
                      strokeWidth: 3,
                    ),
                  )
                : _currentView == CalendarView.month 
                    ? monthViewEvents(context, themeData)
                    : weekViewEvents(context, themeData),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // Return to today's date
            getParishEvents("?month=${DateTime.now().month}&year=${DateTime.now().year}");
          });
        },
        backgroundColor: themeData.brandColor,
        child: const Icon(Icons.today),
      ),
    );
  }

  Widget _buildCalendarHeader(ThemeConfiguration themeData) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Events Calendar',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: themeData.textHeading,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: themeData.brandColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildViewToggleButton(
                      icon: Icons.calendar_view_month,
                      isSelected: _currentView == CalendarView.month,
                      onTap: () => setState(() => _currentView = CalendarView.month),
                      themeData: themeData,
                    ),
                    _buildViewToggleButton(
                      icon: Icons.calendar_view_week,
                      isSelected: _currentView == CalendarView.week,
                      onTap: () => setState(() => _currentView = CalendarView.week),
                      themeData: themeData,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: themeData.brandColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      color: themeData.brandColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMMM yyyy').format(DateTime(currentYear, currentMonth)),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: themeData.textHeading,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton({
    required IconData icon,
    required bool isSelected,
    required Function onTap,
    required ThemeConfiguration themeData,
  }) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? themeData.brandColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : themeData.brandColor,
          size: 24,
        ),
      ),
    );
  }

  Widget weekViewEvents(BuildContext context, ThemeConfiguration themeData) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SfCalendar(
          view: CalendarView.week,
          dataSource: events,
          initialSelectedDate: widget.selectedDate,
          timeSlotViewSettings: const TimeSlotViewSettings(
            minimumAppointmentDuration: Duration(minutes: 30),
            startHour: 7,
            endHour: 20,
            timeTextStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          todayHighlightColor: themeData.brandColor,
          selectionDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: themeData.brandColor, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          headerStyle: CalendarHeaderStyle(
            backgroundColor: themeData.bgColor,
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeData.textHeading,
            ),
          ),
          viewHeaderStyle: ViewHeaderStyle(
            backgroundColor: themeData.bgColor,
            dayTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: themeData.textHeading,
            ),
            dateTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: themeData.brandColor,
            ),
          ),
          appointmentTextStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          onTap: calendarTapped,
        ),
      ),
    );
  }

  Widget monthViewEvents(BuildContext context, ThemeConfiguration themeData) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: events,
          initialSelectedDate: widget.selectedDate,
          todayHighlightColor: themeData.brandColor,
          cellBorderColor: Colors.transparent,
          monthViewSettings: MonthViewSettings(
            appointmentDisplayCount: 2,
            showAgenda: true,
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
            agendaStyle: AgendaStyle(
              backgroundColor: Colors.white,
              appointmentTextStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: themeData.textHeading,
              ),
              dateTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeData.brandColor,
              ),
              dayTextStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: themeData.brandColor.withOpacity(0.7),
              ),
            ),
            dayFormat: 'EEE',
          ),
          headerStyle: CalendarHeaderStyle(
            backgroundColor: themeData.bgColor,
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeData.textHeading,
            ),
            textAlign: TextAlign.center,
          ),
          viewHeaderStyle: ViewHeaderStyle(
            backgroundColor: themeData.bgColor,
            dayTextStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: themeData.textHeading,
            ),
          ),
          monthCellBuilder: (BuildContext buildContext, MonthCellDetails details) {
            var mid = details.visibleDates.length ~/ 2.toInt();
            var midDate = details.visibleDates[0].add(Duration(days: mid));
            
            bool isToday = details.date.day == DateTime.now().day &&
                details.date.month == DateTime.now().month &&
                details.date.year == DateTime.now().year;

            return Container(
              decoration: BoxDecoration(
                color: isToday ? themeData.brandColor.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.all(2),
              child: Center(
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isToday ? themeData.brandColor : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    details.date.day.toString(),
                    style: TextStyle(
                      color: isToday
                          ? Colors.white
                          : details.date.month == midDate.month
                              ? themeData.textColor
                              : Colors.grey.shade400,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
          onTap: calendarTapped,
          onViewChanged: (ViewChangedDetails details) {
            var mid = details.visibleDates.length ~/ 2.toInt();
            var midDate = details.visibleDates[0].add(Duration(days: mid));
            var parishParams = "?month=${midDate.month}&year=${midDate.year}";
            
            if (currentMonth != midDate.month) {
              setState(() {
                currentMonth = midDate.month;
                currentYear = midDate.year;
              });
              getParishEvents(parishParams);
            }
          },
        ),
      ),
    );
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment) {
      Appointment? _appointment;
      if (details.appointments![0] is Appointment) {
        _appointment = details.appointments![0];
        var element = details.targetElement;
        eventNavigation(_appointment as Appointment);
      }
    }
  }

  eventNavigation(Appointment event) {
    String collectionName = event.notes == null ? event.location! : "API";
    if (kIsWeb) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HtmlViewWeb(
            name: event.subject,
            collectionName: collectionName,
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
            collectionName: collectionName,
            objectID: event.id.toString(),
            pageType: "CAL",
            htmlurl: "",
          ),
        ),
      );
    }
  }

  groupEventsByDate() {
    final themeData = Provider.of<ThemeConfiguration>(context, listen: false);
    int day = -1, month = -1, nextIndex = 0, loopLength = eventsFixedList.length;
    
    mainEvents.clear();
    for (int i = 0; i < loopLength; i++) {
      nextIndex = i + 1;
      nextIndex = nextIndex >= loopLength ? loopLength - 1 : nextIndex;

      var nextRecord = eventsFixedList[nextIndex];
      var object = eventsFixedList[i];
      DateTime eventDate = DateTime.parse(object['Feast_Date']['iso']);
      DateTime eventDateNext = DateTime.parse(nextRecord['Feast_Date']['iso']);

      var dateStrCurrent = inputFormat1.format(eventDate);
      var dateStrNext = inputFormat1.format(eventDateNext);
      DateTime datekey = inputFormat1.parse(dateStrCurrent);
      DateTime today = DateTime.now();
      DateTime datesKey = DateTime(today.year, datekey.month, datekey.day);

      Color eventColor = getRandomEventColor(themeData, i);

      if (dateStrCurrent == dateStrNext) {
        mainEvents.add(Appointment(
          subject: object["name"],
          startTime: datesKey,
          id: object["code"],
          endTime: datesKey.add(Duration(hours: 1)),
          color: eventColor,
          location: "FixedFeasts",
        ));
      } else {
        mainEvents.add(Appointment(
          subject: object["name"],
          startTime: datesKey,
          id: object["code"],
          endTime: datesKey.add(Duration(hours: 1)),
          color: eventColor,
          location: "FixedFeasts",
        ));
      }

      day = eventDate.day;
      month = eventDate.month;
    }

    for (var i = 0; i < eventsVarientsList.length; i++) {
      var object = eventsVarientsList[i];
      DateTime eventDate = DateTime.parse(object['eventdate']);
      DateTime eventDateNext = DateTime.parse(object['eventdate']);
      var dateStrCurrent = inputFormat1.format(eventDate);
      var dateStrNext = inputFormat1.format(eventDateNext);
      DateTime datekey = inputFormat1.parse(dateStrCurrent);
      DateTime today = DateTime.now();
      DateTime datesKey = DateTime(today.year, datekey.month, datekey.day);
      var eventName = object["name"];
      var code = "$eventName$i";
      
      Color eventColor = getRandomEventColor(themeData, i + loopLength);

      mainEvents.add(Appointment(
        subject: eventName,
        startTime: datesKey,
        id: code,
        endTime: datesKey.add(Duration(hours: 1)),
        color: eventColor,
        location: "movable",
      ));
    }
    
    events = _DataSource(mainEvents);
    setState(() {});
    return mainEvents;
  }

  Color getRandomEventColor(ThemeConfiguration themeData, int index) {
    // Create a list of visually appealing colors
    List<Color> colors = [
      themeData.brandColor,
      Colors.teal,
      Colors.amber.shade700,
      Colors.purple,
      Colors.indigo,
      Colors.green.shade600,
    ];
    
    return colors[index % colors.length];
  }

  void getEventList() async {
    bool avail = true;
    if (avail) {
      if (mounted)
        setState(() {
          isLoading = true;
        });
      var urlParameters = '$keyParseServerUrl/classes/FixedFeasts?where={"Status" : "A"}&order=Feast_Date&limit=500';
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
        var list = getdata["results"] as List;
        groupEventsByList(list);
        events = _DataSource(groupEventsByList(list));
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        //print("......getPrayerCollectio....Error.....${response.statusCode}....");
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  groupEventsByList(list) {
    final themeData = Provider.of<ThemeConfiguration>(context, listen: false);
    int day = -1, month = -1, nextIndex = 0, loopLength = list.length;
    
    for (int i = 0; i < loopLength; i++) {
      nextIndex = i + 1;
      nextIndex = nextIndex >= loopLength ? loopLength - 1 : nextIndex;

      var nextRecord = list[nextIndex];
      var object = list[i];
      DateTime eventDate = DateTime.parse(object['Feast_Date']['iso']);
      DateTime eventDateNext = DateTime.parse(nextRecord['Feast_Date']['iso']);

      var dateStrCurrent = inputFormat1.format(eventDate);
      var dateStrNext = inputFormat1.format(eventDateNext);
      DateTime datekey = inputFormat1.parse(dateStrCurrent);
      DateTime today = DateTime.now();
      DateTime datesKey = DateTime(today.year, datekey.month, datekey.day);

      Color eventColor = getRandomEventColor(themeData, i);

      if (dateStrCurrent == dateStrNext) {
        mainEvents.add(Appointment(
          subject: object["name"],
          startTime: datesKey,
          id: object["code"],
          endTime: datesKey.add(Duration(hours: 1)),
          color: eventColor,
          location: "FixedFeasts",
        ));
      } else {
        mainEvents.add(Appointment(
          subject: object["name"],
          startTime: datesKey,
          id: object["code"],
          endTime: datesKey.add(Duration(hours: 1)),
          color: eventColor,
          location: "FixedFeasts",
        ));
      }

      day = eventDate.day;
      month = eventDate.month;
    }
    return mainEvents;
  }

  getParishEvents(params) async {
    print(".....get parish event......getParishEvents..API..5656........$params..");
    final themeData = Provider.of<ThemeConfiguration>(context, listen: false);
    WebService service = WebService();
    
    setState(() {
      isLoading = true;
      mainEvents.clear();
    });
    
    Map<String, String> headers = {"accept": "application/json"};
    final response = await service.getResponse(eventList + params, headers);
    Map<String, dynamic> jsonData = json.decode(response.body);
    var status = jsonData[statusKey];
    
    if (status == 200) {
      Map<String, dynamic> eventList = jsonData[dataKey];
      var dataList = eventList.keys;
      
      for (var i = 0; i < dataList.length; i++) {
        var dateListsInner = eventList[dataList.elementAt(i)];

        if (dateListsInner.length > 0) {
          DateTime eventDate = DateFormat("yyyy-MM-dd").parse(dataList.elementAt(i));
          DateTime datesKey = DateTime(eventDate.year, eventDate.month, eventDate.day);

          for (var j = 0; j < dateListsInner.length; j++) {
            var names = dateListsInner[j]['event__event_name'];
            var ids = dateListsInner[j]['event'];
            
            Color eventColor = getRandomEventColor(themeData, j + i);
            
            mainEvents.add(Appointment(
              subject: names,
              startTime: datesKey,
              id: ids.toString(),
              endTime: datesKey.add(const Duration(hours: 4)),
              color: eventColor,
              notes: "API",
            ));
          }
        }
      }
      events = _DataSource(mainEvents);
    }
    
    setState(() {
      isLoading = false;
    });
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }
}




