import 'package:flutter/material.dart';
import 'package:mts/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

String token = '';
String username = '';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Trucking System"),
      ),
      drawer: MainDrawer(),
      body: Container(),
    );
  }
}

loaddata() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  token = pref.getString('token');
  username = pref.getString('userName');
}
