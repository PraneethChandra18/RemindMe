import 'package:flutter/material.dart';
import 'package:scheduler/authenticate/authfunctions.dart';
import 'package:scheduler/pages/club/clubProfile.dart';
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

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {

    final tabs = [
      ClubHome(widget.userData),
      ClubProfile(),
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
        textTheme: Theme.of(context).textTheme.apply(bodyColor: customTextColor),
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
            BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Profile')),
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

class ClubHome extends StatefulWidget {

  final userData;
  ClubHome(this.userData);

  @override
  _ClubHomeState createState() => _ClubHomeState();
}

class _ClubHomeState extends State<ClubHome> {
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
              ClubTasks(widget.userData),
              ClubFeed(widget.userData),
            ],
          ),
        ),

      ),
    );
  }
}
