import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/models/models.dart';
import 'package:scheduler/pages/student/clubDetails.dart';

class Clubs extends StatefulWidget {

  @override
  _ClubsState createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {

  List<Club> clubs = new List();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection("Clubs").get(),
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
            clubs.clear();
            List<QueryDocumentSnapshot> data = snapshot.data.docs;
            for(int i=0;i<data.length;i++)
            {
              Club clubDetails = Club(
                  data[i].get('uid'),
                  data[i].get('mailId'),
                  data[i].get('username'),
                  data[i].get('logo'),
                  data[i].get('description'),
              );
              clubs.add(clubDetails);
            }
            return Scaffold(
              // backgroundColor: Colors.grey[500],
              body: ClubItems(clubs),
            );
          }
        }
    );
  }
}

class ClubItems extends StatefulWidget {

  final List<Club> clubs;
  // final Function addToSubscribed;
  ClubItems(this.clubs);

  @override
  _ClubItemsState createState() => _ClubItemsState();
}

class _ClubItemsState extends State<ClubItems> {

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: widget.clubs.length,
      itemBuilder: (context,index) => ClubListItem(widget.clubs[index]),
    );
  }
}

class ClubListItem extends StatefulWidget {

  final Club club;
  // final Function addToSubscribed;
  ClubListItem(this.club);

  @override
  _ClubListItemState createState() => _ClubListItemState();
}

class _ClubListItemState extends State<ClubListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(8,8,8,0),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: GestureDetector(
        onLongPress: (){print("Long pressed!");},
        child: ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ClubDetails(widget.club)));
          },
          title: Text(widget.club.username),
          // trailing: FlatButton(
          //   onPressed: null,
          //   child: GestureDetector(
          //     onTap: () async {
          //       await widget.addToSubscribed(widget.club.uid);
          //     },
          //     child: Text(
          //         "Subscribe",
          //       style: TextStyle(
          //         color: Colors.red,
          //       ),
          //     ),
          //   ),
          // ),
          subtitle: Text(
                widget.club.mailId,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        ),
      ),
    );
  }
}
