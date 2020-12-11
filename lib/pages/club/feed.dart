import 'package:flutter/material.dart';
import 'package:scheduler/bridges/constants.dart';
import 'package:scheduler/models/models.dart';
import 'package:scheduler/pages/student/CompleteFeed.dart';

class ClubFeed extends StatefulWidget {
  @override
  _ClubFeedState createState() => _ClubFeedState();
}

class _ClubFeedState extends State<ClubFeed> {

  List<FeedItem> feed = [];

  @override
  Widget build(BuildContext context) {

    // FeedItem f = FeedItem("a","b","c","d","e");
    // feed.add(f);

    return Scaffold(
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
          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>CompleteFeed()));},
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

