import 'package:flutter/material.dart';
import 'package:mts/main.dart';
import 'package:mts/main_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'home_screen.dart';
import 'package:mts/constant.dart';

class ListOrder extends StatefulWidget {
  ListOrder({Key key}) : super(key: key);
  static const routeName = '/list_order';

  @override
  _PayrollScreenState createState() => _PayrollScreenState();
}

final warn = "images/warning.png";
final error = "images/icon_error.png";
final success = "images/icon_success.png";
bool progress = false;
bool loading = false;
int index = 0;

class _PayrollScreenState extends State<ListOrder> {
  final double _borderRadius = 24;
  List<dynamic> list = new List();
  
  ScrollController _controller =
      new ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  _notif1(String dekripsi, String gambar, String keluar, Color warna) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
              height: 290,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      gambar,
                      width: 120,
                      height: 120,
                    ),
                    Text(
                      dekripsi,
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 100.0,
                          child: RaisedButton(
                            onPressed: () {
                              keluar == "keluar"
                                  ? Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                      (Route<dynamic> route) => false)
                                  : Navigator.pop(context);
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: warna,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    setState(() {
      progress = false;
    });
  }

  @override
  void initState() {
    super.initState();
    index = 0;
    getdata();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        index = index + 10;
        getdata();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  getdata() async {
    setState(() {
      loading = true;
    });
    try {
      var datahistory;
      var url = ip + "/listorder?drv_id=" +drv_id +"&index=" +
          index.toString();
      final response = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: "bearer $token"});
      if (response.statusCode == 400) {
        _notif1("Sesi Anda telah berakhir. \n Silakan login kembali", error,
            "keluar", Colors.redAccent);
      } else if (response.statusCode == 500) {
        _notif1("Internal Error silahan hubungi Administrator", error, "keluar",
            Colors.redAccent);
      } else if (response.statusCode == 200) {
        datahistory = json.decode(response.body);
        print(url);
        if (datahistory[0]["sched_id"] != null) {
          list.addAll(json.decode(response.body));
          if (datahistory[0]["status"] == "Token is Expired") {
            _notif1("Sesi Anda telah berakhir. \n Silakan login kembali", error,
                "keluar", Colors.redAccent);
          }
        }
      }
      setState(() {
        loading = false;
      });
    } catch (exception) {
      setState(() {
        loading = false;
      });
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          drawer: MainDrawer(),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "List Order",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            // leading: new IconButton(
            //   icon: new Icon(Icons.arrow_back, color: Colors.black),
            //   onPressed: () => Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => new MainScreen()),
            //     ModalRoute.withName('/'),
            //   ),
            // ),
          ),
          body: Stack(
            children: <Widget>[
              Container(
                child: ListView.builder(
                  controller: _controller,
                  shrinkWrap: true,
                  itemCount: list.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int i) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(_borderRadius),
                                gradient: LinearGradient(
                                    colors: [
                                      item[0].startColor,
                                      item[0].endColor
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                boxShadow: [
                                  BoxShadow(
                                    color: item[0].endColor,
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: new GestureDetector(
                                onTap: () => {},
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      top: 0,
                                      child: CustomPaint(
                                        size: Size(100, 150),
                                        painter: CustomCardShapePainter(
                                            _borderRadius,
                                            item[0].startColor,
                                            item[0].endColor),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Image.asset(
                                              'assets/images/list.png',
                                              height: 54,
                                              width: 34,
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  list[i]["sched_id"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Avenir',
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  list[i]["depo"].toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                      fontFamily: 'Avenir',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  list[i]["cust_address"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                      fontFamily: 'Avenir',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  list[i]["pickup_name"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                      fontFamily: 'Avenir',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  list[i]["pickup_contact"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                      fontFamily: 'Avenir',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  list[i]["pickup_address"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                      fontFamily: 'Avenir',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  list[i]["dest_contact"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                      fontFamily: 'Avenir',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  list[i]["dest_address"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                      fontFamily: 'Avenir',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  list[i]["cont_no"].toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                      fontFamily: 'Avenir',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  list[i]["seal_no"].toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                      fontFamily: 'Avenir',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 0,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  list[i]["amount"].toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Avenir',
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: loading ? CircularProgressIndicator() : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

var item = [
  PlaceInfo(Color(0xff42E695), Color(0xff3BB2B8)),
];

class PlaceInfo {
  final Color startColor;
  final Color endColor;

  PlaceInfo(this.startColor, this.endColor);
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
