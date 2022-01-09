import 'package:flutter/material.dart';
import 'package:objectbox/internal.dart';
import 'package:objectbox_database_demo/pages/Homepage.dart';


void main(){
  WidgetsFlutterBinding.ensureInitialized();

  //boxes = await Boxes.create();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Homepage(),
    );
  }
}
