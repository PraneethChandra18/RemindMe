import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/models/models.dart';
import 'package:scheduler/pages/student/forms.dart';

class StudentTasks extends StatefulWidget {

  final userData;
  StudentTasks(this.userData);

  @override
  _StudentTasksState createState() => _StudentTasksState();
}
bool loading = true;
class _StudentTasksState extends State<StudentTasks> {
  User user = FirebaseAuth.instance.currentUser;
  List<Remainder> remainders = new List();
  List<dynamic> subscribed;
  void setReminders() async{
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("Users").doc(user.uid).get();
    subscribed = documentSnapshot.get("subscribed");
    remainders.clear();
    for(int i=0;i<subscribed.length;i++)
      {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("data").doc(subscribed[i].toString()).collection("reminders").get();
        List<QueryDocumentSnapshot> data = querySnapshot.docs;
        for(int j=0;j<data.length;j++)
          {
            Remainder rem = Remainder(
                data[j].get('title'),
                data[j].get('subtitle'),
                data[j].get('details'),
                data[j].get('by'),
                data[j].get('date'),
                data[j].get('startTime'),
                data[j].get('endTime')
            );
            print(data[i].get("startTime"));
            print(rem.startTime);
            remainders.add(rem);
          }
      }
    setState(() {
      loading = false;
    });
  }
  @override
  void initState() {
    loading = true;
    subscribed = new List();
    setReminders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return (loading==true)?Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ):Scaffold(
      // backgroundColor: Colors.grey[500],
      body: RemainderItems(remainders),
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
class RemainderItems extends StatefulWidget {

  final List<Remainder> remainders;
  RemainderItems(this.remainders);

  @override
  _RemainderItemsState createState() => _RemainderItemsState();
}

class _RemainderItemsState extends State<RemainderItems> {

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

  final Remainder remainder;
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
