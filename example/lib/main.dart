import 'package:flutter/material.dart';
import 'package:image_comparator/image_comparator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ImageComparatorView(

          image1: Image.asset("assets/images/before.jpg", fit: BoxFit.cover,),
          image2: Image.asset("assets/images/after.png", fit: BoxFit.cover,),
          handleLineColor: Colors.yellow,
          thumbOffset: 0.5,
          thumb: Icon(
            Icons.ac_unit_outlined,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
