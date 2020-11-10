import 'package:flutter/material.dart';
import 'package:todo_app/todoui.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "TO DO",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        accentColor: Colors.teal,
      ),
      home: ToDoUI(),
    );
  }
} 