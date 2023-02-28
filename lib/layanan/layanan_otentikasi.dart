import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mytimses/layanan/layanan_database.dart';
import 'package:mytimses/models/pengguna.dart';

class LayananOtentikasi {

  // create firebase authentication secondary instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instanceFor(app: Firebase.app());

  // create user object based on firebase user
  Pengguna? _userFromFirebaseUser(User? user) {
    try {
      return (user != null) ? Pengguna(uid: user.uid, email: user.email.toString()) : null;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // on auth changed user stream
  Stream<Pengguna>? get onAuthStateChanges {
    try {
      return _firebaseAuth.authStateChanges().map((User? user) {
        return _userFromFirebaseUser(user)!;
      });
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign in anonymously
  Future<dynamic> signInAnonymously() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      User? user = userCredential.user;

      print("sign in anonymously: $user");
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign in  with email and password
  Future<dynamic> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      User? user = userCredential.user;

      return _userFromFirebaseUser(user);

    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future<dynamic> registerWithEmailAndPassword(String email, String password) async {
    try {
      // firebase authentication result
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      // firebase user
      User? user = result.user;

      // create a new document for the user with the uid
      await LayananDatabase(uid: user!.uid).setTimsesData(
          user.uid,
          "timses baru",
          "nama caleg",
          "tambun selatan",
          "kelurahan jatimulya",
          0
      );
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future<dynamic> signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}