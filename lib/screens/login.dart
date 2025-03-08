
import 'package:qleedo/screens/signup.dart';

import 'forgot_password.dart';
import '../widgets/appbar.widget.dart';
import 'package:qleedo/index.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:qleedo/screens/dashboard.dart';


class LoginPage extends StatefulWidget {
  static const routeName = "/LoginPage";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var userName = '';
  var userPassword = '';
  var isValidateUsername = false;
  var isValidatePassword = false;
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var isErroTextUser;
  var isErroTextPassword;
  var isLoading = false;
  final RegExp emailRegex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  final RegExp passwordRegex = new RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  @override
Widget build(BuildContext context) {
  final themeData = Provider.of<ThemeConfiguration>(context);
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  return Scaffold(
    appBar: AppbarWidget(
      isSlideMenu: false,
      pageTitle: 'Sign In',
      isTitleImage: false,
      isPlaying: false,
      isPlayDisplay: false,
      isLanguageEnabled: false,
      isLanguageSelect: () => {},
      isPlaySelected: () => {},
      pageType: '',
      updateBibleCache: () => {},
    ),
    body: Container(
      child: LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: const CircularProgressIndicator(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'assets/images/logowithtitle/ic_splash.png',
                width: width * 0.40,
                height: height * 0.20,
              ),
              const SizedBox(height: 10),
              inputFieldWidget(70, '', 'Email', 'email'),
              const SizedBox(height: 10),
              inputFieldWidget(70, '', 'Password', 'password'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: const Text('Forgot Password?'),
                    onPressed: () => Navigator.of(context).pushNamed(ForgotPassword.routeName),
                  ),
                  TextButton(
                    child: const Text('New User'),
                    onPressed: () => Navigator.of(context).pushNamed(SignupPage.routeName),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                width: width - 30,
                child: MaterialButton(
                  color: themeData.appNavBg,
                  onPressed: () => onClikSininButton(context, themeData),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: themeData.appNavTextColor),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Image.asset('assets/images/seperator/img_separator.png'),
            ],
          ),
        ),
      ),
    ),
  );
}


  setInputFields(type, text) {
    //print(type + '.....setInputFields..3333333...' + text);
    /*if (type == 'email')
      this.setState(() {
        userName = text;
      });
    else if (type == 'password')
      this.setState(() {
        userPassword = text;
      });*/
  }

  onClikSininButton(BuildContext context, themeData) async {
    print(nameController.text +
        '.....setInputFields..77777...' +
        passwordController.text);
    if (nameController.text == null || nameController.text.length == 0) {
      setState(() {
        isErroTextUser = 'Enter User name';
      });
    } else if (!emailRegex.hasMatch(nameController.text)) {
      setState(() {
        isErroTextUser = 'Enter a valid email characters';
      });
    } else if (passwordController.text == null ||
        passwordController.text.length == 0) {
      setState(() {
        isErroTextPassword = 'Enter User name';
      });
    } else if (!passwordRegex.hasMatch(passwordController.text)) {
      setState(() {
        isErroTextPassword = 'Enter a valid password';
      });
    } else {
      setState(() {
        isLoading = true;
      });

      validateLogin(context, themeData);
    }
  }

  /*void validateLogin(BuildContext context, themeData) async {
    var apiResponse =
        await ParseUser(nameController.text, passwordController.text, nameController.text)
            .login();
    print("........validate login......$apiResponse.........");
    if (apiResponse.success && apiResponse.result != null) {
      print(".....apiResponse....validateLogin...success.....${apiResponse.result.objectId}...: " +
          apiResponse.result.toString());
      setState(() {
        isLoading = false;
      });

      getStore().dispatch(SetUserAction(
          user: User(email: nameController.text, firstName: '', username: nameController.text, objectId: apiResponse.result.objectId, lastName: '', language: 'eg', isFirstTimeLoading: true, isLogined : true)));

      Fluttertoast.showToast(
          msg: "User logined successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: themeData.bgColor,
          textColor: themeData.textColor,
          fontSize: 16.0);

      Navigator.of(context)
                        .popAndPushNamed(Dashboard.routeName);
      
    } else if (apiResponse.error != null) {
      print(
          "....${apiResponse.error.message}.......apiResponse....error....${apiResponse.statusCode}....: " +
              apiResponse.error.toString());
      setState(() {
        isLoading = false;
        isErroTextPassword = apiResponse.error.message;
      });

      Fluttertoast.showToast(
          msg: apiResponse.error.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: themeData.bgColor,
          textColor: themeData.textColor,
          fontSize: 16.0);

      
    }

  }*/

  void validateLogin(BuildContext context, themeData) async {
    var urlParameters = '$keyParseServerUrl/login?username=${nameController.text}&password=${passwordController.text}';
    final uri = Uri.parse(urlParameters);

    final response = await get(
      uri,
      headers: <String, String>{
        'Content-Type': contentType,
        'X-Parse-Application-Id': keyParseApplicationId,
        'X-Parse-REST-API-Key': restAPIKey
      },);


    print(
        "......${response.statusCode}...apiResponse..------33---..TestObjectForApi.......: ");

    if (response.statusCode == 200) {
      print(".....apiResponse....TestObjectForApi.....${response.body}...: " );
      var getdata = json.decode(response.body);

      User userModel =  User.fromUser(getdata);
      await setPrefrenceUser(isUSERLOGINED, userModel);
      Provider.of<ThemeConfiguration>(context, listen: false).updateUser(userModel);

      // Fluttertoast.showToast(
      //     msg: "User logined successfully",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: themeData.bgColor,
      //     textColor: themeData.textColor,
          // fontSize: 16.0);

      Navigator.of(context).popAndPushNamed(Dashboard.routeName);
  
    }else{
      setState(() {
        isLoading = false;
        isErroTextPassword = response.body;
      });

      // Fluttertoast.showToast(
      //     msg: isErroTextPassword,
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: themeData.bgColor,
      //     textColor: themeData.textColor,
      //     fontSize: 16.0);
    }
  }

  errorValidateLocal(String type, String value) {
    //print(type + '.....setInputFields..77777...' + value);
    if (type == 'email') {
      if (!emailRegex.hasMatch(value)) {
        setState(() {
          isErroTextUser = 'Enter a valid email id';
        });
      } else
        setState(() {
          isErroTextUser = null;
        });
    } else if (type == 'password') {
      if (!passwordRegex.hasMatch(value)) {
        setState(() {
          isErroTextPassword =
              'Password should contains capital small numeric and special characters';
        });
      } else
        setState(() {
          isErroTextPassword = null;
        });
    }
  }

  Widget inputFieldWidget(
      double height, String hintLabel, String labelText, String inputType) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: height,
      child: TextField(
        controller: inputType == 'email' ? nameController : passwordController,
        decoration: InputDecoration(
          hintText: hintLabel != null ? hintLabel : '',
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.black87, fontSize: 20),
          border: const OutlineInputBorder(),
          errorText: inputType == 'email'
              ? this.isErroTextUser
              : this.isErroTextPassword,
          errorStyle: TextStyle(color: Colors.red),
          enabledBorder: const OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        keyboardType: inputType == 'email'
            ? TextInputType.emailAddress
            : TextInputType.text,
        onChanged: (text) {
          this.setInputFields(inputType, text);
          this.errorValidateLocal(inputType, text);
          //print('...onChanged....' + this.nameController.text);
        },
        obscureText: inputType == 'password' ? true : false,
      ),
    );
  }
}
