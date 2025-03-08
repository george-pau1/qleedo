import 'package:qleedo/index.dart';
import 'package:qleedo/models/index.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


enum SelectedFont { smallFont, mediumFont, largeFont }

enum DeviceType { mobile, web }

class FontConfiguration with ChangeNotifier {
  late SelectedFont fontType;
  late DeviceType deviceType;
  late int  smallSize;
  late int  mediumSize;
  late int  largeSize;

  FontConfiguration();

  void setSmallFont() {
    fontType = SelectedFont.smallFont;
    deviceType = DeviceType.mobile;
    smallSize = 2;
    notifyListeners();
  }


    
}
