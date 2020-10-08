import 'package:flutter/material.dart';
import 'package:scheduler/authenticate/auth.dart';

import 'package:scheduler/bridges/constants.dart';
import 'package:scheduler/pages/student/home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  var authenticated = true;
  @override
  Widget build(BuildContext context) {

    return authenticated ? ThemeChanger() : Authenticate();
  }
}

