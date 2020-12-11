import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:scheduler/authenticate/authfunctions.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/save_data/firestorefunc.dart';

class SignIn extends StatefulWidget {

  final Function toggle;

  const SignIn({Key key, this.toggle}) : super(key: key);


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  bool loading = false;

  String email='';
  String password='';
  String error='';

  bool secureText = true;

  void togglesecureText()
  {
    setState(() {
      secureText = !secureText;
    });
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    var card = new Card(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.025 ,size.width * 0.05, size.height * 0.05),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Sign In",
                ),
              ),
              Form(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Email",
                        labelText: "Email",
                        fillColor: Colors.white,
                        filled: true,

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),

                        suffixIcon: Icon(Icons.person),
                      ),
                      onChanged: (val){
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Password",
                        labelText: "Password",
                        fillColor: Colors.white,
                        filled: true,

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        suffix: GestureDetector(onTap: togglesecureText, child: Icon(Icons.remove_red_eye)),
                      ),
                      obscureText: secureText,
                      onChanged: (val){
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: Colors.lightBlueAccent,
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.loginWithEmailAndPassword(email, password);
                        if(result == null)
                        {
                          setState(() {
                            loading = false;
                            error = 'Wrong credentials !';
                          });
                        }
                      },
                      child: Text(
                        'signIn',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                        error,
                      style: TextStyle(
                        color: Colors.red[900],
                      ),

                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.0),

              Center(
                child: Row(
                  children: [
                    Text(
                      "Didn't have an account? ",
                      style: TextStyle(
                        fontSize: size.width * 0.04,
                      ),
                    ),

                    GestureDetector(
                      onTap: widget.toggle,
                      child: Text(
                        "SignUp",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: size.width * 0.04),

                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

    var sizedBox = new Center(
      child: Container(
        color: Colors.lightBlueAccent,
        margin: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.1, size.width * 0.05, size.height * 0.1),
        child: SizedBox(
          child: card,
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: sizedBox,
          ),
        ),
      ),
    );
  }
}


class Register extends StatefulWidget {

  final Function toggle;

  const Register({Key key, this.toggle}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final FireStoreService _fss = FireStoreService();

  bool loading = false;

  String email;
  String password;
  String confirmPassword;
  String role;
  String username;
  var logo;
  bool visibility = false;
  String error='';

  bool secureText = true;

  void togglesecureText()
  {
    setState(() {
      secureText = !secureText;
    });
  }


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    List<String> UserType = ["--SELECT--","Student", "Club"];

    var card = new Card(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.025 ,size.width * 0.05, size.height * 0.05),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Sign Up",
                ),
              ),

              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Email",
                        labelText: "Email",
                        fillColor: Colors.white,
                        filled: true,

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),

                        suffixIcon: Icon(Icons.person),
                      ),
                      onChanged: (val){
                        setState(() {
                          email = val;
                        });
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter proper email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Password",
                        labelText: "Password",
                        fillColor: Colors.white,
                        filled: true,

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        suffix: GestureDetector(onTap: togglesecureText, child: Icon(Icons.remove_red_eye)),
                      ),
                      obscureText: secureText,
                      onChanged: (val){
                        setState(() {
                          password = val;
                        });
                      },
                      validator: (val) {
                        if (val.length < 6 ) {
                          return 'Password length must be > 5';
                        }
                        return null;
                      },

                    ),

                    SizedBox(height: 20.0),

                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        labelText: "Confirm Password",
                        fillColor: Colors.white,
                        filled: true,

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        suffix: GestureDetector(onTap: togglesecureText, child: Icon(Icons.remove_red_eye)),
                      ),
                      obscureText: secureText,
                      onChanged: (val){
                        setState(() {
                          confirmPassword = val;
                        });
                      },
                      validator: (val) {
                        if (val.isEmpty || confirmPassword != password) {
                          return "Confirm password didn't match with password";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20.0),

                    DropdownButtonFormField(
                      hint: Text('Select your role'),
                      value: UserType[0],
                      items: UserType.map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label)).toList(),
                      onChanged: (val) {
                        setState(() {
                          role = val;
                          visibility = true;
                          error = '';
                        });
                      },
                    ),
                    Divider(color: Colors.grey, height: 20.0),

                    visibility ? (role == "Student" ? Column(
                      children: <Widget>[
                        Center(
                            child: Text(
                              "Student Details",
                            )
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Username",
                            labelText: "Username",
                            fillColor: Colors.white,
                            filled: true,

                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                          onChanged: (val){
                            setState(() {
                              username = val;
                            });
                          },
                        ),
                      ],
                    ) : (role == "Club" ? Column(
                      children: <Widget>[
                        Center(
                          child: Text(
                              "Club Details"
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Username",
                            labelText: "Username",
                            fillColor: Colors.white,
                            filled: true,

                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),

                          ),
                          onChanged: (val){
                            setState(() {
                              username = val;
                            });
                          },
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Please enter proper username';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Logo",
                            labelText: "Logo",
                            fillColor: Colors.white,
                            filled: true,

                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                          onChanged: (val){
                            setState(() {
                              logo = val;
                            });
                          },
                        ),
                      ],
                    ) : Container()
                    )
                    ) : Container(),

                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: Colors.lightBlueAccent,
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });

                        if(role != "Student" && role != "Club")
                        {
                          setState(() {
                            loading = false;
                            error = "Select your role";
                          });
                        }
                        else {
                          if (_formKey.currentState.validate()) {
                            dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Please enter a valid email !';
                              });
                            }
                            else{
                              dynamic userDetails = await _fss.saveUserDetails(user: result, username: username, role: role, logo: logo);

                              if(role=="Club") dynamic clubDetails = await _fss.saveClubDetails(user: result, username: username, role: role, logo: logo);
                            }
                          }
                        }
                      },
                      child: Text(
                        'SignUp',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),

              Row(
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: size.width * 0.04),
                  ),

                  GestureDetector(
                    onTap: widget.toggle,
                    child: Text(
                      "SignIn",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: size.width * 0.04,),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
            ],

          ),
        ),
      ),
    );

    var sizedBox = new Center(
      child: Container(
        color: Colors.lightBlueAccent,
        margin: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.1, size.width * 0.05, size.height * 0.1),
        child: SizedBox(
          child: card,
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: sizedBox,
          ),
        ),
      ),
    );

  }
}
