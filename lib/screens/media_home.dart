

import 'package:qleedo/index.dart';
import 'package:qleedo/models/Media.dart';
import 'package:qleedo/screens/media_details.dart';
import 'package:qleedo/screens/media_details_console.dart';
import 'package:qleedo/service/media_service.dart';
import 'package:qleedo/models/base_model.dart';


class MediaLists extends StatefulWidget {
  static const routeName = '\MediaList';

  @override
  _MediaListState createState() => _MediaListState();
}

class _MediaListState extends State<MediaLists> with TickerProviderStateMixin {
  var isLoading = true;
  List mediaList = [];
  List<Tab> tabs = [];
  List<Widget> generalWidgets = [];
  late TabController tabController;
  var mediaCollection = {};
  bool isMediaAvailable = false;
  int startingTabCount = 0;
  List mediaListSashido = [];
  bool isMediaFirstTabSelected = true;
  int currentSelectedTab = 0;
  List tabList = [];


  @override
  void initState() {
    super.initState();
    getCategoryList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getCategoryList() async {
    var urlParameters =
        '$keyParseServerUrl/classes/Category?where={"Status" : "A"}';
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
      var saintsCollect =(data as List).map((data) =>  Medias.fromJson(data)).toList();
      print("..........getCategoryList....$saintsCollect.....");
      setState(() {
        mediaListSashido = saintsCollect;
        mediaList = saintsCollect;
        isLoading = false;
      });
      getMediaCategory();
    } else {
      print("......getPrayerCollectio....Error.....${response.statusCode}....");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
      double deviceHeight = MediaQuery.of(context).size.height;
     double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.appNavBg,
        title: Text("Media Centre", style: TextStyle(color: themeData.appNavTextColor, fontSize: AppConstants.headingFontSize, fontWeight: AppConstants.fontWeight),),
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
                  icon: Icon(
                    Icons.menu_outlined,
                    color: themeData.appNavTextColor,
                    size: 35,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        bottom: isMediaAvailable ? TabBar(
            labelColor: themeData.appNavTextColor,
            isScrollable: true,
            tabs: tabs,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: themeData.appNavTextColor),
            controller: tabController,
            onTap: (int index) {
              onTabChange(index);
            }) : null,
      ),
      drawer: AppDrawer(),
      body: isLoading ? 
            showCircularProgress(themeData,deviceWidth,deviceHeight)
            : isMediaAvailable ? getWidget(themeData)  : showCircularProgress(themeData,deviceWidth,deviceHeight)
    );
  }

    Widget getWidget(themeData) {
    return ListView.builder(
      itemCount: mediaList.length,
      itemBuilder: (context, position) {
        return GestureDetector(
            child: Card(
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.all(16.0),
                    child: Text( isMediaFirstTabSelected ? mediaList[position].name :
                      mediaList[position]['name'],
                      style: TextStyle(fontSize: 22.0, color: themeData.listTextColor),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: themeData.listTextColor,
                      )),
                ],
              ),
            ),
            onTap: () {
              onSelectSaints(mediaList[position],tabList.elementAt(currentSelectedTab));
              
            });
      },
    );
  }

  onTabChange(index) {
    print(".......current index.....$index...");
    currentSelectedTab = index;
    if(index == 0){
      setState(() {
        mediaList = mediaListSashido;
        isMediaFirstTabSelected = true;
        
      });

    }else{
      var dictList = mediaCollection.keys;
      int localIndex = index -1;
      print("....$dictList...onTabChange...$localIndex....");
      setState(() {
      mediaList = dictList.isNotEmpty?  mediaCollection[dictList.elementAt(localIndex)] : [];
      //isLoading = false;
      isMediaFirstTabSelected = false;
      });
    }
  }


  @override
  Widget build_backup(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeData.appNavBg,
          title: Text(
            "Media Centre",
            style: TextStyle(
                color: themeData.appNavTextColor,
                fontSize: AppConstants.headingFontSize,
                fontWeight: AppConstants.fontWeight),
          ),
          leading: Builder(
            builder: (context) => // Ensure Scaffold is in context
                IconButton(
                    icon: Icon(
                      Icons.menu_outlined,
                      color: themeData.appNavTextColor,
                      size: 35,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer()),
          ),
        ),
        drawer: AppDrawer(),
        body: isLoading
            ? showCircularProgress(themeData, deviceWidth, deviceHeight)
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                //color: Colors.green,
                child: threeList(context, themeData)));
  }


  Widget threeList(BuildContext context, ThemeConfiguration themedata) {
    var size = MediaQuery.of(context).size.width;
    print("...${mediaList.length}...threeList....");
    return GridView.count(
      crossAxisCount: 1,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      childAspectRatio: (size / 70),
      shrinkWrap: true,
      children: List.generate(
        mediaList.length,
        (index) {
          return InkWell(
            onTap: () {
              onSelectSaints(mediaList[index], "");
            },
            child: Column(children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: themedata.appNavBg,
                    radius: 20.0,
                    child: Icon(
                      Icons.play_arrow,
                      color: themedata.textHeading,
                    ),

                    //backgroundImage: NetworkImage
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    mediaList[index].name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: themedata.textColor),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Divider(
                color: themedata.appNavBg,
                height: 2,
                thickness: 2,
              )
            ]),
          );
        },
      ),
    );
  }

  onSelectSaints( data, String type) {
    print("....$type.....onSelectSaints.--$isMediaFirstTabSelected--.....$data...");
    if(isMediaFirstTabSelected ){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MediaDetailsView(
            selectedMedia: data,
            typeSelected: type,
          ),
        ));
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MediaDetailsConsoleView(
            selectedSaints: data,
            typeSelected: type,
          ),
        ));
    }
    
  }


  getMediaCategory() async {
     bool avail = true;
    if (avail) {
      setState(() {
        isLoading = true;
      });
       BaseModelObject baseObject = await MediaService().getMediaCategory();
       if(baseObject.status == true){
         print("...${baseObject.data}.....getMediaCategory response..success..${baseObject.status}...");
         var dictList = baseObject.data.keys;
         setState(() {
          mediaCollection = baseObject.data;
          startingTabCount = dictList.length;
          //mediaList = dictList.length > 0 ?  baseObject.data[dictList.elementAt(0)] : [];
          isLoading = false;
          isMediaAvailable = true;
         });
        tabs = getTabs(dictList);
        tabController = getTabController();
       }else{
         print("........getMediaCategory response..failed.....");
       }

    }

  }

  List<Tab> getTabs(dictList ) {
    print(".........getTabs........$dictList...");
    tabs.clear();
    tabList.clear();
    tabList.add("Media");
    tabs.add(getTab("Media"));
    for (var media in dictList) {
      print(".........getTabs....232222....$media...");
      tabs.add(getTab(media));
      tabList.add(media);
    }
    return tabs;
  }


  Tab getTab(String widgetNumber) {
    return Tab(
      text: widgetNumber.toUpperCase(),

    );
  }

  TabController getTabController() {
    return TabController(length: tabs.length, vsync: this)
      ..addListener(_updatePage);
  }

  void _updatePage() {
    setState(() {});
  }

  removeDuplicate(existingMedia, newMedia){
    List<Medias> list = [];
    for(Medias media in  existingMedia){
      print("...removeDuplicate....1111...${media.name}.");
      newMedia.removeWhere((mediaItem) => mediaItem.name == media.name);
    }

    print("....$existingMedia....removeDuplicate....3333...$newMedia.");
    setState(() {
            isLoading = false;
            mediaList.addAll(newMedia);
         });
  }
}
