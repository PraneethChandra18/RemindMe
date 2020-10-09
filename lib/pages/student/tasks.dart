import 'package:flutter/material.dart';
import 'package:scheduler/bridges/constants.dart';
import 'package:scheduler/models/remainder.dart';
import 'package:scheduler/pages/student/forms.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[500],
      body: RemainderItems(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Forms()));
        },
      ),
    );
  }
}


class RemainderItems extends StatefulWidget {
  @override
  _RemainderItemsState createState() => _RemainderItemsState();
}

class _RemainderItemsState extends State<RemainderItems> {

  List<Remainder> remainders = [];

  @override
  Widget build(BuildContext context) {
    // remainders.add(Remainder("A","B","C","D","E","F"));

    return ListView.builder(
      itemCount: remainders.length,
      itemBuilder: (context,index) => RemainderListItem(remainders[index]),
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

    Size size = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.fromLTRB(8,8,8,0),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: GestureDetector(
        onLongPress: (){print("Long pressed!");},
        child: ListTile(
          onTap: (){print('Tapped');},
          title: Text("A New Event!!"),
          trailing: Icon(
            Icons.notifications_active,
            color: Colors.red,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Coding Club",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text("On : 03-10-2020"),
                  SizedBox(width: 10),
                  Text("At : 02:00 PM"),
                  Text(" to 03:00 PM"),
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
