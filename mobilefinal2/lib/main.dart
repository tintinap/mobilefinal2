import 'package:flutter/material.dart';

import 'ui/login_screen.dart';
import 'ui/register_screen.dart';
import 'ui/main_screen.dart';
import 'ui/profile_setup_screen.dart';
import 'ui/friend_screen.dart';

import 'globals.dart' as globals;

void main() async{
  await globals.up.open('user.db');
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(),
      initialRoute: "/",
      routes : {
        // "/" : (context) => FirstScreen(),
        "/" : (context) => Login(),
        "/register" : (context) => Register(),
        "/main" : (context) => MainScreen(),
        "/profile" : (context) => ProfileSetUpScreen(),
        "/friend" : (context) => FriendScreen(),
      }
    );
  }
}