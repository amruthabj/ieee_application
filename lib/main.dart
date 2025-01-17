import 'package:flutter/material.dart';
import 'package:ieee_application/createEventScreen.dart';
import 'package:ieee_application/attendence.dart';
import 'authentication/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
