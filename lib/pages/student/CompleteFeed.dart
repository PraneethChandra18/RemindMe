import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class CompleteFeed extends StatefulWidget{
  FeedItem feed;
  CompleteFeed(this.feed);
  @override
  State<StatefulWidget> createState() {
    return _CompleteFeed(feed);
  }

}
class _CompleteFeed extends State<CompleteFeed>{
  FeedItem feed;
  _CompleteFeed(this.feed);
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
                        title: Text(feed.title,style: TextStyle(fontSize: 18),),
                        subtitle: Text(feed.by,style: TextStyle(fontSize: 15),),
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
                        child: Image.network(feed.poster,fit: BoxFit.fill,
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
                          child: Text(feed.description,style: TextStyle(fontSize: 15),),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      (feed.link==null)?Container():GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            width:  MediaQuery.of(context).size.width-40,
                            child: Text(feed.link,style: TextStyle(fontSize: 15,color: Colors.amber),),
                          ),
                        ),
                          onTap: (){
                              _launchInBrowser(feed.link);
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