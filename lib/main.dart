import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mts/constant.dart';
import 'package:mts/home_screen.dart';
import 'package:progress_dialog/progress_dialog.dart'; 
import 'package:http/http.dart' as http; 
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

//void main() => runApp(MyApp());
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //dynamic token = FlutterSession().get('token');
  runApp(
    MaterialApp(
      title: 'MTS',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
    )
  );
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController txtUsername = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();
  
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

  @override
  void initState() {
    super.initState();
    _cekLogin();
  }

  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getBool('isLogin')) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (
            BuildContext context
          ) => HomeScreen()
        )
      );
    } 
  }
  
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title : Text("Login Trucking System"),
      ),
      body: Column(
        mainAxisAlignment : MainAxisAlignment.center, 
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: txtUsername,
                  decoration: InputDecoration(hintText: 'Username'),
                ),
                TextField(
                  obscureText: true,
                  controller: txtPassword,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
                ButtonTheme(
                  minWidth: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      this._doLogin();
                    }, 
                    child: Text('Login'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _doLogin() async {
    ProgressDialog pr;
    if(txtUsername.text.isEmpty || txtPassword.text.isEmpty) {
      _alertDialog('Username / Password Harus Diisi');
      return;
    } 

    pr = new ProgressDialog(context);
    pr.style(message: 'Loading...');
    pr.show();
    
    final response = await http.post(ip+'/login', body: {
      'username':  txtUsername.text,
      'password': txtPassword.text
    }, headers: {
      'Accept': 'application/json'
    });
    
    
    
    if(response.statusCode == 200) {
      print("Login OK");
      Map<String, dynamic> data = jsonDecode(response.body);

      //await FlutterSession().set('username', txtUsername.text);
      //await FlutterSession().set('token', data['data']['token']);
      SharedPreferences pref =  await SharedPreferences.getInstance();
      pref.setBool('isLogin', true);
      pref.setString('userName', txtUsername.text);
      pref.setString('token', data['data']['token']);

      Future.delayed(Duration(seconds: 3)).then((value) {
        pr.hide().whenComplete(() {    
          Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (
              BuildContext context
            ) => HomeScreen()
          )
          );
        });
      });
    } else {
      SharedPreferences pref =  await SharedPreferences.getInstance();
      pref.setBool('isLogin', false);
      pref.setString('username', '');
      pref.setString('token','');

      _alertDialog('Login Failed');
      Future.delayed(Duration(seconds: 3)).then((value) {
      pr.hide().whenComplete(() {
        Navigator.of(context);
      });
    });
    }    
  }  
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}