import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/models/models.dart';

class CompleteTask extends StatefulWidget{
  final Reminder reminder;
  CompleteTask(this.reminder);
  @override
  State<StatefulWidget> createState() {
    return _CompleteTask(reminder);
  }

}
class _CompleteTask extends State<CompleteTask>{
  Reminder reminder;
  _CompleteTask(this.reminder);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Material(
                  elevation: 10,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: Text(reminder.title,style: TextStyle(fontSize: 18),),
                        subtitle: Text(reminder.subtitle,style: TextStyle(fontSize: 15),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child: Container(
                          width:  MediaQuery.of(context).size.width-40,
                          child: Text("Created by: "+reminder.by,style: TextStyle(fontSize: 15),),
                        ),
                      ),
                      ListTile(
                        title: Text("Date: "+reminder.date,style: TextStyle(fontSize: 15),),
                        subtitle: Text("Start Time: "+reminder.startTime+" End Time: "+reminder.endTime,style: TextStyle(fontSize: 15),),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width:  MediaQuery.of(context).size.width-40,
                          child: Text(reminder.details,style: TextStyle(fontSize: 15),),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        )
    );
  }

}