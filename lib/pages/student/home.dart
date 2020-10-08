import 'package:flutter/material.dart';
import 'package:scheduler/bridges/constants.dart';
import 'package:scheduler/pages/student/clubs.dart';
import 'package:scheduler/pages/student/feed.dart';
import 'package:scheduler/pages/student/tasks.dart';

class ThemeChanger extends StatefulWidget {
  @override
  _ThemeChangerState createState() => _ThemeChangerState();
}

class _ThemeChangerState extends State<ThemeChanger> {

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
        length: 3,
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
            ],
            bottom: TabBar(
              tabs: [
                Tab(child: Text("Tasks")),
                Tab(child: Text("Feed")),
                Tab(child: Text("Clubs")),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                Tasks(),
                Feed(),
                Clubs(),
              ],
            ),
          ),

        ),
      ),
    );
  }
}

