import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:qleedo/index.dart';
import 'package:qleedo/screens/login.dart';
import 'package:qleedo/screens/search.dart';

//const AppThemeColor.appNavTextColor = Color.fromRGBO(192, 152, 83, 1);
//const AppThemeColor.appNavTextColor = Color.fromRGBO(255, 255, 255, 1);
  //CustomPopupMenuController _controller = CustomPopupMenuController();


class AppbarWidget extends StatelessWidget implements PreferredSizeWidget { // Changed this
  final CustomPopupMenuController _controller = CustomPopupMenuController(); // Changed this to make it inside the class
  final bool isSlideMenu;
  final String pageTitle;
  final bool isTitleImage;
  final Function isLanguageSelect;
  final Function isPlaySelected;
  final bool isPlaying;
  final bool isPlayDisplay;
  final bool isLanguageEnabled;
  final String pageType;
  final Function updateBibleCache;

  AppbarWidget(
      {required this.isSlideMenu,
      required this.pageTitle,
      required this.isTitleImage,
      required this.isLanguageSelect,
      required this.isPlaySelected,
      required this.isPlaying,
      required this.isPlayDisplay,
      required this.pageType,
      required this.updateBibleCache,
      required this.isLanguageEnabled});
  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeConfiguration>(context);

    if (this.isSlideMenu)
      return this.createAppbarForMenu(context, themeData);
    else
      return this.createAppbarForBackbutton(context, themeData);
  }

  void menuClikc(BuildContext context) {
    if (pageType == 'BIB') {
      //_showAlert(context);
      //Navigator.of(context).pop();
      this.updateBibleCache();
      Scaffold.of(context).openDrawer();
    } else {
      Scaffold.of(context).openDrawer();
    }
  }

  void _showAlert(BuildContext mainContext, themeData) async {
    showDialog(
      context: mainContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Qleedo'),
          content: const Text('Do you want to cache the bible reading ?'),
          actions: <Widget>[
            TextButton(
                child: const Text('Not Now'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Scaffold.of(mainContext).openDrawer();
                  //sharedPref.setBool(isFirstTimeLoading, false);
                }),
            TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  this.updateBibleCache();
                  //Scaffold.of(context).openDrawer();
                  //sharedPref.setBool(isFirstTimeLoading, false);
                })
          ],
        );
      },
    );
  }

  Widget createAppbarForMenu(BuildContext context, themeData) {
    return AppBar(
      backgroundColor : themeData.appNavBg,
      iconTheme: new IconThemeData(color: themeData.appNavTextColor),
      leading: IconButton(
        icon: Icon(
          Icons.menu_outlined,
          color: themeData.appNavTextColor,
          size: 35,
        ),
        onPressed: () => {this.menuClikc(context)},
      ),
      title: this.isTitleImage
          ? Image.asset(
              'assets/images/logotop/logo_top.png',
              color: themeData.appNavTextColor,
            )
          : Text(
              this.pageTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: themeData.appNavTextColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
      automaticallyImplyLeading: this.isSlideMenu ? true : false,
      actions: <Widget>[
        /*this.isPlayDisplay
            ? IconButton(
                icon: Icon(isPlaying ? Icons.volume_up_outlined : Icons.volume_down_outlined),
                color: AppThemeColor.appNavTextColor,
                onPressed: () {},
                //onPressed: () => isPlaySelected(isPlaying),
              )
            : Text(''),*/
        isSlideMenu
            ? IconButton(
                icon: const Icon(Icons.search),
                color: themeData.appNavTextColor,
                onPressed: () {
                  Navigator.of(context).pushNamed(SearchScreen.routeName);
                },
              )
            : const Text(''),
        isLanguageEnabled
            ? IconButton(
                icon: const Icon(Icons.translate),
                color: themeData.appNavTextColor,
                onPressed: () {
                  print("......language select.......");
                  isLanguageSelect();
                } ,
              )
            : const Text(''),
        /*IconButton(
                icon: const Icon(Icons.settings),
                color: themeData.appNavTextColor,
                onPressed: () {
                  print("......qleedo settings.......");
                  //isLanguageSelect();

                } ,
              ),*/
              CustomPopupMenu(
            child: Container(
              child:  Icon(Icons.settings,color: themeData.appNavTextColor,),
              padding: EdgeInsets.all(20),
            ),
            menuBuilder: () => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: themeData.bgColor,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: 
                            [ 
                              themeView(themeData, context),
                              singninButton( context,themeData, themeData.user.isLogined == false ? "Signin" : "Logout", themeData.user.isLogined == false ? "Login" : "Logout"),
                    ])
                ),
                ),
              ),
            pressType: PressType.singleClick,
            verticalMargin: -10,
            controller: _controller,
          ),
        ],
    );
  }

  Widget createAppbarForBackbutton(BuildContext context , themeData) {
    return AppBar(
      backgroundColor : themeData.appNavBg,
      iconTheme:  IconThemeData(color: themeData.appNavTextColor),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: themeData.appNavTextColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        pageTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: themeData.appNavTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        isSlideMenu
            ? IconButton(
                icon: const Icon(Icons.search),
                color: themeData.appNavTextColor,
                onPressed: () {},
              )
            : const Text(''),
        isSlideMenu
            ? IconButton(
                icon: const Icon(Icons.add_circle),
                color: themeData.appNavTextColor,
                onPressed: () {},
              )
            : const Text(''),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  themeView(ThemeConfiguration themeData, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xfff5bb90)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Select Theme  ",
            style: TextStyle(
              color: themeData.textColor,
              fontSize: 12,
              fontWeight: fontBold,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              themeItemView(themeData, Color(0xfffffbf6), "L",context),
              SizedBox(width: 10),
              themeItemView(themeData, Color(0xff40220a), "D",context),
            ],
          )
        ],
      ),
    );
  }

   themeItemView(ThemeConfiguration themeData, Color colorsItem, String type, BuildContext context){
    //print("....$type....theme item......${themeData.themeType}......");
    return GestureDetector(
      // When the child is tapped, show a snackbar.
      onTap: ()  {
        //print(".....themeItemView....$type...");
        if(type == 'L')
          Provider.of<ThemeConfiguration>(context,listen: false).setLightTheme(themeData.user, themeData.bible);
        else if(type == 'D')
          Provider.of<ThemeConfiguration>(context,listen: false).setDarkTheme(themeData.user, themeData.bible);
  
        
      },
      // The custom button
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration:  BoxDecoration(
          color: colorsItem,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.done,
          size: 25,
          color: type == 'L'
              ? themeData.themeType == SelectedTheme.lightTheme
                  ? Colors.red
                  : Colors.transparent
              : type == 'D'
                  ? themeData.themeType == SelectedTheme.darkTheme
                      ? Colors.red
                      : Colors.transparent
                  : Colors.transparent,
        ),
      ),
    );
  }

  Widget singninButton(BuildContext context, ThemeConfiguration themeData,String title, String routeName){
      return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  //width: MediaQuery.of(context).size.width * 0.50,
                  height: 40,
                  child: MaterialButton(
                    color: themeData.appNavBg,
                    onPressed: () {
                        print("...$routeName....singninButton.....$title..========${themeData.user.isLogined}..");
                        if(themeData.user.isLogined == false ){
                          Navigator.of(context).pushNamed(LoginPage.routeName);
                        }else{
                          userSignout(context);
                        }
                        _controller.hideMenu();
                    } ,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10)),
                    child: Text(
                      title,
                      style: TextStyle(color: themeData.appNavTextColor),
                    ),
                  ),
                );
  }

   userSignout(BuildContext context) async {
    User userModel = const User(objectID : '',email: '', firstName: '', username: '', pushObjectID: '', lastName: '', language: 'eg', isFirstTimeLoading: true, isLogined : false, isPushEnabled: false, calendar: '', form: '', church: '', gender: '', maritalStatus: '', parishObjectID: '', phoneNumber: '', prayer: '', translation: '', versifications: '');
    await setPrefrenceUser(isUSERLOGINED, userModel);
    Provider.of<ThemeConfiguration>(context, listen: false).updateUser(userModel);

  }

  
}
