import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:qleedo/index.dart';
import 'package:qleedo/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';


const String NO_INTERNET="No Internet";
const String NO_INTERNET_DISC="Please check your connection again, or connect to Wi-Fi";

//Check network condition
Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}


noIntImage() {
  return Image.asset(
    'assets/image/no_internet.png',
    fit: BoxFit.contain,
  );
}

noIntText(BuildContext context, themeData) {
  return Container(
      child: Text(NO_INTERNET,
          style: TextStyle(color: themeData.textColor, fontWeight: FontWeight.bold, fontFamily: 'Poppins-SemiBold' )));
}

noIntDec(BuildContext context, themeData) {
  return Container(
    padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
    child: Text(NO_INTERNET_DISC,
        textAlign: TextAlign.center,
        style: TextStyle(color: themeData.textColor, fontWeight: FontWeight.normal, fontFamily: 'Poppins-Regular' )),
  );
}

/*Widget showCircularProgress(bool _isProgress, Color color) {
  if (_isProgress) {
    return Center(
        child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(color),
    ));
  }
  return Container(
    height: 0.0,
    width: 0.0,
  );
}*/

setPrefrenceUser(String key, User value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  ////print(".......set preference....333333...");
  String user = jsonEncode(User.fromJson(value.toJson()));
  ////print(".......set preference....44444...");
  await prefs.setString('user', user);
}

Future<User> getPrefrenceUser(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  ////print(".......get preference....77777...");
  String? userString = prefs.getString('user');
  ////print(".......get preference....$userString....");
  if (userString != null) {
    Map userMap = jsonDecode(userString);
    ////print(".......get preference....$userMap....");
    return User.fromJson(userMap)!;
  } else {
    return const User(
        objectID:'',
        firstName: '',
        lastName: '',
        gender: '',
        email: '',
        isLogined: false,
        isPushEnabled: false,
        calendar: '',
        versifications: '',
        translation: '',
        prayer: '',
        phoneNumber: '',
        parishObjectID: '',
        maritalStatus: '',
        church: '',
        form: '',
        language: '',
        pushObjectID: '',
        username: '',
        isFirstTimeLoading: false);
  }
}

setPrefrenceBible(String key, UserBible value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  ////print(".......set preference....333333...");
  String user = jsonEncode(UserBible.fromJson(value.toJson()));
  ////print(".......set preference....44444...");
  await prefs.setString('bible', user);
}


Future<UserBible>? getPrefrenceBible(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  ////print(".......get preference....77777...");
  String? userString = prefs.getString('bible');
  ////print(".......get preference....$userString....");
  if (userString != null) {
    Map userMap = jsonDecode(userString);
    return UserBible.fromJson(userMap)!;
  } else {
    return UserBible(
        name: 0,
        verse: 0,
        isPlayEnabled: false,
        chapter: 1,
       );
  }
}

    Widget showCircularProgress( ThemeConfiguration appTheme,double deviceWidth,double deviceHeight  ) {
    return Center(child: Container(
                color: Colors.transparent,
                width: deviceWidth,
                height: deviceHeight -60,
                child: /*SpinKitRipple(
                  color: appTheme.brandColor,
                  size: 120.0,
                )*/
                Lottie.asset('assets/json/logo.json'),
                ),);


}

    Widget showDotProgress( ThemeConfiguration appTheme,double deviceWidth,double deviceHeight  ) {
    return Center(child: Container(
                color: Colors.transparent,
                width: deviceWidth,
                height: 40 ,
                child: SpinKitThreeBounce(
                  color: appTheme.brandColor,
                  size: 40.0,
                )),);


}

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget navBackButton(ThemeConfiguration themeData, BuildContext context){
    return GestureDetector(
      onTap: (){ Navigator.of(context).pop();
      },
      child: Icon(Icons.arrow_back_ios_outlined, color: themeData.appNavTextColor,));
  }







