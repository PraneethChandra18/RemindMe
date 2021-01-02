import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authenticate/authfunctions.dart';
import 'bridges/wrapper.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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



