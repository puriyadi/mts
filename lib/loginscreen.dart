import 'package:flutter/material.dart';
import 'dart:io' as Io;
import 'package:mts/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'controller.dart';

//void main() => runApp(MyApp());
cekpermit() async {
  Map<Permission, PermissionStatus> status =
      await [Permission.location, Permission.phone].request();
  if (status[Permission.location] == PermissionStatus.denied ||
      status[Permission.phone] == PermissionStatus.denied) {
    Io.exit(0);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //dynamic token = FlutterSession().get('token');
  runApp(MaterialApp(
    title: 'MTS',
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    // routes: {
    //   '/': (_) => LoginScreen(),
    //   ReceiveOrder.routeName: (_) => ReceiveOrder(),
    //   ListOrder.routeName: (_) => ListOrder(),
    // },
    //home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController txtUsername = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();
//alert versilama
  // void _alertDialog(String str) {
  //   if (str.isEmpty) return;
  //   AlertDialog alertDialog = new AlertDialog(
  //     content: new Text(
  //       str,
  //       style: new TextStyle(fontSize: 20.0),
  //     ),
  //     actions: <Widget>[
  //       new RaisedButton(
  //           color: Colors.blue,
  //           child: new Text("OK"),
  //           onPressed: () {
  //             Navigator.pop(context);
  //           })
  //     ],
  //   );

  //   showDialog(context: context, child: alertDialog);
  // }

  @override
  void initState() {
    super.initState();
    cekpermit();
    _cekLogin();
  }

  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool('isLogin').toString() == "true") {
      Navigator.of(context).push(
          CupertinoPageRoute(builder: (BuildContext context) => HomeScreen()));
    }
  }

  final Controller controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 25),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 180,
                          width: 180,
                          child: Image.asset(
                            "assets/images/iconapps.png",
                            // isAntiAlias: true,
                            // filterQuality: FilterQuality.medium,
                            fit: BoxFit.contain,
                            // width: 330,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Trucking\nMobile\nApps",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.blue[900],
                            height: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextFormField(
                            onSaved: (newValue) =>
                                controller.username = newValue,
                            textInputAction: TextInputAction.next,
                            initialValue: controller.username,
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Must Filled";
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Username",
                              hintText: "Input Your Username Here",
                              suffixIcon: Icon(Icons.person_rounded),
                            ),
                          ),
                          GetBuilder<Controller>(
                              init: Controller(),
                              builder: (controller) {
                                return TextFormField(
                                  onSaved: (newValue) =>
                                      controller.password = newValue,
                                  // ignore: missing_return
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Must Filled";
                                    }
                                  },
                                  obscureText: controller.secured,
                                  decoration: InputDecoration(
                                      hintText: "Input Your Password Here",
                                      labelText: "Password",
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller.secured
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                        ),
                                        onPressed: () =>
                                            controller.secureText(),
                                      )),
                                );
                              }),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                child: GestureDetector(
                                  onTapUp: (p) {
                                    controller.textButtonColorLogin =
                                        Colors.blue;
                                    controller.update();
                                    print("Lupa kata sandi");
                                  },
                                  onTapDown: (p) {
                                    controller.textButtonColorLogin =
                                        Colors.red;
                                    controller.update();
                                  },
                                  child: GetBuilder<Controller>(
                                    builder: (controller) => Text(
                                      "Lupa kata sandi?",
                                      style: TextStyle(
                                        color: controller.textButtonColorLogin,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                              RaisedButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 35, vertical: 15),
                                color: Colors.blue,
                                textColor: Colors.white,
                                textTheme: ButtonTextTheme.primary,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.login,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "LOGIN",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () => controller.validateLogin(),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  //design lama
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       automaticallyImplyLeading: false,
  //       title: Text("Login Trucking System"),
  //     ),
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Container(
  //           padding: EdgeInsets.all(20),
  //           child: Column(
  //             children: <Widget>[
  //               TextField(
  //                 controller: txtUsername,
  //                 decoration: InputDecoration(hintText: 'Username'),
  //               ),
  //               TextField(
  //                 obscureText: true,
  //                 controller: txtPassword,
  //                 decoration: InputDecoration(hintText: 'Password'),
  //               ),
  //               ButtonTheme(
  //                 minWidth: double.infinity,
  //                 child: RaisedButton(
  //                   onPressed: () {
  //                     this._doLogin();
  //                   },
  //                   child: Text('Login'),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
//logic lama
  // Future _doLogin() async {
  //   ProgressDialog pr;
  //   if (txtUsername.text.isEmpty || txtPassword.text.isEmpty) {
  //     _alertDialog('Username / Password Harus Diisi');
  //     return;
  //   }

  //   pr = new ProgressDialog(context);
  //   pr.style(message: 'Loading...');
  //   pr.show();

  //   final response = await http.post(ip + '/login',
  //       body: {'username': txtUsername.text, 'password': txtPassword.text},
  //       headers: {'Accept': 'application/json'});

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> data = jsonDecode(response.body);

  //     //await FlutterSession().set('username', txtUsername.text);
  //     //await FlutterSession().set('token', data['data']['token']);
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     pref.setBool('isLogin', true);
  //     pref.setString('userName', txtUsername.text);
  //     pref.setString('token', data['data']['token']);

  //     Future.delayed(Duration(seconds: 3)).then((value) {
  //       pr.hide().whenComplete(() {
  //         Navigator.of(context).push(CupertinoPageRoute(
  //             builder: (BuildContext context) => HomeScreen()));
  //       });
  //     });
  //   } else {
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     pref.setBool('isLogin', false);
  //     pref.setString('username', '');
  //     pref.setString('token', '');

  //     _alertDialog('Login Failed');
  //     Future.delayed(Duration(seconds: 3)).then((value) {
  //       pr.hide().whenComplete(() {
  //         Navigator.of(context);
  //       });
  //     });
  //   }
  // }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
