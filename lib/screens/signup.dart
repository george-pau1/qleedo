import '../widgets/appbar.widget.dart';
import 'package:qleedo/index.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  static const routeName = "/SignupPage";

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var firstnameController = TextEditingController();
  var lastnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isErroTextFirst;
  var isErroTextLast;
  var isErroTextEmail;
  var isErroTextPassword;
  var isLoading = false;
  final RegExp emailRegex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  final RegExp passwordRegex = new RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  final RegExp nameRegex = new RegExp(r'^[a-zA-Z]+$');
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppbarWidget(
        isSlideMenu: false,
        pageTitle: 'Sign Up',
        isTitleImage: false,
        isPlaying : false,
        isPlayDisplay: false,
        isLanguageEnabled: false,
        isLanguageSelect: ()=> {},
        isPlaySelected: ()=> {},
        pageType: '',
        updateBibleCache:()=> {} ,
      ),
      //drawer: AppDrawer(),
      body: isLoading
            ? showCircularProgress(themeData, deviceWidth, deviceHeight)
            : mainWidget(themeData,deviceWidth, deviceHeight),
    );
  }

  Widget mainWidget(ThemeConfiguration themeData, double width, double height){
    return Form(
        key: _formkey,
        child:Container(
          //color: Colors.blue,
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logowithtitle/ic_splash.png',
                    width:  width * 0.40,
                    height:  height * 0.20,
                  ),
                  SizedBox(
                    height: 10
                  ),
                  inputFieldWidget(
                    70,
                    '',
                    'First Name',
                    'firstname',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  inputFieldWidget(
                    70,
                    '',
                    'Last Name',
                    'lastname',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  inputFieldWidget(
                    70,
                    '',
                    'Email',
                    'email',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  inputFieldWidget(
                    70,
                    '',
                    'Password',
                    'password',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width - 30,
                    child: MaterialButton(
                      color: themeData.appNavBg,
                      child: Text('Sign Up', style: TextStyle(color: themeData.textColor),),
                      onPressed: () => this.callUserRegistration(themeData),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Image.asset('assets/images/seperator/img_separator.png')
                ],
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

   onClikSininButton() {
    print(emailController.text +
        '.....setInputFields..555550000...' +
        passwordController.text);
    
  }

   bool validateAndSave() {
    final form = _formkey.currentState;
    form?.save();
    if (!form!.validate()) {
      return false;
    }
    return true;
  }



    callUserRegistration(ThemeConfiguration themeData) async { 
    
    if(validateAndSave()){
    setState(() {
      isLoading = true;
    });
    var urlParameters = '$keyParseServerUrl/users';
    final uri = Uri.parse(urlParameters);
    final bodyJson = {"username":emailController.text,"password":passwordController.text,"firstName":firstnameController.text,"lastName" :lastnameController.text };

    final response = await post(
      uri,
      body: jsonEncode(bodyJson),
      headers: <String, String>{
        'Content-Type': contentType,
        'X-Parse-Application-Id': keyParseApplicationId,
        'X-Parse-REST-API-Key': restAPIKey
      },);

    print("...${response.statusCode}......singup response......${json.decode(response.body)}....");
    if (response.statusCode == 200 || response.statusCode == 201) {
          var getdata = json.decode(response.body);
          print("...${response.statusCode}......singup response...44444...$getdata....");

          this.setState(() {
             isLoading = false;
          });

          // Fluttertoast.showToast(
          // msg: "User Signup successfully",
          // toastLength: Toast.LENGTH_LONG,
          // gravity: ToastGravity.BOTTOM,
          // timeInSecForIosWeb: 1,
          // backgroundColor: themeData.bgColor,
          // textColor: Colors.white,
          // fontSize: 16.0);
          // User userModel = User(objectID: getdata['objectId'],email: emailController.text, firstName: firstnameController.text, username: emailController.text, pushObjectID: "", lastName: lastnameController.text, language: 'eg', isFirstTimeLoading: true, isLogined : true,isPushEnabled: false  ,calendar: '', form: '', church: '', gender: '', maritalStatus: '', parishObjectID: '', phoneNumber: '', prayer: '', translation: '', versifications: '');
          // await setPrefrenceUser(isUSERLOGINED, userModel);
          // Provider.of<ThemeConfiguration>(context, listen: false).updateUser(userModel);
          // Navigator.of(context).pop();

    }else if (response.statusCode > 399){
          this.setState(() {
             isLoading = false;
          });
          var getdata = json.decode(response.body);
          // Fluttertoast.showToast(
          // msg: getdata['error'],
          // toastLength: Toast.LENGTH_LONG,
          // gravity: ToastGravity.CENTER,
          // //timeInSecForIosWeb: 1,
          // backgroundColor: themeData.appNavBg,
          // textColor: themeData.textColor,
          // fontSize: 16.0);
    }

    }
    setState(() {
      isLoading = false;
    }); 

  }



  /*errorValidateLocal(String type, String value) {
    //print(type + '.....setInputFields..77777...' + value);
    if (type == 'email') {
      if (!emailRegex.hasMatch(value)) {
        setState(() {
          isErroTextEmail = 'Enter a valid email id';
        });
      } else
        setState(() {
          isErroTextEmail = null;
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
    } else if (type == 'lastname') {
      if (!nameRegex.hasMatch(value)) {
        setState(() {
          isErroTextLast = 'Enter a valid name characters';
        });
      } else
        setState(() {
          isErroTextLast = null;
        });
    } else if (type == 'firstname') {
      if (!nameRegex.hasMatch(value)) {
        setState(() {
          isErroTextFirst = 'Enter a valid name characters';
        });
      } else
        setState(() {
          isErroTextFirst = null;
        });
    }
  }*/

  Widget inputFieldWidget(
      double height, String hintLabel, String labelText, String inputType) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: height,
      child: TextFormField(
        controller: inputType == 'email'
            ? emailController
            : inputType == 'password'
                ? passwordController
                : inputType == 'lastname'
                    ? lastnameController
                    : firstnameController,
        decoration: InputDecoration(
          hintText: hintLabel != null ? hintLabel : '',
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.black87, fontSize: 20),
          border: const OutlineInputBorder(),
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
          //this.setInputFields(inputType, text);
          //this.errorValidateLocal(inputType, text);
          //print('...onChanged....' + this.nameController.text);
        },
        validator: (value) {
              return inputType == 'email' ? emailValidator(value) :isEmpty(value);
            },
        obscureText: inputType == 'password' ? true : false,
      ),
    );
  }

  String? isEmpty(String? value) {
  if (value!.isEmpty) {
    return "Cannot leave this field empty";
  }
  return null;
}

String? emailValidator(String? em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);
  if (!(regExp.hasMatch(em!))) {
    return "Invalid Email";
  }
  return null;
}
}
