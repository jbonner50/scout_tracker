import 'package:firebase_auth/firebase_auth.dart';
import 'package:scout_tracker/models/user.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // sign in anon
  Future signIn() async {
    try {
      AuthResult result = await auth.signInAnonymously();
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get signInStream {
    return auth.onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign out
  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
