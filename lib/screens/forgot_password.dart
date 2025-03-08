
import '../widgets/appbar.widget.dart';
import 'package:qleedo/index.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  static const routeName = "/ForgotPassword";

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var userName = '';
  var nameController = TextEditingController();
  var isErroTextUser;
  var isLoading = false;
  final RegExp emailRegex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  @override
Widget build(BuildContext context) {
  final themeData = Provider.of<ThemeConfiguration>(context);

  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  return Scaffold(
    appBar: AppbarWidget(
      isSlideMenu: false,
      pageTitle: 'Reset Password',
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
      alignment: Alignment.topCenter,
      child: LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: CircularProgressIndicator(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Image.asset(
                'assets/images/logowithtitle/ic_splash.png',
                width: width * 0.40,
                height: height * 0.20,
              ),
              SizedBox(height: 10),
              inputFieldWidget(
                70,
                '',
                'Email',
                'email',
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                width: width - 30,
                child: MaterialButton(
                  color: themeData.appNavBg,
                  child: Text(
                    'Reset Password',
                    style: TextStyle(color: themeData.appNavTextColor),
                  ),
                  onPressed: () => onClikSininButton(themeData),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
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

  onClikSininButton(themeData) async {
    print(nameController.text + '.....setInputFields..555550000...');
    this.setState(() {
      isLoading = true;
    });
    var message = '';

    var urlParameters = '$keyParseServerUrl/requestPasswordReset';
    final uri = Uri.parse(urlParameters);
    final response = await post(
      uri,
      body: {
      'email': nameController.text
    },
      headers: <String, String>{
        'Content-Type': contentType,
        'X-Parse-Application-Id': keyParseApplicationId,
        'X-Parse-REST-API-Key': restAPIKey
      },);

    print("...forgot password.....4444.....$response.");
    if (response.statusCode == 200) {
      print("...forgot password.....4444.....${response.body}.");
      message = 'Password forgot requested';
    } else {
      print("...forgot password.....failed.....${response.body}.");
      message = response.body;
    }
    this.setState(() {
      isLoading = false;
    });
    // Fluttertoast.showToast(
    //     msg: message,
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: themeData.bgColor,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
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
    }
  }

  Widget inputFieldWidget(
      double height, String hintLabel, String labelText, String inputType) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: height,
      child: TextField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: hintLabel != null ? hintLabel : '',
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.black87, fontSize: 20),
          border: const OutlineInputBorder(),
          errorText: this.isErroTextUser,
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
