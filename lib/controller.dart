import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:mts/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
import 'loginscreen.dart';

enum LoginStatus { signIn, notSignIn }
String drvId = '';

class Controller extends GetxController {
  ScrollController scrollController = new ScrollController();
  Color textButtonColorLogin = Colors.blue;
  double headerTextOpacity = 1;
  String username, password;
  double headerHeight = 0;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  bool secured = true;
  LoginStatus loginStatus = LoginStatus.notSignIn;
  @override
  void onInit() {
    splash();
    print(scrollController);
    scrollController.addListener(() {
      print(scrollController.offset);
      if (scrollController.offset >= 15 && scrollController.offset <= 60) {
        headerTextOpacity = .5;
      } else if (scrollController.offset >= 60) {
        headerTextOpacity = .1;
      } else {
        headerTextOpacity = 1;
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        headerHeight = -scrollController.offset / 2;
      } else {
        headerHeight = -scrollController.offset / 2;
      }
      print("headerHegt: " + headerHeight.toString());
      update();
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  splash() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Timer(Duration(seconds: 2), () {
      cekLogin();
    });
  }

  cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool('isLogin').toString() == "false" ||
        pref.getBool('isLogin').toString() == "null") {
      //print("state : Login");
      loginStatus = LoginStatus.signIn;
    } else {
      //print("state : notLogin");
      loginStatus = LoginStatus.notSignIn;
    }
    //print(loginStatus);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    switch (loginStatus) {
      case LoginStatus.notSignIn:
        return Get.off(LoginScreen());
        break;
      case LoginStatus.signIn:
        return Get.off(HomeScreen());
    }
  }

  secureText() {
    secured = !secured;
    print("secureText: " + (secured == true ? "On" : "Off"));
    update();
  }

  validateLogin() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      login();
      //print(username);
    }
  }

  login() async {
    Get.dialog(
      AlertDialog(
        content: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CupertinoActivityIndicator()),
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
    final url = ip + "/login";
    http.post(
      url,
      body: {'username': username, 'password': password},
      headers: {'Accept': 'application/json'},
    ).then((resp) {
      final response = jsonDecode(resp.body);
      print(response);
      if (resp.statusCode == 200) {
        Get.back();
        print("Sukses");
        bool isLogin = true;
        String userName = username;
        String token = response['data']['token'];
        drvId = response['user'][0]['drv_id'];
        savePrefs(isLogin, userName, token);
        Get.off(HomeScreen());
      } else {
        Get.back();
        Get.dialog(
          AlertDialog(
            titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            contentPadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Center(
                    child: Text(
                      "The username and password you entered did not match our records. Please double-check and try again.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.black.withOpacity(.1)),
                FlatButton(
                  highlightColor: Colors.transparent,
                  child: Text("Try Again"),
                  onPressed: () => Get.back(),
                )
              ],
            ),
          ),
        );
      }
    });
  }

  savePrefs(bool isLogin, String userName, String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isLogin', isLogin);
    pref.setString('userName', username);
    pref.setString('token', token);
  }
}
