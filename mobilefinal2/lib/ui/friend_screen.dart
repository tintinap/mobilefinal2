import 'package:flutter/material.dart';


class FriendScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FriendScreenState();
  }

}


class FriendScreenState extends State<FriendScreen> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          children: <Widget>[

          ]
        )
      ),
    );
  }
}