import 'package:flutter/material.dart';
import 'package:scheduler/authenticate/normalauth.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  var signInPage = true;

  void togglesignInPage()
  {
    setState(() {
      signInPage = !signInPage ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return signInPage ? SignIn(toggle: togglesignInPage) : Register(toggle: togglesignInPage);
  }
}
