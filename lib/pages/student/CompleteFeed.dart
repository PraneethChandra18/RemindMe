import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CompleteFeed extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CompleteFeed();
  }

}
class _CompleteFeed extends State<CompleteFeed>{
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Material(
                  elevation: 10,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Container(
                          // height: 50,
                          // width: 40,
                          child: Image.network("https://firebasestorage.googleapis.com/v0/b/onestopiitg.appspot.com/o/AdminDps%2FAd96qUcJY4PUoIQqhX8yWTjysTu2.jpeg?alt=media&token=9323fe7a-a903-4fbd-9675-9a1fb30d94ed",fit: BoxFit.fill,
                            loadingBuilder: (BuildContext context,Widget child,ImageChunkEvent loadProgress){
                              if(loadProgress!=null)
                                return CircularProgressIndicator();
                              else
                                return child;
                            },
                          ),
                        ),
                        title: Text("Srijan: Annual Art Exhibition",style: TextStyle(fontSize: 18),),
                        subtitle: Text("This is a sub-title for given post",style: TextStyle(fontSize: 15),),
                        trailing: IconButton(
                          icon: Icon(Icons.share),
                          onPressed: (){
                            return null;
                          },
                        ),
                      ),
                      Container(
                        //  height: MediaQuery.of(context).size.width-40,
                        // width:  MediaQuery.of(context).size.width-40,
                        child: Image.network("https://firebasestorage.googleapis.com/v0/b/onestopiitg.appspot.com/o/PostImages%2F5Q2aXhWosDxdPOboRwy5.jpeg?alt=media&token=e65a143c-56a2-4fc0-9e1a-3ad725e24735",fit: BoxFit.fill,
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
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width:  MediaQuery.of(context).size.width-40,
                          child: Text("Salutations to all! Srijan, the Annual Art Exhibition of the Fine Arts Club is here to inundate you with a magnificent collection of artworks.  Lay your feet inside New Sac and witness the aesthetic awe all by yourself. Venue: NEW SAC Schedule: Friday (Today): Inauguration and Exhibition- 5 PM Saturday: Exhibition- 9AM to 9PM Workshop- 1PM (Fine Arts club) Sunday: Exhibition- 9AM to 9PM ",style: TextStyle(fontSize: 15),),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            width:  MediaQuery.of(context).size.width-40,
                            child: Text("https://forms.gle/NTfT87seQYohiTob6",style: TextStyle(fontSize: 15,color: Colors.amber),),
                          ),
                        ),
                          onTap: (){
                              _launchInBrowser("https://forms.gle/NTfT87seQYohiTob6");
                          },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        )
    );
  }

}