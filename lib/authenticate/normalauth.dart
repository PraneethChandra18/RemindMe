import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
String logo;
class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final FireStoreService _fss = FireStoreService();

  bool loading = false;

  String email;
  String password;
  String confirmPassword;
  String role;
  String username;
  String description;
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

                      /*  RaisedButton(
                          color: Colors.blueAccent,
                          onPressed: () async {
                            String result = await sendDocument();
                            if(result!=null)
                            {
                              setState(() {
                                logo = result;
                              });
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("Upload Image",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        (logo==null)?Container():CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                            ),
                            width: 50.0,
                            height: 50.0,
                            padding: EdgeInsets.all(70.0),
                          ),
                          errorWidget: (context, url, error) =>
                              Material(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Center(
                                    child: Icon(Icons.warning,color: Colors.black,size: 100,),
                                  ),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                          imageUrl: logo,
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        ),*/
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Description",
                            labelText: "Description",
                            fillColor: Colors.white,
                            filled: true,

                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                          ),
                          onChanged: (val){
                            setState(() {
                              description = val;
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
                          if (_formKey.currentState.validate()) { //add check for logo not null
                            dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Please enter a valid email !';
                              });
                            }
                            else{
                              List<String> subscribed = new List();
                              dynamic userDetails = await _fss.saveUserDetails(user: result, username: username, role: role, logo: logo, subscribed: subscribed);

                              if(role=="Club") dynamic clubDetails = await _fss.saveClubDetails(user: result, mailId: email, username: username, role: role, logo: logo, description: description);
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
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
  Future<String> sendDocument() async {
    File documentToUpload;
    documentToUpload = await documentSender();
    if(documentToUpload==null)
      return null;
    else
    {
      String message = await uploadFile(documentToUpload);
      if(message==null)
        return null;
      else
      {
        return message;
      }
    }
  }

  Future<File> documentSender(){
    return FilePicker.getFile();
  }

  Future<String> uploadFile(documentFile) async {
    String imageUrl;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    await reference.putFile(documentFile).then((storageTaskSnapshot) async {
      await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl){
        imageUrl = downloadUrl;
        print(downloadUrl);
      },onError: (err){
        print(err.toString());
      });
    },onError: (err){
      print("error");
    });
    return imageUrl;
  }
}
