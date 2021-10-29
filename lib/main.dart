import 'package:flutter/material.dart';
import 'package:memo_noe/authentification/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget with WidgetsBindingObserver{

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memo',
      debugShowCheckedModeBanner: false,
      //theme: widget.themeProvider.themeData(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
