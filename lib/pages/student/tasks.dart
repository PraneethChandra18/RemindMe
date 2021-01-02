import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/models/models.dart';
import 'package:scheduler/pages/student/forms.dart';

class StudentTasks extends StatefulWidget {

  final userData;
  StudentTasks(this.userData);

  @override
  _StudentTasksState createState() => _StudentTasksState();
}

class _StudentTasksState extends State<StudentTasks> {

  List<Reminder> remainders = new List();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("reminders").get(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.connectionState!=ConnectionState.done)
        {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        else
        {
          remainders.clear();
          List<QueryDocumentSnapshot> data = snapshot.data.docs;
          for(int i=0;i<data.length;i++)
          {
            Reminder rem = Reminder(
                data[i].get('title'),
                data[i].get('subtitle'),
                data[i].get('details'),
                data[i].get('by'),
                data[i].get('date'),
                data[i].get('startTime'),
                data[i].get('endTime')
            );
            print(rem);
            remainders.add(rem);
          }
          return Scaffold(
            // backgroundColor: Colors.grey[500],
            body: ReminderItems(remainders),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                var newitem = await Navigator.push(context, MaterialPageRoute(builder: (context)=>Forms(widget.userData)));
                if(newitem!=null)
                {
                  setState(() {
                    remainders.add(newitem);
                  });
                }
              },
            ),
          );
        }
      }
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
    // remainders.add(Remainder("A","B","C","D","E","F"));

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
