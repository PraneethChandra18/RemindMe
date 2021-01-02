import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/models/models.dart';
import 'package:scheduler/pages/student/CompleteFeed.dart';

import 'FeedForm.dart';

class StudentFeed extends StatefulWidget {

  final userData;
  StudentFeed(this.userData);

  @override
  _StudentFeedState createState() => _StudentFeedState();
}
bool loading = true;
class _StudentFeedState extends State<StudentFeed> {
  User user = FirebaseAuth.instance.currentUser;
  List<FeedItem> feed = [];
  List<dynamic> subscribed;
  void setReminders() async{
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("Users").doc(user.uid).get();
    subscribed = documentSnapshot.get("subscribed");
    feed.clear();
    for(int i=0;i<subscribed.length;i++)
    {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("data").doc(subscribed[i].toString()).collection("feed").get();
      List<QueryDocumentSnapshot> data = querySnapshot.docs;
      for(int j=0;j<data.length;j++)
      {
        FeedItem rem = FeedItem(
            data[j].get('title'),
            data[j].get('by'),
            data[j].get('poster'),
            data[j].get('details'),
            data[j].get('link')
        );
        print(rem);
        feed.add(rem);
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

    // FeedItem f = FeedItem("a","b","c","d","e");
    // feed.add(f);

    return (loading==true)?Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ):Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var newitem = await Navigator.push(context, MaterialPageRoute(builder: (context)=>FeedForm(widget.userData)));
          if(newitem!=null)
          {
            setState(() {
              feed.add(newitem);
            });
          }
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: ListView.builder(
        itemCount: feed.length,
        itemBuilder: (context,index) => FeedListItem(feed[index]),
      ),
    );
  }
}

class FeedListItem extends StatefulWidget {

  final FeedItem feedItem;
  FeedListItem(this.feedItem);

  @override
  _FeedListItemState createState() => _FeedListItemState();
}

class _FeedListItemState extends State<FeedListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(8,8,8,0),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: GestureDetector(
        onLongPress: (){print("Long pressed!");},
        child: ListTile(
          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>CompleteFeed(widget.feedItem)));},
          title: Text(widget.feedItem.title),
          trailing: Text(
            "Info",
            style: TextStyle(
              color: Colors.blue,
          ),
          ),
          subtitle: Text(
            widget.feedItem.by,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

        ),
      ),
    );
  }
}

