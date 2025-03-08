import 'package:qleedo/index.dart';
import 'package:qleedo/models/index.dart';


enum SelectedTheme { lightTheme, darkTheme }

class ThemeConfiguration with ChangeNotifier {

  bool _isDarkMode = false; // Default is light mode

  bool get isDarkMode => _isDarkMode; // Getter
  
  late SelectedTheme themeType;
  late Color appNavBg;
  late Color appNavTextColor;
  late Color bgColor;
  late Color brandColor;
  late Color textColor;
  late Color textHeading;
  late Color textSubHeading;
  late Color subtitleColor;
  late Color menuColor;
  late Color calendarBorderColor;
  late Color calendarSelectedColor;
  late Color calendarTodaysColor;
  late Color listTextColor;
  
  late User user;
  late UserBible bible;

  ThemeConfiguration();

  void setLightTheme(User user, UserBible bible) {
    themeType = SelectedTheme.lightTheme;
    bgColor = const Color(0xfffaf5f5);
    brandColor = const Color(0xff4e1208);
    appNavBg = const Color(0xfff9d598);
    appNavTextColor = const Color(0xff000000);
    textColor = const Color(0xff000000);
    textHeading = const Color(0xffFFFFFF);
    textSubHeading = const Color(0xff191915);
    subtitleColor = const Color(0xffF3D8CE);
    menuColor = const Color(0xfff2e4d7);
    calendarBorderColor = const Color(0xffc07b2d);
    calendarSelectedColor = const Color(0xffadacaa);
    calendarTodaysColor = const Color(0xff5c3111);
    listTextColor = const Color(0xff000000);
    this.user = user;
    this.bible = bible;
    notifyListeners();
  }

  void setDarkTheme(User user, UserBible bible) {
    themeType = SelectedTheme.darkTheme;
    bgColor = const Color(0xfff7f7f7);
    brandColor = const Color(0xff4e1208);
    appNavBg = const Color(0xff5c2f10);
    appNavTextColor = const Color(0xffFFFFFF);
    textColor = const Color(0xff000000);
    textHeading = const Color(0xffFFFFFF);
    textSubHeading = const Color(0xffF7F7F7);
    subtitleColor = const Color(0xffF3D8CE);
    menuColor = const Color(0xfff5c69a);
    calendarBorderColor = const Color(0xffc07b2d);
    calendarSelectedColor = const Color(0xffadacaa);
    calendarTodaysColor = const Color(0xff5c3111);
    listTextColor = const Color(0xff000000);
    this.user = user;
    this.bible = bible;

    notifyListeners();
  }

  updateUser(User user){
      ////print("........update user.......");
      this.user = user;
      notifyListeners();
  }

  updateBible(UserBible bible){
      ////print("........update user.......");
      this.bible = bible;
      notifyListeners();
  }
    
}
