import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scheduler/authenticate/authfunctions.dart';
import 'package:scheduler/pages/student/clubs.dart';
import 'package:scheduler/pages/student/feed.dart';
import 'package:scheduler/pages/student/tasks.dart';
import 'package:provider/provider.dart';

class StudentThemeChanger extends StatefulWidget {

  final userData;
  StudentThemeChanger(this.userData);

  @override
  _StudentThemeChangerState createState() => _StudentThemeChangerState();
}

class _StudentThemeChangerState extends State<StudentThemeChanger> {

  var darkmode = false;

  void toggledarkmode()
  {
    setState(() {
      darkmode = !darkmode;
    });
  }

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {

    final tabs = [
      StudentHome(widget.userData),
      Clubs(),
    ];

    var customBrightness = Brightness.light;
    var customFloatForeground = Colors.white;
    var customTextColor = Colors.black;

    if(darkmode==true) {
      customBrightness = Brightness.dark;
      customFloatForeground = Colors.black;
      // customTextColor = Colors.white;
    }

    return MaterialApp(
      title: 'Scheduler',
      theme: ThemeData(
        brightness: customBrightness,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: customTextColor,
          fontSizeFactor: 1,
          fontSizeDelta: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: customFloatForeground,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Scheduler"),
        ),
        body: tabs[_selectedIndex-1],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          // type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: [
            darkmode == true ? BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), title: Text('Light Mode'))
                : BottomNavigationBarItem(icon: Icon(Icons.star), title: Text('Dark Mode')),
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('Clubs')),
            BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), title: Text('SignOut')),
          ],
          onTap: (value) {
            if(value==0)
            {
              toggledarkmode();
            }
            else if(value==3)
            {
              context.read<AuthService>().signOut();
            }
            else{
              setState(() {
                _selectedIndex = value;
              });
            }
          },
        ),
      ),
    );
  }
}

class StudentHome extends StatefulWidget {

  final userData;
  StudentHome(this.userData);

  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Colors.blue,
          labelPadding: EdgeInsets.fromLTRB(0, 5, 0, 0),
          tabs: [
            Tab(child: Text("Reminders")),
            Tab(child: Text("Posts")),
          ],
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              StudentTasks(widget.userData),
              StudentFeed(widget.userData),
            ],
          ),
        ),
      ),
    );
  }
}
