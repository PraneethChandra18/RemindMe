import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/models/models.dart';
import 'package:scheduler/pages/common/CompleteFeed.dart';
import '../forms/FeedForm.dart';

class StudentFeed extends StatefulWidget {

  final userData;
  StudentFeed(this.userData);

  @override
  _StudentFeedState createState() => _StudentFeedState();
}

bool loading = true;
class _StudentFeedState extends State<StudentFeed> {
  User user = FirebaseAuth.instance.currentUser;
  List<FeedItem> feed = new List();
  List<dynamic> subscribed;

  void setFeed() async{

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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("data").doc(subscribed[i].toString()).collection("feed").get();
      List<QueryDocumentSnapshot> data = querySnapshot.docs;
      for(int j=0;j<data.length;j++)
      {
        FeedItem f = FeedItem(
            data[j].get('title'),
            data[j].get('by'),
            data[j].get('poster'),
            data[j].get('details'),
            data[j].get('link')
        );

        feed.add(f);
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
      feed.clear();
      subscribed.clear();
      setFeed();
    });
  }

  @override
  void initState() {
    loading = true;
    _radioValue = 1;
    subscribed = new List();
    setFeed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return (loading==true)?Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ):Scaffold(
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
            child: ListView.builder(
              itemCount: feed.length,
              itemBuilder: (context,index) => FeedListItem(feed[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var newItem = await Navigator.push(context, MaterialPageRoute(builder: (context)=>FeedForm(widget.userData)));
          if(newItem!=null)
          {
            setState(() {
              feed.add(newItem);
            });
          }
        },
        child: Icon(
          Icons.add,
        ),
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

