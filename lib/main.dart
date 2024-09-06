import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/login_signup/LoginHandler.dart';
import 'pages/login_signup/Sign_up.dart';
import 'pages/admin/admin_homepage.dart';
import 'pages/staff/home_page.dart';
import 'pages/login_signup/log_in.dart';
import 'pages/admin/overview.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData(),
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
      routes: {
        'signup' : (context) => SignUpPage(),
        'login' : (context) => LoginPage(),
        'home' : (context) => HomePage(),
        'admin' : (context) => AdminHomePage(),
        'overview' : (context) => Overview(),
      },
    );
  }
}