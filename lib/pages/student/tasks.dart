import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:scheduler/models/models.dart';
import 'package:scheduler/pages/forms/forms.dart';

class StudentTasks extends StatefulWidget {

  final userData;
  StudentTasks(this.userData);

  @override
  _StudentTasksState createState() => _StudentTasksState();
}
bool loading = true;
class _StudentTasksState extends State<StudentTasks> {
  User user = FirebaseAuth.instance.currentUser;
  List<Reminder> remainders = new List();
  List<dynamic> subscribed;

  void setReminders() async{
    if(_radioValue==1) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Users").doc(user.uid).get();
      subscribed = documentSnapshot.get("subscribed");
    }
    else {
      subscribed.add(user.uid);
    }

    for(int i=0;i<subscribed.length;i++)
    {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("data").doc(subscribed[i].toString()).collection("reminders").get();
      List<QueryDocumentSnapshot> data = querySnapshot.docs;
      for(int j=0;j<data.length;j++)
      {
        Reminder rem = Reminder(
            data[j].get('title'),
            data[j].get('subtitle'),
            data[j].get('details'),
            data[j].get('by'),
            data[j].get('date'),
            data[j].get('startTime'),
            data[j].get('endTime')
        );
        remainders.add(rem);
      }
    }

    setState(() {
      loading = false;
    });
  }

  int _radioValue;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      loading = true;
      remainders.clear();
      subscribed.clear();
      setReminders();
    });
  }

  @override
  void initState() {
    loading = true;
    _radioValue = 1;
    subscribed = new List();
    setReminders();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    return (loading==true)?Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ):Scaffold(
      // backgroundColor: Colors.grey[500],
      body: Column(
        children: [
          Row(
            children: [
              Spacer(),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                height: size.height*0.06,
                alignment: AlignmentDirectional.center,
                child: Row(
                  children: [
                    new Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    new Text(
                      'Only Mine',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    new Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    new Text(
                      'All Subscribed',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    FlatButton(
                        onPressed: null,
                        child: Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: Colors.blue,
                            ),
                            Text(
                              " Filter",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
              child: ReminderItems(remainders),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var newItem = await Navigator.push(context, MaterialPageRoute(builder: (context)=>Forms(widget.userData)));
          if(newItem!=null)
          {
            setState(() {
              remainders.add(newItem);
            });
          }
        },
      ),
    );
  }
}

class ReminderItems extends StatefulWidget {

  final List<Reminder> remainders;
  ReminderItems(this.remainders);

  @override
  _ReminderItemsState createState() => _ReminderItemsState();
}

class _ReminderItemsState extends State<ReminderItems> {

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: widget.remainders.length,
      itemBuilder: (context,index) => ReminderListItem(widget.remainders[index]),
    );
  }
}

class ReminderListItem extends StatefulWidget {

  final Reminder remainder;
  ReminderListItem(this.remainder);

  @override
  _ReminderListItemState createState() => _ReminderListItemState();
}

class _ReminderListItemState extends State<ReminderListItem> {
  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.fromLTRB(8,8,8,0),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: GestureDetector(
        onLongPress: (){print("Long pressed!");},
        child: ListTile(
          onTap: (){print('Tapped');},
          title: Text(widget.remainder.title),
          trailing: Icon(
            Icons.notifications_active,
            color: Colors.red,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               widget.remainder.by,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text("On "),
                  Text(widget.remainder.date),
                  SizedBox(width: 10),
                  Text("At "),
                  Text(widget.remainder.startTime),
                  Text(" to "),
                  Text(widget.remainder.endTime),
                ],
              ),
            ],
          ),
          isThreeLine: true,

        ),
      ),
    );
  }
}
