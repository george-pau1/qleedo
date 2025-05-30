import 'dart:async';



class MyAppUser {
  const MyAppUser({
    required this.uid,
    required this.email,
    required this.photoUrl,
    required this.displayName,
  });

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
}

abstract class AuthService {
  Future<MyAppUser> currentUser();
  Future<MyAppUser> signInAnonymously();
  Future<MyAppUser> signInWithEmailAndPassword(String email, String password);
  Future<MyAppUser> createUserWithEmailAndPassword(
      String email, String password);
  Future<MyAppUser> signInWithGoogle();
  //Future<MyAppUser> signInWithFacebook();
  Future<void> signOut();
  Stream<MyAppUser> get onAuthStateChanged;
  void dispose();
}
