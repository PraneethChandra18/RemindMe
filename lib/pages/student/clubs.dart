import 'package:flutter/material.dart';
import 'package:scheduler/bridges/constants.dart';
import 'package:scheduler/models/models.dart';

class Clubs extends StatefulWidget {
  @override
  _ClubsState createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {

  List<Club> clubs = [];

  @override
  Widget build(BuildContext context) {

    clubs.add(Club("code@abc.com","Coding Club","logo","description"));
    clubs.add(Club("some@abc.com","Some Club","logo","description"));
    clubs.add(Club("fun@abc.com","Fun Club","logo","description"));

    return Scaffold(
      // backgroundColor: Colors.grey[500],
      body: ClubItems(clubs),
    );
  }
}

class ClubItems extends StatefulWidget {

  final List<Club> clubs;
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
          onTap: (){print('Tapped');},
          title: Text(widget.club.name),
          trailing: FlatButton(
            onPressed: null,
            child: Text(
                "Subscribe",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          subtitle: Text(
                widget.club.mailId,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        ),
      ),
    );
  }
}
