import 'package:custom_bottom_app_bar/custom_bottom_app_bar.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      bottomNavigationBar: CustomBottomAppBar(
        backColor: Colors.deepPurple[100],
        backgroundColor: Colors.white,
        buttonIcons: [
          Icons.menu,
          Icons.person_outline,
          Icons.add_circle_outline,
          Icons.comment,
        ],
      ),
      body: Container(
        color: Colors.deepPurple[100],
      ),
    );
  }
}
