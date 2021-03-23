import 'package:firebase_video_upload/post_video_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => PostVideoScreen())),
        child: Icon(Icons.add),
        tooltip: 'Create a post',
        elevation: 3,
      ),
    );
  }
}
