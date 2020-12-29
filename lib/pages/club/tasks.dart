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

  List<Remainder> remainders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
