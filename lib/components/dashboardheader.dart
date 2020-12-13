import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mts/controller.dart';
import 'package:get/get.dart';
import 'package:mts/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';

String vUsername = '';
String vName = '';
String vRole = '';

class DashboardHeader extends StatefulWidget {
  @override
  _DashboardHeaderState createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  final Controller controller = Get.find();
  @override
  void initState() {
    super.initState();

    _cekUser();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
      builder: (controller) => AnimatedDefaultTextStyle(
        duration: Duration(milliseconds: 200),
        curve: Curves.bounceInOut,
        style: TextStyle(
          color: Colors.white.withOpacity(controller.headerTextOpacity),
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat datang,",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      vName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(vUsername),
                    Text(vRole),
                  ],
                ),
                RaisedButton(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        size: 14,
                      ),
                      SizedBox(width: 5),
                      Text("Logout")
                    ],
                  ),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('isLogin', false);
                    controller.cekLogin();
                  },
                ),
              ],
            )),
      ),
    );
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
        // _alertDialog('Token Expired, Silahkan Login Ulang');
        // Navigator.of(context).push(
        //   new MaterialPageRoute(
        //     builder: (BuildContext context) => new LoginScreen(),
        //   ),
        // );
      }
    }
  }
}
