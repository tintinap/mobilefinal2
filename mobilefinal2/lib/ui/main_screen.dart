import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }

}


class _MainScreenState extends State<MainScreen> {
  String name = '';

  getShareFile() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('Name');
    print('name = $name');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    getShareFile();
    return Scaffold(

      body: Center(
        child: Column(
          children: <Widget>[
            Text('Hello $name'),
            FloatingActionButton(
              // onPressed: 
            ),
            FloatingActionButton(
              // onPressed: 
            ),
            FloatingActionButton(
              // onPressed: 
            ),
          ]
        )
      ),
    );
  }
}