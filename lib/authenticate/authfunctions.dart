import 'package:scheduler/models/userdetails.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserId _userFromFirebaseUser(User user)
  {
    return user != null ? UserId(user.uid) : null;
  }


  Stream<UserId> get user {
    return _auth.authStateChanges().map((User user) => _userFromFirebaseUser(user));
  }

  Future signInAnon() async
  {
    try {
      var result = await _auth.signInAnonymously();

      var user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email,String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      var user = result.user;

      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future loginWithEmailAndPassword(String email,String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      var user = result.user;

      return _userFromFirebaseUser(user);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> signOut() async
  {
    try{
      await _auth.signOut();
      return "SignedOut";
    }catch(e){
      print(e.toString());
      return null;
    }
  }


}