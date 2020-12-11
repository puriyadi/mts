import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mts/constant.dart';
import 'package:mts/list_order.dart';
import 'package:mts/loginscreen.dart';
import 'package:mts/receive_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String vUsername = '';
  String vName = '';
  String vRole = '';

  void _alertDialog(String str) {
    if (str.isEmpty) return;
    AlertDialog alertDialog = new AlertDialog(
      content: new Text(
        str,
        style: new TextStyle(fontSize: 20.0),
      ),
      actions: <Widget>[
        new RaisedButton(
            color: Colors.blue,
            child: new Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );

    showDialog(context: context, child: alertDialog);
  }

  Future _logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isLogin', false);
    pref.setString('userName', '');
    Get.offAll(LoginScreen());
    // Navigator.of(context).push(
    //   new MaterialPageRoute(
    //     builder: (BuildContext context) => new LoginScreen(),
    //   ),
    // );
  }

  Future _cekUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('userName') != null) {
      final response = await http.get(ip + '/userprofile',
          headers: {'Authorization': 'bearer ' + pref.getString('token')});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          vUsername = data['data']['user']['username'];
          vName = data['data']['user']['name'];
          vRole = data['data']['user']['role'];
        });
      } else {
        pref.setBool('isLogin', false);
        pref.setString('userName', '');
        pref.setString('token', '');
        Get.offAll(LoginScreen());
        _alertDialog('Token Expired, Silahkan Login Ulang');
        // Navigator.of(context).push(
        //   new MaterialPageRoute(
        //     builder: (BuildContext context) => new LoginScreen(),
        //   ),
        // );
      }
    }
  }

  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool('isLogin').toString() == "false" ||
        pref.getBool('isLogin').toString() == "null") {
      Get.offAll(LoginScreen());
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => LoginScreen()),
      //     (Route<dynamic> route) => false);
      // Get.off(LoginScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    _cekLogin();
    _cekUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text(vName),
            accountEmail: new Text(vUsername),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: new AssetImage("assets/images/people_icon.jpg"),
            ),
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage("assets/images/yard.jpg"),
                  fit: BoxFit.cover),
            ),
            otherAccountsPictures: <Widget>[
              new ClipOval(
                child: Image.asset("assets/images/logo_perusahaan.png"),
              ),
            ],
          ),
          new ListTile(
            title: new Text("Receive Order"),
            trailing: new Icon(Icons.mail),
            onTap: () => Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) => new ReceiveOrder(),
              ),
            ),
          ),
          new ListTile(
            title: new Text("List Order"),
            trailing: new Icon(Icons.list),
            onTap: () => Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) => new ListOrder(),
              ),
            ),
          ),
          new ListTile(
            title: new Text("Logout"),
            trailing: new Icon(Icons.exit_to_app),
            onTap: () {
              _logout();
            },
          )
        ],
      ),
    );
  }
}
