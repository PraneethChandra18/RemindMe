import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/authenticate/auth.dart';
import 'package:scheduler/models/userdetails.dart';
import 'package:scheduler/pages/club/home.dart';
import 'package:scheduler/pages/student/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {

    final user = context.watch<UserId>();


    return user!=null ? StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users")
            .doc(user.uid)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot>snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final userData = snapshot.data.data();
            if (userData['role'] == "Student")
              return StudentThemeChanger(userData);
            else
              return ClubThemeChanger(userData);
          }
          return Material(child: Center(child: CircularProgressIndicator(),),);
        },

      ): Authenticate();

  }
}

