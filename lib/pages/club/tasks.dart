import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/models/models.dart';
import 'package:scheduler/pages/student/forms.dart';

class ClubTasks extends StatefulWidget {

  final userData;
  ClubTasks(this.userData);

  @override
  _ClubTasksState createState() => _ClubTasksState();
}

class _ClubTasksState extends State<ClubTasks> {

  List<Reminder> remainders = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection("Clubs").get(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot1){
          if(snapshot1.connectionState!=ConnectionState.done)
          {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          else
          {
            List<QueryDocumentSnapshot> data1 = snapshot1.data.docs;
            remainders.clear();
            return FutureBuilder(
                future: FirebaseFirestore.instance.collection("data").doc(data1[0]["uid"]).collection("reminders").get(),
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
      itemBuilder: (context,index) => RemainderListItem(widget.remainders[index]),
    );
  }
}

class RemainderListItem extends StatefulWidget {

  final Reminder remainder;
  RemainderListItem(this.remainder);

  @override
  _RemainderListItemState createState() => _RemainderListItemState();
}

class _RemainderListItemState extends State<RemainderListItem> {
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
