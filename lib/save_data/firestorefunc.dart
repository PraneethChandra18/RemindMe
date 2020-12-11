import 'package:firebase_auth/firebase_auth.dart';
import 'package:scheduler/models/userdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;


  StudentDetails _studentDetailsFromFireStore({UserId user, String username, String role})
  {
    return user != null ? StudentDetails(uid: user.uid, username: username, role: role) : null;
  }

  ClubDetails _clubDetailsFromFireStore({UserId user, String username, String role, String logo})
  {
    return user != null ? ClubDetails(uid: user.uid, username: username, role: role, logo: logo) : null;
  }

  Future saveUserDetails({UserId user, String username, String role, String logo}) async {

    Map<String,dynamic> userData;
    if(role=="Student")
    {
      userData = {
        "username": username,
        "uid": user.uid,
        "role": role,
      };
    }
    else if(role=="Club")
    {
      userData = {
        "username": username,
        "uid": user.uid,
        "role": role,
        "logo":logo,
      };
    }


    final userRef = _db.collection("Users").doc(user.uid);
    await userRef.set(userData);

    return "Saved";
  }

  Future saveClubDetails({UserId user, String username, String role, String logo}) async {

    Map<String,dynamic> userData = {
      "username": username,
      "uid": user.uid,
      "role": role,
      "logo": logo,
    };

    final userRef = _db.collection("Clubs").doc(user.uid);

    await userRef.set(userData);

    return "Saved";
  }
}