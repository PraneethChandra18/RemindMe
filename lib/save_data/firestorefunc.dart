import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:scheduler/models/userdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;


  // StudentDetails _studentDetailsFromFireStore({UserId user, String username, String role})
  // {
  //   return user != null ? StudentDetails(uid: user.uid, username: username, role: role) : null;
  // }
  //
  // ClubDetails _clubDetailsFromFireStore({UserId user, String username, String role, String logo})
  // {
  //   return user != null ? ClubDetails(uid: user.uid, username: username, role: role, logo: logo) : null;
  // }

  Future saveUserDetails({UserId user, String username, String role, String logo, List<String> subscribed, List<String> subscribers}) async {

    Map<String,dynamic> userData;
    if(role=="Student")
    {
      userData = {
        "username": username,
        "uid": user.uid,
        "role": role,
        "subscribed": subscribed,
        "subscribers": subscribers,
      };
    }
    else if(role=="Club")
    {
      // List<String> subscribeAll = new List();
      // FirebaseFirestore.instance.collection("Clubs").get().then((allClubs){
      //   allClubs.docs.forEach((club) {
      //     subscribeAll.add(club['uid']);
      //   });
      // });

      userData = {
        "username": username,
        "uid": user.uid,
        "role": role,
        "logo":logo,
        "subscribers": subscribers,
        // "subscribed": subscribeAll,
      };
    }


    final userRef = _db.collection("Users").doc(user.uid);
    await userRef.set(userData);

    return "Saved";
  }

  Future saveClubDetails({UserId user, String mailId, String username, String role, String logo, String description}) async {

    Map<String,dynamic> userData = {
      "mailId": mailId,
      "username": username,
      "uid": user.uid,
      "role": role,
      "logo": logo,
      "description": description,
    };

    final userRef = _db.collection("Clubs").doc(user.uid);

    await userRef.set(userData);

    return "Saved";
  }

  Future saveTokens({String token}) async {

    final docRef = _db.collection("Tokens").doc("Device Tokens");
    DocumentSnapshot tokensData = await docRef.get();

    if(tokensData.exists)
    {
      String token = await FirebaseMessaging.instance.getToken();

      List<String> tokens = tokensData["tokens"].cast<String>();

      var product = tokens.firstWhere((deviceToken) => deviceToken == token,
          orElse: () => null);

      if (product == null) tokens.add(token);

      await docRef.set({
        'tokens': tokens,
      });
    }
    else {
      List<String> tokens = new List();
      tokens.add(token);

      docRef.set({
        "tokens": tokens,
      });
    }
  }
}
