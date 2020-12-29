import 'package:flutter/material.dart';
import 'package:scheduler/authenticate/authfunctions.dart';
import 'package:scheduler/bridges/constants.dart';
import 'package:scheduler/pages/club/feed.dart';
import 'package:scheduler/pages/club/tasks.dart';
import 'package:provider/provider.dart';

class ClubThemeChanger extends StatefulWidget {

  final userData;
  ClubThemeChanger(this.userData);

  @override
  _ClubThemeChangerState createState() => _ClubThemeChangerState();
}

class _ClubThemeChangerState extends State<ClubThemeChanger> {

  var darkmode = false;

  void toggledarkmode()
  {
    setState(() {
      darkmode = !darkmode;
    });
  }

  @override
  Widget build(BuildContext context) {

    var custom_brightness = Brightness.light;
    var custom_float_foreground = Colors.white;
    var customtextColor = Colors.black;

    if(darkmode==true) {
      custom_brightness = Brightness.dark;
      custom_float_foreground = Colors.black;
      // customtextColor = Colors.white;
    }

    return MaterialApp(
      title: 'Scheduler',
      theme: ThemeData(
        brightness: custom_brightness,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: customtextColor),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: custom_float_foreground,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Scheduler"),
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.swap_horiz,color: Colors.white),
                onPressed: (){
                  toggledarkmode();
                },
              ),
              GestureDetector(
                onTap: ()
                {
                  context.read<AuthService>().signOut();
                },
                child: Text("SignOut"),
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(child: Text("Reminders")),
                Tab(child: Text("Posts")),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                ClubTasks(widget.userData),
                ClubFeed(widget.userData),
              ],
            ),
          ),

        ),
      ),
    );
  }
}

