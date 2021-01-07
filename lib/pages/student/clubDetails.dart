import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scheduler/models/models.dart';
import 'package:scheduler/pages/student/feed.dart';
import 'package:scheduler/pages/student/tasks.dart';

class ClubDetails extends StatefulWidget {

  final Club club;
  ClubDetails(this.club);

  @override
  _ClubDetailsState createState() => _ClubDetailsState();
}

class _ClubDetailsState extends State<ClubDetails> {

  User user = FirebaseAuth.instance.currentUser;

  Future<void> addToSubscribed() async {

    DocumentReference docRef = FirebaseFirestore.instance.collection("Users").doc(user.uid);
    DocumentSnapshot userData = await docRef.get();

    List<String> subscribed = userData["subscribed"].cast<String>();
    subscribed.add(widget.club.uid);

    await docRef.set({
      'role': userData['role'],
      'uid': userData['uid'],
      'username': userData['username'],
      'subscribed': subscribed,
    }).then((value) => Fluttertoast.showToast(msg: "Subscribed")).catchError((error) => Fluttertoast.showToast(msg: error.toString()));

    checkIfSubscribed();
  }

  Future<void> removeFromSubscribed() async {

    DocumentReference docRef = FirebaseFirestore.instance.collection("Users").doc(user.uid);
    DocumentSnapshot userData = await docRef.get();

    List<String> subscribed = userData["subscribed"].cast<String>();
    subscribed.removeWhere((uid) => uid == widget.club.uid);

    await docRef.set({
      'role': userData['role'],
      'uid': userData['uid'],
      'username': userData['username'],
      'subscribed': subscribed,
    }).then((value) => Fluttertoast.showToast(msg: "Subscribed")).catchError((error) => Fluttertoast.showToast(msg: error.toString()));

    checkIfSubscribed();
  }

  bool isSubscribed;
  bool loading = false;

  Future checkIfSubscribed() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance.collection("Users").doc(user.uid).get();
    List<String> subscribed = userData["subscribed"].cast<String>();

    var check = subscribed.firstWhere((uid) => uid == widget.club.uid, orElse: () => null);

    setState(() {
      isSubscribed = (check != null ? true : false);
      loading = false;
    });
  }

  @override
  void initState() {
    loading = true;
    checkIfSubscribed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> pages = [Reminders(widget.club),Posts(widget.club)];
    var size = MediaQuery.of(context).size;

    return (loading == true) ? Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ): Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context,isScolled){
            return [
              SliverAppBar(
                expandedHeight: size.height*0.4,
                floating: false,
                pinned: true,
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isSubscribed == false ? FlatButton(
                      onPressed: (){
                        setState(() {
                          loading = true;
                          addToSubscribed();
                        });
                      },
                      color: Colors.red,
                      child: Text(
                        "Subscribe",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ):FlatButton(
                      onPressed: (){
                        setState(() {
                          loading = true;
                          removeFromSubscribed();
                        });
                      },
                      color: Colors.red,
                      child: Text(
                        "Unsubscribe",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(widget.club.username),
                  background: widget.club.logo !=null ? Image.network(widget.club.logo,fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context,Widget child,ImageChunkEvent loadProgress){
                      if(loadProgress!=null)
                        return Container(
                          width: MediaQuery.of(context).size.width-40,
                          height: 300,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      else
                        return child;
                    },
                  ): Container(),
                ),
              ),

              SliverToBoxAdapter(
                child: Description(widget: widget),
              ),

              SliverPersistentHeader(
                delegate: MyDelegate(
                    TabBar(
                      tabs: [
                        Tab(child: Text("Reminders"),),
                        Tab(child: Text("Posts"),),
                      ],
                      indicatorColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.black,
                    )
                ),
                floating: false,
                pinned: true,
              ),
            ];
          },

          body: TabBarView(
            children: pages,
          ),
        ),
      ),
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate{
  MyDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

}

class Description extends StatelessWidget {
  const Description({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final ClubDetails widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2, 8, 2, 8),
      child: Container(
        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Description",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Mail id: ${widget.club.mailId}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),

            SizedBox(height: 20.0),
            Text(
              widget.club.description,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Reminders extends StatefulWidget {

  final Club club;
  Reminders(this.club);

  @override
  _RemindersState createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {

  List<Reminder> reminders = new List();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection("data").doc(widget.club.uid).collection("reminders").get(),
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
            reminders.clear();
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
              reminders.add(rem);
            }
            return CustomScrollView(
              slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return ReminderListItem(reminders[index]);
                  },
                  childCount: reminders.length,
                ),
              ),
              ],
            );
          }
        }
    );
  }
}

class Posts extends StatefulWidget {

  final Club club;
  Posts(this.club);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {

  List<FeedItem> feed = new List();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection("data").doc(widget.club.uid).collection("feed").get(),
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
              feed.add(rem);
            }
            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return FeedListItem(feed[index]);
                    },
                    childCount: feed.length,
                  ),
                ),
              ],
            );
          }
        }
    );
  }
}
