import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:scheduler/models/models.dart';

class Forms extends StatefulWidget{
  _Form createState() => _Form();
}
class _Form extends State<Forms>{
  TextEditingController title = new TextEditingController();
  TextEditingController by = new TextEditingController();
  TextEditingController starttime = new TextEditingController();
  TextEditingController endtime = new TextEditingController();
  TextEditingController date = new TextEditingController();
  TextEditingController description = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Text("Get Started with Creating a Post",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: title,
                  decoration: InputDecoration(
                    labelText: "Title",
                    hintText: "Provide Title to the post",
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
                child: TextField(
                  controller: by,
                  decoration: InputDecoration(
                      labelText: "By",
                      hintText: "Provide club and member name",
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
                child: TextField(
                  controller: date,
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
                child: TextField(
                  controller: starttime,
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
                child: TextField(
                  controller: endtime,
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
                child: TextField(
                  controller: description,
                  maxLines: 7,
                  decoration: InputDecoration(
                      labelText: "Description",
                      hintText: "Provide description for the post",
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
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: (){
                  var data = Remainder(title.text.toString(),description.text.toString(), by.text.toString(), date.text.toString(), starttime.text.toString(), endtime.text.toString());
                  Navigator.pop(context,data);
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Submit",style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
