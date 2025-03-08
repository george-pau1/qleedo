
import 'package:qleedo/index.dart';

import 'package:qleedo/models/Events.dart';
import 'package:qleedo/models/prayer.dart';
import 'package:qleedo/service/webservices_call.dart';
//import 'dart:html';

class HtmlViewWeb extends StatefulWidget {
  final String pageType, collectionName, objectID, name, htmlurl;
  static const routeName = '\HtmlView';

  HtmlViewWeb({
    Key? key,
    required this.pageType,
    required this.collectionName,
    required this.objectID,
    required this.name,
    required this.htmlurl,
  }) : super(key: key);

  @override
  _HtmlViewWebState createState() => _HtmlViewWebState();
}

class _HtmlViewWebState extends State<HtmlViewWeb> {
  late String htmlUrl;
  bool isLoading = true, _isNetworkAvail = true;
  bool htmlLading = true;
  bool isContentEmpty = false;
  PrayerDetails prayerDetails  = PrayerDetails.empty();
  SacramentDetails sacramentDetails  = SacramentDetails.empty();
  EventDetails event = EventDetails.initialise();
  bool isParisEvent = false;

  @override
  void initState() {
    super.initState();
    htmlUrl = widget.htmlurl;
    // ignore: undefined_prefixed_name
   /* ui.platformViewRegistry.registerViewFactory(
        'loading',
        (int viewId) => IFrameElement()
          ..width = '640'
          ..height = '360'
          ..style.border = 'none');*/

    if (widget.pageType == "CAL") {
      getCalendarUrl();
    }
   else if(widget.pageType == "PL"){
        getPrayerDetails();
    }
    else if(widget.pageType == "SL"){
        getSacramentDetails();
    }    
     else if (widget.htmlurl.length == 0)
      getHtmlUrl();
    else {
      htmlUrl = widget.htmlurl;
      isLoading = false;
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    print("...$isLoading......get url.....${this.htmlUrl}..");
    return Scaffold(
      appBar: AppBar(
          backgroundColor: themeData.appNavBg,
          leading: navBackButton(themeData, context),
          title: Text(
            this.widget.name,
            style: TextStyle(
                color: themeData.appNavTextColor,
                fontSize: AppConstants.headingFontSize,
                fontWeight: AppConstants.fontWeight),
          ),
          elevation: 1),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: isLoading
          ? showCircularProgress(themeData, deviceWidth, deviceHeight)
          : isContentEmpty
              ? Text("Bible reading not available",
                  style: TextStyle(
                      color: themeData.textColor,
                      fontSize: AppConstants.headingFontSize,
                      fontWeight: AppConstants.fontWeight))
              : HtmlElementView(
                  viewType: isLoading ? 'loading' : widget.objectID),
    );
  }

  Future<void> getCalendarUrl() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        Map<String, String> headers = {
          "X-Parse-Application-Id": keyParseApplicationId,
          "X-Parse-REST-API-Key": restAPIKey
        };

        var urlParameter =
            '$keyParseServerUrl/classes/Lection?where={"Feast" :"${widget.objectID}"}';


        final uri = Uri.parse(urlParameter);

        Response response = await get(uri, headers: headers);

        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          var results = responseBody["results"] as List;
          if (results.length > 0) {
            var file = results[0]["Lection"]["url"];
            print(".....$file...Sacrament...url,........");
            if (kIsWeb && file.length > 0) {
              // ignore: undefined_prefixed_name
             /* ui.platformViewRegistry.registerViewFactory(
                  widget.objectID,
                  (int viewId) => IFrameElement()
                    ..width = '640'
                    ..height = '360'
                    ..src = file
                    ..style.border = 'none');*/
            }
            Future.delayed(const Duration(milliseconds: 500), () {
            // Here you can write your code

              setState(() {
                htmlUrl = file;
                isLoading = false;
                isContentEmpty = false;
              });
            });
          } else {
            setState(() {
              isContentEmpty = true;
              isLoading = false;
            });
          }
        }
      } on TimeoutException catch (_) {
        setState(() {
          isLoading = false;
        });
      } on Exception catch (_) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        _isNetworkAvail = false;
      });
    }
  }

  Future<void> getHtmlUrl() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        Map<String, String> headers = {
          "X-Parse-Application-Id": keyParseApplicationId,
          "X-Parse-REST-API-Key": restAPIKey
        };

        var requestClass =
            "${keyParseServerUrl}classes/${widget.collectionName}";

        var objectUrl =
            requestClass + '?where={"objectId":"' + widget.objectID + '"}';


        final uri = Uri.parse(objectUrl);

        Response response = await get(uri, headers: headers);

        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          var results = responseBody["results"] as List;
          if (results.length > 0) {
            var file = results[0]["${widget.collectionName}"]["url"];
            print(".....$file...Sacrament...url,........");
            setState(() {
              htmlUrl = file;
              isLoading = false;
              isContentEmpty = false;
            });
          } else {
            setState(() {
              isContentEmpty = true;
              isLoading = false;
            });
          }
        }
      } on TimeoutException catch (_) {
        setState(() {
          isLoading = false;
        });
      } on Exception catch (_) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        _isNetworkAvail = false;
      });
    }
  }

  getParishEventsDetails() async {
    var urlParameter="$eventDetails${widget.objectID}";
    WebService service = WebService();
    setState(() {
          isLoading = true;
        });
    Map<String, String> headers = {"accept": "application/json"};
    final response = await service.getResponse(urlParameter, headers);
    print("...${urlParameter}....getState.......$parishList... response.....first...${response.statusCode}....");
    Map<String, dynamic> jsonData = response; //json.decode(response.body);
    print("..$parishList.....getState response.....$jsonData....");
    var status = jsonData[statusKey];
    if(status == 200){
        Map<String, dynamic> eventList = jsonData[dataKey];
        EventDetails data = EventDetails.fromJson(eventList);
        print("...$data.....event list..5454.....${data.name}....");
        setState(() {
            isLoading = false;
            event = data;
        });
    }else{
        //data = new BaseModel(message: jsonData[messageKey], status: false, data: []);
        setState(() {
            isLoading = false;
        });
    }
    
  }


  getPrayerDetails() async {
    var urlParameter="$prayerListApi${widget.objectID}";
    WebService service = WebService();
    setState(() {
          isLoading = true;
        });
    Map<String, String> headers = {"accept": "application/json"};
    final response = await service.getResponse(urlParameter, headers);
    Map<String, dynamic> jsonData = response; //json.decode(response.body);
    print("..$parishList.....getState response.....$jsonData....");
    var status = jsonData[statusKey];
    if(status == 200){
        Map<String, dynamic> eventList = jsonData[dataKey];
        var data = PrayerDetails.fromJson(eventList);
        print("...$data.....event list..5454.....${data.name}....");
        setState(() {
            isLoading = false;
            isParisEvent = false;
            prayerDetails = data;
            htmlUrl = data.htmlUrl;
        });
    }else{
        //data = new BaseModel(message: jsonData[messageKey], status: false, data: []);
        setState(() {
            isLoading = false;
        });
    }
    
  }

  getSacramentDetails() async {
    var urlParameter="$sacramentListApi${widget.objectID}";
    WebService service = WebService();
    setState(() {
          isLoading = true;
        });
    Map<String, String> headers = {"accept": "application/json"};
    final response = await service.getResponse(urlParameter, headers);
    Map<String, dynamic> jsonData = response; //json.decode(response.body);
    print("..$parishList.....getState response.....$jsonData....");
    var status = jsonData[statusKey];
    if(status == 200){
        Map<String, dynamic> eventList = jsonData[dataKey];
        var data = SacramentDetails.fromJson(eventList);
        print("...$data.....event list..5454.....${data.name}....");
        setState(() {
            isLoading = false;
            isParisEvent = false;
            sacramentDetails = data;
            htmlUrl = data.htmlUrl;
        });
    }else{
        //data = new BaseModel(message: jsonData[messageKey], status: false, data: []);
        setState(() {
            isLoading = false;
        });
    }
    
  }


}
