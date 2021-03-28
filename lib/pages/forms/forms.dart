import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scheduler/models/models.dart';

class Forms extends StatefulWidget{

  final userData;
  Forms(this.userData);

  _Form createState() => _Form();
}

bool loading =true;
class _Form extends State<Forms>{
  TextEditingController title = new TextEditingController();
  TextEditingController subtitle = new TextEditingController();
  TextEditingController by = new TextEditingController();
  TextEditingController starttime = new TextEditingController();
  TextEditingController endtime = new TextEditingController();
  TextEditingController date = new TextEditingController();
  TextEditingController description = new TextEditingController();
  final _formkey = GlobalKey<FormState>();

  // User currentUser;
  //
  // Future<void> getUserData() async {
  //   User userDetails = FirebaseAuth.instance.currentUser;
  //   setState(() {
  //     currentUser = userDetails;
  //   });
  // }

  Future<void> addDataToFirebase(Reminder data) async {
    CollectionReference reminder = FirebaseFirestore.instance.collection("data").doc(widget.userData['uid']).collection("reminders");
    await reminder.add({
      'title': data.title,
      'subtitle': data.subtitle,
      'by': data.by,
      'senderId' : widget.userData['uid'],
      'date':data.date,
      'startTime': data.startTime,
      'endTime': data.endTime,
      'details': data.details
    }).then((value) => Fluttertoast.showToast(msg: "Data Added Successfully")).catchError((error) => Fluttertoast.showToast(msg: error.toString()));
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // CollectionReference users = FirebaseFirestore.instance.collection('Clubs');
    return SafeArea(
        child: WillPopScope(
          onWillPop: (){
            Navigator.pop(context,null);
            return Future.value(false);
          },
          child: Scaffold(
            body: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Text("Get Started with Creating a Post",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: title,
                          validator: (text){
                            if(text == null || text.isEmpty)
                              return "Field cannot be empty";
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Title",
                              hintText: "Provide Title to the post",
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.redAccent)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.blueAccent)
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.redAccent)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey.shade400)
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: subtitle,
                          validator: (text){
                            if(text == null || text.isEmpty)
                              return "Field cannot be empty";
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Sub-Title",
                              hintText: "Provide subtitle to the post",
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.redAccent)
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.redAccent)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.blueAccent)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey.shade400)
                              )
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: date,
                          validator: (text){
                            if(text == null || text.isEmpty)
                              return "Field cannot be empty";
                            return null;
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                              labelText: "Date",
                              hintText: "Provide date of event",
                              suffixIcon: IconButton(
                                icon: Icon(Icons.date_range,color: Colors.blueAccent,),
                                onPressed: (){
                                  DatePicker.showDatePicker(
                                    context,
                                    showTitleActions: true,
                                    minTime: DateTime.now(),
                                    maxTime: DateTime(DateTime.now().year+1,DateTime.now().month,DateTime.now().day),
                                    onConfirm: (dates){
                                      date.text = dates.toString().substring(0,10);
                                    },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en,
                                  );
                                },
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.redAccent)
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.redAccent)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.blueAccent)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey.shade400)
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: starttime,
                          validator: (text){
                            if(text == null || text.isEmpty)
                              return "Field cannot be empty";
                            return null;
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                              labelText: "Start Time",
                              hintText: "Provide start time of event",
                              suffixIcon: IconButton(
                                icon: Icon(Icons.schedule,color: Colors.blueAccent,),
                                onPressed: (){
                                  DatePicker.showTimePicker(
                                    context,
                                    showTitleActions: true,
                                    showSecondsColumn: false,
                                    onConfirm: (dates){
                                      starttime.text = dates.toString().substring(11,16);
                                    },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en,
                                  );
                                },
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.redAccent)
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.redAccent)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.blueAccent)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey.shade400)
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: endtime,
                          validator: (text){
                            if(text == null || text.isEmpty)
                              return "Field cannot be empty";
                            return null;
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                              labelText: "End Time",
                              hintText: "Provide end time of event",
                              suffixIcon: IconButton(
                                icon: Icon(Icons.schedule,color: Colors.blueAccent,),
                                onPressed: (){
                                  DatePicker.showTimePicker(
                                    context,
                                    showTitleActions: true,
                                    showSecondsColumn: false,
                                    onConfirm: (dates){
                                      endtime.text = dates.toString().substring(11,16);
                                    },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en,
                                  );
                                },
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.redAccent)
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.redAccent)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.blueAccent)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey.shade400)
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: description,
                          maxLines: 7,
                          validator: (text){
                            if(text == null || text.isEmpty)
                              return "Field cannot be empty";
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Description",
                              hintText: "Provide description for the post",
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.redAccent)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.blueAccent)
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.redAccent)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey.shade400)
                              )
                          ),
                        ),
                      ),
                      RaisedButton(
                        color: Colors.blueAccent,
                        onPressed: () async {
                          if(_formkey.currentState.validate()){
                            var data;
                            if(widget.userData["role"] == "Club")
                            data = Reminder(title.text.toString(),subtitle.text.toString(),description.text.toString(), widget.userData['username'], date.text.toString(), starttime.text.toString(), endtime.text.toString());
                            else data = Reminder(title.text.toString(),subtitle.text.toString(),description.text.toString(), "Personal", date.text.toString(), starttime.text.toString(), endtime.text.toString());
                            await addDataToFirebase(data);
                            Navigator.pop(context,data);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Submit",style: TextStyle(color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                )
            ),
          ),
        )
    );
  }

  }

