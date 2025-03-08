
import 'package:qleedo/models/Media.dart';
import 'package:qleedo/index.dart';
//import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MediaYoutubePlayer extends StatefulWidget {
  static const routeName = '\MEDIASDETAILS';
  MediasDetails selectedPlayer;

  MediaYoutubePlayer({Key? key, required this.selectedPlayer}) : super(key: key);

  @override
  _MediaYoutubePlayerState createState() => _MediaYoutubePlayerState();
}

class _MediaYoutubePlayerState extends State<MediaYoutubePlayer>
    with TickerProviderStateMixin {
  var isLoading = true;
  List<MediasDetails> mediaList = [];
  // List<YoutubePlayerController> controllerList = [];
  // late PlayerState _playerState;
  // late YoutubeMetaData _videoMetaData;
  // late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    String videoIdLocal;
    print("...444..${widget.selectedPlayer}...MediaYoutubePlayer...${widget.selectedPlayer.url}....");
    // videoIdLocal = YoutubePlayerController.convertUrlToId("https://www.youtube.com/watch?v=r5O9XkSWWsU", trimWhitespaces: true)! ;
    // print("........MediaYoutubePlayer...$videoIdLocal....");
    // // If the requirement is just to play a single video.
    // controller = YoutubePlayerController.fromVideoId(
    //   videoId: videoIdLocal,
    //   autoPlay: true,
    //   params: const YoutubePlayerParams(showFullscreenButton: true),
    // );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    var size = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.appNavBg,
        leading: navBackButton(themeData, context),
        title: Text(
          widget.selectedPlayer.name,
          style: TextStyle(
              color: themeData.textHeading,
              fontSize: AppConstants.headingFontSize,
              fontWeight: AppConstants.fontWeight),
        ),
      ),
   //   body: getYoutubePlayer(size),
    );
  }

  /*Widget getYoutubePlayer(){
    return Container(
        height: size,
        child: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: widget.selectedPlayer.prayerID, //Add videoID.
            flags: YoutubePlayerFlags(
              hideControls: false,
              controlsVisibleAtStart: true,
              autoPlay: true,
              mute: false,
            ),
          ),
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.yellow,
        ),
      );
  }*/

  // Widget getYoutubePlayer(double size){
  //   return Container(
  //       height: size,
  //       child: YoutubePlayer(
  //         controller: controller,
  //         aspectRatio: 16 / 9,
  //       )
  //     );
  // }


}


