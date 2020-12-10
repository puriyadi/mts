import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Nunito'),
      home: SplashScreen(),
    );
  }
}
