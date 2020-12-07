import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mts/constant.dart';
import 'package:mts/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String vUsername = '';
  String vName = '';
  String vRole = '';
  void _alertDialog(String str) {
    if(str.isEmpty) return;
    AlertDialog alertDialog = new AlertDialog(
      content: new Text(
        str, 
        style: new TextStyle(
          fontSize: 20.0
        ),
      ),
      actions: <Widget>[
        new RaisedButton(
          color: Colors.blue,
          child: new Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          }
        )
      ],
    );

    showDialog(
      context: context,
      child: alertDialog
    );
  }

  Future _logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isLogin', false);
    pref.setString('userName','');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new LoginScreen())
    );
  }

  Future _cekUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getString('userName') != null) {
      final response = await http.get(ip + '/userprofile', headers : {
        'Authorization' : 'bearer '+pref.getString('token')
      });

      if(response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          vUsername = data['data']['user']['username'];
          vName = data['data']['user']['name'];
          vRole = data['data']['user']['role'];
        });
      } else {
        _alertDialog('Token Expired, Silahkan Login Ulang');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => new LoginScreen())
        );
      }
    }
  }

  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getBool('isLogin') == false ) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => new LoginScreen())
      );
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
    return Scaffold(
      appBar: AppBar(
        title : Text("Menu Trucking System"),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(vName), 
              accountEmail: new Text(vUsername),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new AssetImage("assets/images/people_icon.jpg"),
              ),
              decoration: new BoxDecoration(
                image : new DecorationImage(image: new AssetImage("assets/images/yard.jpg"),
                fit: BoxFit.cover
                ),
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
              onTap: () {
                
              },
            ),
            new ListTile(
              title: new Text("List Order"),
              trailing: new Icon(Icons.list),
            ),
            new ListTile(
              title: new Text("Profile"),
              trailing: new Icon(Icons.people),
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
      ),
      body: Container(
        child: Column(
          children: <Widget>[
             
          ]
        )
      )
    );
  }
}