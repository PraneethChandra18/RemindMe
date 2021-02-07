import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'authenticate/authfunctions.dart';
import 'bridges/wrapper.dart';
import 'package:provider/provider.dart';
const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('launch_background');
final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
    onDidReceiveLocalNotification: onDidReceiveLocalNotification,
);
final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS
);
Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  print(id.toString()+"#"+title+"#"+body+"#"+payload);
}
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  if (message.data!=null) {
    print(message.data.toString());
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'default_channel_id', 'default_channel_id', 'Default Channel for notifications.',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(0, 'get title from fcm message', 'get message body from fcm message', platformChannelSpecifics);
  }
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String token = await FirebaseMessaging.instance.getToken();
  print(token);//save this token needed to send messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if(message.data!=null)
    {
      print(message.data.toString());
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationSettings); // Special permission for ios is needed please add if required
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'default_channel_id', 'default_channel_id', 'Default Channel for notifications.',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false
      );
      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
      flutterLocalNotificationsPlugin.show(0, 'get title from fcm message', 'get message body from fcm message', platformChannelSpecifics);
    }
  });
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider(create: (context) => context.read<AuthService>().user),
      ],
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }

  // Widget buildLoading() => Center(child: CircularProgressIndicator());
  }



