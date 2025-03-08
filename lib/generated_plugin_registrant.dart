//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars

import 'package:audioplayers_web/audioplayers_web.dart';
import 'package:connectivity_for_web/connectivity_for_web.dart';
//import 'package:firebase_analytics_web/firebase_analytics_web.dart';
//import 'package:firebase_auth_web/firebase_auth_web.dart';
//import 'package:firebase_core_web/firebase_core_web.dart';
//import 'package:firebase_messaging_web/firebase_messaging_web.dart';
import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
//import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';
//import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  AudioplayersPlugin.registerWith(registrar);
  ConnectivityPlugin.registerWith(registrar);
  //FirebaseAnalyticsWeb.registerWith(registrar);
  //FirebaseAuthWeb.registerWith(registrar);
  //FirebaseCoreWeb.registerWith(registrar);
  //FirebaseMessagingWeb.registerWith(registrar);
  FlutterTtsPlugin.registerWith(registrar);
  FluttertoastWebPlugin.registerWith(registrar);
  //GoogleMapsPlugin.registerWith(registrar);
  //GoogleSignInPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
