import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {

  final String username;
  HomeScreen(this.username);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation:5,
        title: new Text('Home Screen'),
      ),
      body: Center(
        child:  new Text('Welcome' + widget.username , style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
      )
    );
  }
}
