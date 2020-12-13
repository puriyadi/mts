// Design lama

// import 'package:flutter/material.dart';
// import 'package:mts/main_drawer.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// String token = '';
// String username = '';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Menu Trucking System"),
//       ),
//       drawer: MainDrawer(),
//       body: Container(),
//     );
//   }
// }

// loaddata() async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   token = pref.getString('token');
//   username = pref.getString('userName');
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mts/controller.dart';
import 'package:get/get.dart';
import 'components/dashboardheader.dart';
import 'components/dashboardmenu.dart';
import 'components/papanpengumuman.dart';

String token = '';

class HomeScreen extends StatelessWidget {
  final Controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.blue),
      child: Scaffold(
        body: SafeArea(
            child: Stack(
          children: [
            GetBuilder<Controller>(
              builder: (controller) => Positioned(
                top: controller.headerHeight,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.blue,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ),
            SingleChildScrollView(
              controller: controller.scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardHeader(),
                  PapanPengumuman(),
                  DashboardMenu(),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: double.infinity,
                    height: 30,
                    // color: Colors.grey.shade200,
                    child: Center(
                      child: Text("Copyright 2020"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
