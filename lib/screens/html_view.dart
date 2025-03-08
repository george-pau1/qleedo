
import 'package:qleedo/models/Events.dart';
import 'package:qleedo/service/webservices_call.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:qleedo/index.dart';

class HtmlView extends StatefulWidget {
  final String pageType, collectionName, objectID, name, htmlurl;
  static const routeName = '\HtmlView';

  const HtmlView({
    Key? key,
    required this.pageType,
    required this.collectionName,
    required this.objectID,
    required this.name,
    required this.htmlurl,
  }) : super(key: key);

  @override
  _HtmlViewState createState() => _HtmlViewState();
}

class _HtmlViewState extends State<HtmlView> {
  String htmlUrl="";
  bool isLoading = true, _isNetworkAvail = true;
  bool htmlLading = true;
  bool isContentEmpty =  false;
  //late WebViewController controller;
  EventDetails event = EventDetails.initialise();
  bool isParisEvent = false;
  @override
  void initState() {
    super.initState();
    initialiseWebView();
    print("...${widget.htmlurl}....get html data..--000----8888-----..${widget.pageType}....");
    if(widget.collectionName == "API"){
        if(mounted){
          setState(() {
            isParisEvent = true;
          });
        }
        getParishEventsDetails();
    }
    else if(widget.pageType == "PR"){
        getHtmlUrl();
    }
    else if(widget.pageType == "CAL"){
        getCalendarUrl();
    }
    else if(widget.htmlurl.isEmpty){
        getHtmlUrl();
    }else{
        htmlUrl = widget.htmlurl;
        isLoading = false;
    }
      
  }

  initialiseWebView(){

  }

  // initialiseWebView(){
  //   controller = WebViewController()
  // ..setJavaScriptMode(JavaScriptMode.unrestricted)
  // ..setBackgroundColor(const Color(0x00000000))
  // ..setNavigationDelegate(
  //   NavigationDelegate(
  //     onProgress: (int progress) {
  //       // Update loading bar.
  //     },
  //     onPageStarted: (String url) {
  //       if (url.startsWith('tel:')) {
  //               //_launchCaller("tel:1-408-555-5555");
  //               _launchCaller(url);
  //             }
  //     },
  //     onPageFinished: (String url) {},
  //     onWebResourceError: (WebResourceError error) {},
  //     onNavigationRequest: (NavigationRequest request) {
  //       if (request.url.startsWith('https://www.youtube.com/')) {
  //         return NavigationDecision.prevent;
  //       }
  //       return NavigationDecision.navigate;
  //     },
  //   ),
  // );
  // //..loadRequest(Uri.parse(widget.htmlurl.isEmpty ? htmlUrl : widget.htmlurl));
  // if(widget.htmlurl.isNotEmpty){
  //     controller.loadRequest(Uri.parse(widget.htmlurl));
  // }
  // }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
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
      body: isLoading ? 
        showCircularProgress(themeData,deviceWidth ,deviceHeight) :
        isContentEmpty ? Text("Bible reading not available", style: TextStyle(color: themeData.textColor,
                fontSize: AppConstants.headingFontSize,
                fontWeight: AppConstants.fontWeight))
        : isParisEvent ? loadEventView() :loadWebview() ,
        );
     // }),
   // );
  }

  loadWebview(){

  }

  loadEventView(){
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.10, horizontal: MediaQuery.of(context).size.width * 0.05),
      padding:  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(10),
     color: Color.fromARGB(255, 232, 234, 232),
  ),
      child: Column(
        children: [
          rowEventData("Event Name :",event.name),
          const SizedBox(height: 10,),
          rowEventData("Event Description :",event.description),
          const SizedBox(height: 10,),
          rowEventData("Event Location :",event.occurancePlace),
          const SizedBox(height: 10,),
          event.festivalName.isNotEmpty ? rowEventData("Event Festival :",event.festivalName) :Container(),
          rowEventData("Event From Date :",event.fromDate),
          const SizedBox(height: 10,),
          rowEventData("Event To Date :",event.toDate),
          const SizedBox(height: 10,),

        ],
      ),
    );
  }

  rowEventData(String label, String data){
    return Row(
      children:  [
        Expanded(
      child: Text(label, style: const TextStyle(color: Colors.black87, fontSize: 16,fontWeight: FontWeight.bold ),),
    ),
           Expanded(
      child: Text(data, style: const TextStyle(color: Colors.black87, fontSize: 16, ),),
    ),
      ],
    );
  }

  // loadWebview(){
  //   return WebViewWidget(controller: controller);
  // }

  _launchCaller(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> getCalendarUrl() async {
    print("...getCalendarUrl.....before api..");
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        Map<String, String> headers = {
          "X-Parse-Application-Id": keyParseApplicationId,
          "X-Parse-REST-API-Key": restAPIKey
        };
        
        var urlParameter =
            '$keyParseServerUrl/classes/${widget.collectionName}?where={"code" :"${widget.objectID}"}';


        final uri = Uri.parse(urlParameter);

      Response response = await get(uri,headers: headers);
        print("..${response.statusCode}...getCalendarUrl..0000...before api........$urlParameter..");

        if (response.statusCode == 200) {
           var responseBody = json.decode(response.body);
           var results = responseBody["results"] as List;
           print("..${results.length}....getCalendarUrl.....after api........$results..");

           if(results.length > 0 ){
             var file = results[0]["URL"];
             print(".....$file...Sacrament...url,....000000....");
             setState(() {
               htmlUrl = file;
               isLoading = false;
               isContentEmpty = file.isEmpty ? true  : false;
             });
        //     controller.loadRequest(Uri.parse(htmlUrl));
           }else{
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
            "$keyParseServerUrl/classes/${widget.collectionName}";

        var objectUrl ='$requestClass?where={"objectId":"${widget.objectID}"}';

        print("........prayer data view......$objectUrl.....");
        final uri = Uri.parse(objectUrl);

      Response response = await get(uri,headers: headers);
        print("........prayer data view....response.......${response.statusCode}...66666..");

        if (response.statusCode == 200) {
           var responseBody = json.decode(response.body);
           var results = responseBody["results"] as List;
           print("........prayer data view....response..1111.....$results...00000..");

           if(results.isNotEmpty ){
             var file = results[0][widget.collectionName]["url"];
             print("........prayer data view....response..3333.....$file...22222..");

             setState(() {
               htmlUrl = file;
               isLoading = false;
             });
     //        controller.loadRequest(Uri.parse(htmlUrl));
           }else{
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
    //print("...${urlParameter}....getState.......$urlParameter... response.....first...${response.statusCode}....");
    Map<String, dynamic> jsonData = response; //json.decode(response.body);
    print("..$urlParameter.....getState response.....$jsonData....");
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

}
