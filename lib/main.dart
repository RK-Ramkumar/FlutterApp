import 'package:flutter/material.dart';
import 'dart:async';
import 'package:diya/screens/homeComponent.dart';
import 'package:diya/screens/operationsComponent.dart';
import 'package:diya/restIntegration/restController.dart';

void main() =>  runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Yard',
      theme: ThemeData(
         primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => HomeScreen()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child:new Image.asset('assets/images/flutter.png'),
    );
  }
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
      appBar: AppBar(
          leading: new Image.asset('assets/images/flutter.png'),
          title:Text("Digi Yard"),
        bottom: const TabBar(
          isScrollable: true,
          tabs: [
            Tab(text: 'Welcome'),
            Tab(text: 'Lets Talk'),
            Tab(text: 'NewsFeed'),
           ],
        )),

      body: SafeArea(
        bottom: false,
        child: TabBarView(
          children: [
            AniApp(),
            SpeechScreen(),
            RestController(),

          ],
        ),
      )

    ));
  }
}