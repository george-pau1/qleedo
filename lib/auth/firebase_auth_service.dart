//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:qleedo/auth/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
//import 'package:google_sign_in/google_sign_in.dart';


// class FirebaseAuthService implements AuthService {
 //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // MyAppUser _userFromFirebase(User? user) {

  //   return MyAppUser(
  //     uid: user!.uid,
  //     email: user.email.toString(),
  //     displayName: user.displayName.toString(),
  //     photoUrl: user.photoURL.toString(),
  //   );
  // }

  // @override
  // Stream<MyAppUser> get onAuthStateChanged {
  //   return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  // }

  // @override
  // Future<MyAppUser> signInAnonymously() async {
  //   final UserCredential userCredential =
  //       await _firebaseAuth.signInAnonymously();
  //   return _userFromFirebase(userCredential.user);
  // }

  // @override
  // Future<MyAppUser> signInWithEmailAndPassword(
  //     String email, String password) async {
  //   final UserCredential userCredential =
  //       await _firebaseAuth.signInWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  //   return _userFromFirebase(userCredential.user);
  // }

  // @override
  // Future<MyAppUser> createUserWithEmailAndPassword(
  //     String email, String password) async {
  //   final UserCredential userCredential = await _firebaseAuth
  //       .createUserWithEmailAndPassword(email: email, password: password);
  //   return _userFromFirebase(userCredential.user);
  // }

  // @override
  // Future<void> sendPasswordResetEmail(String email) async {
  //   await _firebaseAuth.sendPasswordResetEmail(email: email);
  // }


  // @override
  // bool isSignInWithEmailLink(String link) {
  //   return _firebaseAuth.isSignInWithEmailLink(link);
  // }



  // @override
  // Future<MyAppUser> signInWithGoogle() async {
  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  //   if (googleUser != null) {
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     if (googleAuth.accessToken != null && googleAuth.idToken != null) {
  //       final UserCredential userCredential = await _firebaseAuth
  //           .signInWithCredential(GoogleAuthProvider.credential(
  //         idToken: googleAuth.idToken,
  //         accessToken: googleAuth.accessToken,
  //       ));
  //       print("...userCredentialuserCredential....${userCredential.user}....");
  //       return _userFromFirebase(userCredential.user);
  //     } else {
  //       throw PlatformException(
  //           code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
  //           message: 'Missing Google Auth Token');
  //     }
  //   } else {
  //     throw PlatformException(
  //         code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
  //   }
  // }



  /*Future<MyAppUser> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult result = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);

  // Once signed in, return the UserCredential
  UserCredential userCredentials =  await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  print("...userCredentialuserCredential..facebook..${userCredentials.user}....");
  return _userFromFirebase(userCredentials.user);
}*/


  // @override
  // Future<MyAppUser> currentUser() async {
  //   return _userFromFirebase(_firebaseAuth.currentUser);
  // }

  // @override
  // Future<void> signOut() async {
  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //   await googleSignIn.signOut();
  //   //final FacebookAuth facebookLogin = FacebookAuth.instance;
  //   //await facebookLogin.logOut();
  //   return _firebaseAuth.signOut();
  // }

  @override
  void dispose() {}
//}
