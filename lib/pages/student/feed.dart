import 'package:cloud_firestore/cloud_firestore.dart';
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

class _StudentFeedState extends State<StudentFeed> {

  List<FeedItem> feed = new List();

  @override
  Widget build(BuildContext context) {

    // FeedItem f = FeedItem("a","b","c","d","e");
    // feed.add(f);

    return FutureBuilder(
        future: FirebaseFirestore.instance.collection("feed").get(),
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
            feed.clear();
            List<QueryDocumentSnapshot> data = snapshot.data.docs;
            for(int i=0;i<data.length;i++)
            {
              FeedItem rem = FeedItem(
                  data[i].get('title'),
                  data[i].get('by'),
                  data[i].get('poster'),
                  data[i].get('details'),
                  data[i].get('link')
              );
              print(rem);
              feed.add(rem);
            }
            return Scaffold(
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

