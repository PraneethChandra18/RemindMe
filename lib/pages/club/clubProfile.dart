import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/models/models.dart';


class ClubProfile extends StatefulWidget {
  @override
  _ClubProfileState createState() => _ClubProfileState();
}

class _ClubProfileState extends State<ClubProfile> {

  User user = FirebaseAuth.instance.currentUser;

  bool loading = true;

  Club clubDetails;

  void getClubDetails() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("Clubs").doc(user.uid).get();

    setState(() {
      loading = false;
      clubDetails = Club(
        documentSnapshot.get('uid'),
        documentSnapshot.get('mailId'),
        documentSnapshot.get('username'),
        documentSnapshot.get('logo'),
        documentSnapshot.get('description'),
      );
    });
  }

  @override
  void initState() {
    loading = true;
    getClubDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return loading ? Center(
      child: CircularProgressIndicator(),
    ): Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          clubDetails.logo !=null ? Center(
            child: Container(
              height: size.height * 0.4,
              child: Image.network(clubDetails.logo,fit: BoxFit.fill,
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
              ),
            ),
          ): Text("No logo is uploaded"),
          ClubDescription(clubDetails: clubDetails),
          SizedBox(height: 20),
          RaisedButton(
            onPressed: null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit),
                Text("Edit"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ClubDescription extends StatelessWidget {
  const ClubDescription({
    Key key,
    @required this.clubDetails,
  }) : super(key: key);

  final Club clubDetails;

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
              "Mail id: ${clubDetails.mailId}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),

            SizedBox(height: 20.0),
            clubDetails.description != null ? Text(
              clubDetails.description,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
