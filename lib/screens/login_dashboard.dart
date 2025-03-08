//import 'package:fluttertoast/fluttertoast.dart';

import './dashboard.dart';
import './login.dart';
import './signup.dart';
import 'package:qleedo/index.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:qleedo/auth/firebase_auth_service.dart';



List<String> themeList = ["Light", "Dark"];

class LoginDashboard extends StatefulWidget {
  static const routeName = "/LoginDashboard";

  @override
  _LoginDashboardState createState() => _LoginDashboardState();
}

class _LoginDashboardState extends State<LoginDashboard> {
  var selectedIndex = 0;
  //late GoogleSignIn _googleSignIn;
  //GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
  //   _googleSignIn = GoogleSignIn(
  // scopes: [
  //   'email',
  //   'https://www.googleapis.com/auth/contacts.readonly',
  // ],
// );

//  _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
//       setState(() {
//         _currentUser = account;
//       });
//       if (_currentUser != null) {
//        print("........get data.....$_currentUser...");
//       }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);

    print(
        "....${themeData.themeType}....login dashboard..${themeData.user.isLogined}...444...${themeData.user}");
    return Scaffold(
      body:   themeData.user.isLogined == true
                ? loginedView(context, themeData)
                : beforeLoginView(context, themeData)
         
    );
  }

  Widget beforeLoginView(BuildContext context, ThemeConfiguration themeData) {
    return SingleChildScrollView(
            child : SafeArea(
          child: Container(
            height : MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.asset(
              'assets/images/banner/banner.png',
              fit: BoxFit.contain,
            ),
          ),
          Container(
            //height: MediaQuery.of(context).size.height * 0.3,
            //color: Color.fromARGB(35, 30, 22, 1),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width - 30,
                  child: MaterialButton(
                    color: themeData.appNavBg,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: themeData.appNavTextColor),
                    ),
                    onPressed: () => Navigator.of(context)
                        .popAndPushNamed(SignupPage.routeName),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width - 30,
                  child: MaterialButton(
                    color: themeData.appNavBg,
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: themeData.appNavTextColor),
                    ),
                    onPressed: () => Navigator.of(context)
                        .popAndPushNamed(LoginPage.routeName),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10)),
                  ),
                ),
           //     themeView(themeData),
                SignInButton(
                        Buttons.Google,
                        onPressed: ()  {
                          if(kIsWeb){
                       //       _handleSignIn();
                          }else{
                            googleLoginAction(themeData);

                          }
                        },
                      ),
                TextButton(
                  child: Text(
                    '< Back',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  onPressed: () => Navigator.of(context)
                      .popAndPushNamed(Dashboard.routeName),
                ),
              ],
            ),
          )
        ],
      ),
    ) ) );
  }

  googleLoginAction(ThemeConfiguration themeData) {
    getLoadingCommon(context, 100, themeData);
   // FirebaseAuthService().signInWithGoogle().then((value) async {
      // print("...${value.displayName}....Google signin.....$value.....");
      // User userModel =  User(
      //     objectID: "",
      //     pushObjectID: "",
      //     firstName: value.displayName,
      //     lastName: "",
      //     username: "",
      //     language: "",
      //     email: value.email,
      //     isFirstTimeLoading: false,
      //     isLogined: true,
      //     isPushEnabled: false,
      //     phoneNumber: '',
      //     gender: '',
      //     prayer: '',
      //     parishObjectID: '',
      //     translation: '',
      //     calendar: '',
      //     maritalStatus: '',
      //     form: '',
      //     versifications: '',
      //     church: '');
      // // await setPrefrenceUser(isUSERLOGINED, userModel);
      // Provider.of<ThemeConfiguration>(context, listen: false)
      //    .updateUser(userModel);
      Navigator.of(context).pop();
      // Fluttertoast.showToast(
      //     msg: "User logined successfully",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: themeData.bgColor,
      //     textColor: themeData.textColor,
      //     fontSize: 16.0);

      Navigator.of(context).pop();
  //  });
  }

  Widget loginedView(BuildContext context,ThemeConfiguration themeData) {
    return SingleChildScrollView(
      child : SafeArea(
          child: Container(
      height : MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(top: 40),
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset(
              'assets/images/banner/banner.png',
              fit: BoxFit.contain,
            ),
          ),
          Container(
            //height: MediaQuery.of(context).size.height * 0.4,
            //color: Color.fromARGB(35, 30, 22, 1),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width - 30,
                  child: MaterialButton(
                    color: themeData.appNavBg,
                    child: Text(
                      'Sign Out',
                      style: TextStyle(color: themeData.appNavTextColor),
                    ),
                    onPressed: () {
                        userSignout();
                      },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10)),
                  ),
                ),
                // themeView(themeData),
                TextButton(
                  child: const Text(
                    '< Back',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  onPressed: () => Navigator.of(context)
                      .popAndPushNamed(Dashboard.routeName),
                ),
              ],
            ),
          )
        ],
      ),
    ) ) );
  }

  userSignout() async {
    User userModel = const User(objectID: "",email: '', firstName: '', username: '', pushObjectID: '', lastName: '', language: 'eg', isFirstTimeLoading: true, isLogined : false, isPushEnabled: false, calendar: '', form: '', church: '', gender: '', maritalStatus: '', parishObjectID: '', phoneNumber: '', prayer: '', translation: '', versifications: '');
    await setPrefrenceUser(isUSERLOGINED, userModel);
    Provider.of<ThemeConfiguration>(context, listen: false).updateUser(userModel);

  }

  changeTheme(BuildContext context,ThemeConfiguration themeData) {
    return Container(
        margin:
            EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
        child: Card(
            elevation: 0,
            shadowColor: Colors.white54,
            child: InkWell(
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "CHANGE_THEME_LBL",
                          style: TextStyle(
                                  color: themeData.appNavBg,
                                  fontWeight: FontWeight.bold),
                        )),
                    Spacer(),
                    Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black87,
                        )),
                  ],
                ),
                onTap: () {
                  themeDialog(context, themeData);
                })));
  }

  themeDialog(BuildContext cont, ThemeConfiguration themedata) async {
  await showDialog(
    context: cont,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.zero, // Cleaner way for no padding
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      content: SizedBox(
        height: 200,
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                child: Text(
                  AppConstants.chooseThemeLbl,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black87,
                      ),
                ),
              ),
              const Divider(color: Colors.grey),
              ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: const Divider(color: Colors.black26),
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: themeList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
                    child: Row(
                      children: [
                        InkWell(
                          // onTap: () {
                          //   selectedButton(index, themedata);
                          // },
                          child: Container(
                            height: 25.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectedIndex == index
                                  ? Colors.blue
                                  : Colors.white,
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: selectedIndex == index
                                  ? const Icon(
                                      Icons.check,
                                      size: 17.0,
                                      color: Colors.blue,
                                    )
                                  : const Icon(
                                      Icons.check_box_outline_blank,
                                      size: 15.0,
                                      color: Colors.black87,
                                    ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            themeList[index],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.black87,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Divider(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            "CANCEL",
            style: Theme.of(cont).textTheme.bodySmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text(
            "OK",
            style: Theme.of(cont).textTheme.bodySmall?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}


    /*builder: (context) => AlertDialog(
              title: Text("Cannot add more tabs"),
              content: Text("Let's avoid crashing, shall we?"),
              actions: <Widget>[
                TextButton(
                    child: Text("Crash it!"),
                    onPressed: () {
                      //_addAnotherTab();
                      //Navigator.pop(context);
                    }),
                TextButton(
                    child: Text("Ok"), onPressed: () => Navigator.pop(context))
              ],
            
        ),);*/
  }

//   selectedButton(index, ThemeConfiguration themedata) {
//     //print("........selectedButton......$index...");
//     setState(() {
//       selectedIndex = index;
//     });
//     index == 0 ? Provider.of<ThemeConfiguration>(context,listen: false).setLightTheme(themedata.user, themedata.bible) : Provider.of<ThemeConfiguration>(context,listen: false).setDarkTheme(themedata.user, themedata.bible);
//   }

//     themeView(ThemeConfiguration themeData) {
//     return Container(
//       alignment: Alignment.center,
//       margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//       decoration: BoxDecoration(
//           border: Border.all(color: Colors.transparent),
//           borderRadius: BorderRadius.circular(10.0),
//           color: Color(0xfff5bb90)),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "Select Theme",
//             style: TextStyle(
//               color: themeData.textColor,
//               fontSize: 12,
//               fontWeight: fontBold,
//             ),
//             textAlign: TextAlign.left,
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           Row(
//             children: [
//               themeItemView(themeData, Color(0xfffffbf6), "L"),
//               SizedBox(width: 10),
//               themeItemView(themeData, Color(0xff40220a), "D"),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//     themeItemView(ThemeConfiguration themeData, Color colorsItem, String type){
//     //print("....$type....theme item......${themeData.themeType}......");
//     return GestureDetector(
//       // When the child is tapped, show a snackbar.
//       onTap: ()  {
//         //print(".....themeItemView....$type...");
//         if(type == 'L')
//           Provider.of<ThemeConfiguration>(context,listen: false).setLightTheme(themeData.user, themeData.bible);
//         else if(type == 'D')
//           Provider.of<ThemeConfiguration>(context,listen: false).setDarkTheme(themeData.user, themeData.bible);
  
        
//       },
//       // The custom button
//       child: Container(
//         width: 40.0,
//         height: 40.0,
//         decoration: new BoxDecoration(
//           color: colorsItem,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(
//           Icons.done,
//           size: 25,
//           color: type == 'L'
//               ? themeData.themeType == SelectedTheme.lightTheme
//                   ? Colors.red
//                   : Colors.transparent
//               : type == 'D'
//                   ? themeData.themeType == SelectedTheme.darkTheme
//                       ? Colors.red
//                       : Colors.transparent
//                   : Colors.transparent,
//         ),
//       ),
//     );
//   }

//   Future<void> _handleSignIn() async {
//   // try { // Make sure to change this
//   //   await _googleSignIn.signIn();
//   // } catch (error) {
//   //   print(error);
//   // }
// }

void getLoadingCommon(BuildContext context, int marginTop, ThemeConfiguration theme) {
  showDialog(
    context: context,
    barrierDismissible: false,
    
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
        width: deviceWidth ,
        height: deviceHeight - marginTop, 
        color: Colors.transparent, 
        child: Center(
          child: SpinKitRipple(
                  color: theme.brandColor,
                  size: 140.0,
                )
              ,
        ),
      )
      );
    },
  );
}


