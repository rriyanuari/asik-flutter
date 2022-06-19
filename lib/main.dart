import 'package:asik/screens/absensi_page.dart';
import 'package:asik/screens/dahsboard_page.dart';
import 'package:asik/screens/login_page.dart';
import 'package:asik/screens/splash_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ASIK - Aplikasi Sistem Kepegawaian',
        debugShowCheckedModeBanner: false,
        home: SplashPage());
  }
}
