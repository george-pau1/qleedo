// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:qleedo/index.dart';
// import 'package:rxdart/rxdart.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message ${message.messageId}');
// }

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();


// final BehaviorSubject<String?> selectNotificationSubject =
//     BehaviorSubject<String?>();


// class PushNotificationService {
//   final FirebaseMessaging firebaseMessage;
//   final Function updateTocken;
//   final Function navigatePage;

// PushNotificationService(this.firebaseMessage, this.updateTocken, this.navigatePage);  


//   Future initialise(User user) async {
    
//     permissionRequest();


//      if (!kIsWeb) {
//     firebaseMessage.getToken().then((token) async {
//       print("........get push token....PPNS.....$token.....");
//       updateTocken(token);
//     });

//         FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("..${message.notification!.title}....new message..${message.notification!.apple}..5555...666.${message.notification!.android}...");
//       RemoteNotification notification = message.notification as RemoteNotification;
//       AndroidNotification android = message.notification?.android as AndroidNotification;
//       // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//       /*if (notification != null && android != null && !kIsWeb) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channel.description,
//                 // TODO add a proper drawable resource to android, for now using
//                 //      one that already exists in example app.
//                 icon: 'launch_background',
//               ),
//             ));
//       }*/
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       print("..${message.notification!.body}....new message...8888.....$message...");
//     });
//      }else{
//     firebaseMessage.getToken(vapidKey: 'BJ61iyYi_ckaCbO-Wv1F8A823QNXoKH8cCKWLyh9VsN0uJPp2o8r7H6zAFyF4pFuCJYpZAICWSyEig46ZC015cg').then((token) async {
//       print("........get push token.....ANDROID....$token.....");
//       updateTocken(token);
//     });


//      }





    
//   }

//   void permissionRequest() async {
//    NotificationSettings settings = await firebaseMessage.requestPermission(
//   alert: true,
//   announcement: false,
//   badge: true,
//   carPlay: false,
//   criticalAlert: false,
//   provisional: false,
//   sound: true,
// );

// print('User granted permission: ${settings.authorizationStatus}');

//   }







//   }

