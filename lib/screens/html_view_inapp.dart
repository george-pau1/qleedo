
import 'package:qleedo/models/Events.dart';
import 'package:qleedo/models/Media.dart';
import 'package:qleedo/models/prayer.dart';
import 'package:qleedo/service/webservices_call.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:qleedo/index.dart';
//import 'package:video_player/video_player.dart';
//import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HtmlViewInApp extends StatefulWidget  {
  final String pageType, collectionName, objectID, name, htmlurl;
  static const routeName = '\HtmlView';

  const HtmlViewInApp({
    Key? key,
    required this.pageType,
    required this.collectionName,
    required this.objectID,
    required this.name,
    required this.htmlurl,
  }) : super(key: key);

  @override
  _HtmlViewInAppState createState() => _HtmlViewInAppState();
}

class _HtmlViewInAppState extends State<HtmlViewInApp> with TickerProviderStateMixin{
  String htmlUrl="";
  String htmlContent="";
  bool isLoading = true, _isNetworkAvail = true;
  bool htmlLading = true;
  bool isContentEmpty =  false;
  EventDetails event = EventDetails.initialise();
  bool isParisEvent = false;
  String htmlStart =  "$jqueryScriptForPrayer $jsScriptTag $cssStyleTag $lectionHtmlStart";
  String htmlEnd =  prayerEndTag;
  PrayerDetails prayerDetails  = PrayerDetails.empty();
  SacramentDetails sacramentDetails  = SacramentDetails.empty();
  int selectedIndex=0;

  //Media Details Display
   List<Tab> _tabs = [];
   late TabController _tabController;


  final GlobalKey webViewKey = GlobalKey();

  // InAppWebViewController? webViewController;
  // InAppWebViewSettings settings = InAppWebViewSettings(
  //     //useShouldOverrideUrlLoading: true,
  //     //mediaPlaybackRequiresUserGesture: false,
  //     //allowsInlineMediaPlayback: true,
  //     iframeAllow: "camera; microphone",
  //     iframeAllowFullscreen: true,
  //     defaultFontSize: 20,
  //     initialScale: 6,
  //     textZoom: 200,
  //     javaScriptEnabled: true,
  //     allowUniversalAccessFromFileURLs: true,
  //     allowFileAccessFromFileURLs: true,
  // );
  // PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  // void initState() {
  //   super.initState();
  //   //initialiseWebView();
  //   print("...${widget.htmlurl}....get html data..--000----8888-----..${widget.pageType}....");
  //   if(widget.collectionName == "API"){
  //       getParishEventsDetails();
  //   }
  //   else if(widget.pageType == "PL"){
  //       getPrayerDetails();
  //   }
  //   else if(widget.pageType == "SL"){
  //       getSacramentDetails();
  //   }
  //   else if(widget.pageType == "PR"){
  //       getHtmlUrl();
  //   }
  //   else if(widget.pageType == "CAL"){
  //       getCalendarUrl();
  //   }
  //   else if(widget.htmlurl.isEmpty){
  //       getHtmlUrl();
  //   }else{
  //       htmlUrl = widget.htmlurl;
  //       isLoading = true;
  //       getHtmlContentFromUrl(htmlUrl);
  //   }
      
  // }

  /*initialiseWebView(){
    controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {
        if (url.startsWith('tel:')) {
                //_launchCaller("tel:1-408-555-5555");
                _launchCaller(url);
              }
      },
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  );
  //..loadRequest(Uri.parse(widget.htmlurl.isEmpty ? htmlUrl : widget.htmlurl));
  if(widget.htmlurl.isNotEmpty){
      controller.loadRequest(Uri.parse(widget.htmlurl));
  }
  }*/



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
            widget.name,
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
        isContentEmpty ? Padding(padding: const EdgeInsets.only(left: 15),
          child: Text("Bible reading not available", style: TextStyle(color: themeData.textColor,
                  fontSize: AppConstants.headingFontSize,
                  fontWeight: AppConstants.fontWeight)),
        )
        : isParisEvent ? loadEventView(themeData) :loadWebview() ,
        );
     // }),
   // );
  }

  loadEventView(themeData){
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02, horizontal: MediaQuery.of(context).size.width * 0.05),
      padding:  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: MediaQuery.of(context).size.height,
      decoration:  BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color.fromARGB(255, 232, 234, 232),
      ),
      // child: Column(
      //   children: [
      //     rowEventData("Event Name :",event.name),
      //     const SizedBox(height: 10,),
      //     rowEventData("Event Description :",event.description),
      //     const SizedBox(height: 10,),
      //     rowEventData("Event Location :",event.occurancePlace),
      //     const SizedBox(height: 10,),
      //     event.festivalName.isNotEmpty ? rowEventData("Event Festival :",event.festivalName) :Container(),
      //     rowEventData("Event From Date :",event.fromDate),
      //     const SizedBox(height: 10,),
      //     rowEventData("Event To Date :",event.toDate),
      //     const SizedBox(height: 10,),
      //     event.tabList.isNotEmpty ?
      //     TabBar(
      //       isScrollable: true,
      //       tabs:_tabs,
      //       labelColor: themeData.appNavBg,
      //       unselectedLabelColor: Colors.black,
      //       indicatorColor: themeData.appNavBg,
      //       labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: themeData.textColor),
      //       controller: _tabController,
      //       onTap: (int index) {
      //         onTabChange(index);
      //       },
      //       ) : Container(),
      //       event.tabList.isNotEmpty ? Container(
      //          height : deviceHeight * 0.55,
      //          //color: Colors.amber,
      //         child:createWidgetList(themeData, selectedIndex) /*TabBarView(
      //           children: <Widget>[
      //             getWidget(themeData, selectedIndex),
      //         ],
      //         controller: _tabController,),*/,
      //       ) :Container(),
      //      //getWidget(themeData),
      //   ],
      // ),
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

  loadWebview(){
  //   return InAppWebView(
  //                     key: webViewKey,
  //                     initialUrlRequest:URLRequest(url: WebUri(htmlUrl)),
  //                     initialSettings: settings,
  //                     onWebViewCreated: (controller) {
  //                       webViewController = controller;
  //                     } 
  //                   );
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
             print(".......html....$file...");
             if(file == null){
                setState(() {
                  isContentEmpty = true;
                  isLoading = false;
                });
             }
             else if(file.isNotEmpty){
      //          getHtmlContentFromUrl(file);
             }else{
                setState(() {
                  isContentEmpty = true;
                  isLoading = false;
                });
             }
              
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

  /// Print Long String
void printLongString(String text) {
  final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((RegExpMatch match) =>   print(match.group(0)));
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

        var objectUrl = '$requestClass?where={"objectId":"${widget.objectID}"}';
        final uri = Uri.parse(objectUrl);

        Response response = await get(uri, headers: headers);

        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          var results = responseBody["results"] as List;

          if (results.isNotEmpty) {
            var file = results[0][widget.collectionName]["url"];
       //     getHtmlContentFromUrl(file);
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
    //print("...${urlParameter}....getState.......$parishList... response.....first...${response.statusCode}....");
    Map<String, dynamic> jsonData = response; //json.decode(response.body);
    print("..$parishList.....getState response.....$jsonData....");
    var status = jsonData[statusKey];
    if(status == 200){
        Map<String, dynamic> eventList = jsonData[dataKey];
        EventDetails data = EventDetails.fromJson(eventList);
        print("...${data.tabList}.....event list..5454.....${data.name}....");

        if(data.tabList.isNotEmpty){
 //         getTabs(data.tabList);
   //       _tabController = getTabController();
        }
        setState(() {
            isLoading = false;
            event = data;
            isParisEvent = true;
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
    Map<String, dynamic> jsonData = response;//json.decode(response.body);
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


  getHtmlContentFromUrl(String url) async {
    final uri1 = Uri.parse(url);
    Map<String, String> headers = {
          "X-Parse-Application-Id": keyParseApplicationId,
          "X-Parse-REST-API-Key": restAPIKey
        };
    var response = await get(uri1, headers: headers);
    String finalHtmlString = "";
    //If the http request is successful the statusCode will be 200
    if (response.statusCode == 200) {
      String prayerContent = utf8.decode(response.bodyBytes);
      htmlStart = "$htmlStart $cssStyleTag $cssEndTag";
      // replacing the image with image in our local
      prayerContent = prayerContent.replaceAll("prayer_end.png",
          "https://www.linkpicture.com/q/prayer_end.png");
      prayerContent = prayerContent.replaceAll(
          "img_prayer_footnote.png",
          "https://www.linkpicture.com/q/img_prayer_footnote.png");
      // the final html content
      finalHtmlString = htmlStart + prayerContent + htmlEnd;

     // printLongString(finalHtmlString);
      setState(() {
        //htmlUrl = file;
        isLoading = false;
        htmlContent = finalHtmlString;
      });
    }else{
      setState(() {
        //htmlUrl = file;
        isLoading = false;
        htmlContent = emptyHtml;
        isContentEmpty = true;

      });
    }
    
  }

  List<Tab> getTabs(dataList) {
    _tabs.clear();
    for (var data in dataList) {
  //    _tabs.add(getTab(data));
    }
    return _tabs;
  }

  Tab getTab(String widgetNumber) {
    return Tab(
      text: widgetNumber.toUpperCase(),
    );
  }

  // TabController getTabController() {
  //   return TabController(length: _tabs.length, vsync: this)
  // //    ..addListener(_updatePage);
  // }

  void _updatePage() {
    setState(() {});
  }

  Widget createWidgetList(themeData,index) {
    print("..${event.tabList[index]}...getWidget.......${event.mediaDict}..---..");
    List<MediaItem> media = event.mediaDict[event.tabList[index]];
    print("..---${event.tabList[selectedIndex]}---...getWidget......$media....");
    return ListView.builder(
      itemCount:  media.length,
      itemBuilder: (context, position) {
   //     return  event.tabList[index] == "images" ? displayImageView(media[position].url) :
     //   event.tabList[index] == "youtube" ? displayYoutubePlayer(media[position].url) : displayVideoPlayer(event.tabList[index], position,media[position] );
      },
    );
  }

  onTabChange(index) {
    setState(() {
      selectedIndex = index;
    });
    print("....onTabChange...$index...");
  }

  Widget displayImageView(url){
    return Card(
      child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.all(16.0),
                      decoration:  BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover),
                    ),
                    ),
    );
  }

  // Widget displayYoutubePlayer(youtubeUrl){
  //   return Card(
  //     child: Container(
  //         height: 200,
  //         child: YoutubePlayer(
  //           controller: YoutubePlayerController.fromVideoId(
  //           videoId: youtubeUrl,
  //           autoPlay: false,
  //           params: const YoutubePlayerParams(showFullscreenButton: true),
  //         ),
  //          aspectRatio: 16 / 9,
  //         )
  //       ),
  //   );
  // }

  Widget displayVideoPlayer(type, index, media){
    return Card(
      child: Stack(
        children: [
          Container(
            height: 200,
         //   child: VideoPlayer(media.controller),
          ),
          Positioned.fill(
            child: Center(
              child: InkWell(
                child: Icon( media.controller.value.isPlaying ?  Icons.pause_circle_outline_rounded :
                  Icons.play_circle_outline_rounded,
                  color: Colors.white,
                  size: 80,
                ),
                onTap: (){
                  setState(() {
              media.controller.value.isPlaying
                  ? media.controller.pause()
                  : media.controller.play();
            });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }







}
}