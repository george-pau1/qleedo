//import 'package:audioplayers/audioplayers.dart';
import 'package:qleedo/models/base_model.dart';
import 'package:qleedo/models/Media.dart';
import 'package:qleedo/screens/media_yutube_player.dart';
import 'package:qleedo/index.dart';
import 'package:qleedo/service/media_service.dart';

class MediaDetailsConsoleView extends StatefulWidget {
  static const routeName = '\MEDIASDETAILSCONSOLE';
  Map<String, dynamic> selectedSaints;
  String typeSelected;

  MediaDetailsConsoleView({Key? key, required this.selectedSaints, required this.typeSelected}) : super(key: key);

  @override
  _MediaDetailsConsoleViewState createState() => _MediaDetailsConsoleViewState();
}

class _MediaDetailsConsoleViewState extends State<MediaDetailsConsoleView>
    with TickerProviderStateMixin {
  var isLoading = true;
  List<MediasDetails> mediaList = [];
  //AudioPlayer player = AudioPlayer();
  int selectedIndex = -1;
  String  selectedAudioUrl="";

  @override
  void initState() {
    super.initState();
    getFestivalList();
    
    // player.onPlayerStateChanged.listen((event) { 
    //   print("....onPlayerStateChanged.......$event..");
    //   if(event == PlayerState.playing){
    //     updatePlayerStatus(selectedIndex);
    //   }else if(event == PlayerState.paused){
    //     updatePlayerStatus(-1);
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }



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
            widget.selectedSaints['name'],
            style: TextStyle(
                color: themeData.appNavTextColor,
                fontSize: AppConstants.headingFontSize,
                fontWeight: AppConstants.fontWeight),
          ),
        ),
        body: isLoading
            ? showCircularProgress(themeData, deviceWidth, deviceHeight)
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: mediaListView(context, themeData),
              ));
  }

  Widget mediaListView(BuildContext context, ThemeConfiguration themedata) {
    var size = MediaQuery.of(context).size.width;
    print("...${mediaList.length}...threeList....");
    return ListView.builder(
          itemCount: mediaList.length,
          itemBuilder: (BuildContext context, int index) {
          print("....mediaListView....444....${mediaList[index].docType}...");

          if (mediaList[index].docType.toLowerCase() == "1") {
            return audioView(context, themedata, size, index);
          } else if (mediaList[index].docType.toLowerCase() == "5") { 
            return youtubeView(context, themedata, size, index);
          }
          else {
            return imageView(mediaList[index].url);
          }
          
        },
    );
  }

  Widget youtubeView(
      BuildContext context, ThemeConfiguration themedata, var size, int index) {
    return Stack(
      alignment: Alignment.center,
      children: [
      Column(children: [
        Container(
          alignment: Alignment.center,
          child: FadeInImage(
    image:NetworkImage(mediaList[index].imageUrl,),
    placeholder: const AssetImage("assets/images/logotop/logo_top@3x.png"),
    imageErrorBuilder:(context, error, stackTrace) {
       return Image.asset('assets/images/logotop/logo_top@3x.png',
           fit: BoxFit.cover
       );
    },
    fit: BoxFit.cover,
    height: 220,
    width: size * 0.80,
 ),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          mediaList[index].name,
          textAlign: TextAlign.center,
          style: TextStyle(color: themedata.textColor),
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
      Align(
        alignment: Alignment.center,
        child: InkWell(
            onTap: () {
              print("onTap called.");
              onSelectMediaDetails(mediaList[index]);
            },
            child: CircleAvatar(
              radius: 35.0,
              backgroundColor: themedata.appNavBg,
              child: const Icon(
                Icons.play_arrow,
                size: 30,
                color: Colors.white,
              ),
            ),
        ),
      )
    ]);
  }

  Widget audioView(
      BuildContext context, ThemeConfiguration themedata, var size, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(children: [
        const SizedBox(
          height: 6,
        ),
        Text(
          mediaList[index].name,
          textAlign: TextAlign.center,
          style: TextStyle(color: themedata.textColor),
        ),
        const SizedBox(
          height: 6,
        ),
        Center(
          child: IconButton(
            iconSize: 72,
            icon:  Icon(mediaList[index].isPlaying ? Icons.pause_circle_filled_outlined : Icons.play_circle_outlined),
            onPressed: () async {
              print("....${mediaList[index].isPlaying}....play url...${mediaList[index].url}....");
              setState(() {
                selectedAudioUrl= mediaList[index].url;
                selectedIndex = index;
              });

              // if(mediaList[index].isPlaying && selectedAudioUrl.compareTo(mediaList[index].url)!=0){
              //   await player.pause();
              //   await player.play(UrlSource(mediaList[index].url));
              // }else if(mediaList[index].isPlaying){
              //     await player.pause();
              // }
              // else{
              //   await player.play(UrlSource(mediaList[index].url));
                
              // }
              
            },
          ),
        ),
        Divider(
          color: themedata.appNavBg,
          height: 2,
          thickness: 2,
        )
      ]),
    );
  }

  Widget imageView(imageUrl ){
    return Container(
            height: 200,
            width: 100,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,//<--- add this
                  image: NetworkImage(imageUrl),
                )),
          );
  }

  onSelectMediaDetails(MediasDetails data) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MediaYoutubePlayer(
            selectedPlayer: data,
          ),
        ));
  }

  getFestivalList() async {
    bool avail = true;
    if (avail) {
      setState(() {
        isLoading = true;
      });
      BaseModel baseObject =
          await MediaService().getMediaListByName(widget.selectedSaints['id'].toString(), widget.typeSelected);
      if (baseObject.status == true) {
        print(
            "........getFestivalList response..success..${baseObject.status}...");
        List<MediasDetails> list = baseObject.data as List<MediasDetails>;
        setState(() {
          isLoading = false;
          mediaList.addAll(list);
        });
      } else {
        print("........getFestivalList response..failed.....");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  updatePlayerStatus(int selectedIndex){
    int currentIndex=0;
    for (MediasDetails media in mediaList) {
        print("$selectedIndex is at inde...playingx $currentIndex");
        if(selectedIndex == currentIndex){
            print("$selectedIndex is at inde..4444.playingx $currentIndex");
            media.isPlaying = true;
        }else{
            print("$selectedIndex is at inde.5555..playingx $currentIndex");
            media.isPlaying = false;
        }
       currentIndex++; 
    }

    if(mounted){
      setState(() {
        
      });
    }

  }
}
