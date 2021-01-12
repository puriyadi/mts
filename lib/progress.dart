import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constant.dart';
import 'controller.dart';

class OnDelivery extends StatefulWidget {
  OnDelivery({Key key}) : super(key: key);
  static const routeName = '/OnDelivery';

  @override
  _OnDeliveryScreenState createState() => _OnDeliveryScreenState();
}

final warn = "assets/images/warning.png";
final error = "assets/images/icon_error.png";
final success = "assets/images/icon_success.png";
String vUsername = '';
String vLine = "";
String vSIID = "";
String vSchedId = "";
String stat = "";
String nexstat = "";
String nexket = "";
int path = 0;
var items;
Position _currentPosition;
bool isLoading = false;

class _OnDeliveryScreenState extends State<OnDelivery> {
  _notif1(String dekripsi, String gambar) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            //backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)), //this right here
            child: Container(
              height: 265,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      gambar,
                      width: 140,
                      height: 140,
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
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 100.0,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: const Color(0xFF1BC0C5),
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
  }

  @override
  void initState() {
    super.initState();
    //_getCurrentLocation().then((value) {
    //_getCurrentLocation();
    getData();
    //});
    isLoading = true;
  }

  getData() async {
    var response = await http.get(ip + '/jobprogress?drv_id=' + drvId);
    if (response.statusCode == 200) {
      // print(response.body.length);
      // print(response.body);
      if (response.body.length > 2) {
        items = json.decode(response.body);
        setState(() {
          vLine = items[0]["line"].toString();
          vSIID = items[0]["si_id"].toString();
          vSchedId = items[0]["sched_id"].toString();
          stat = items[0]["status"];
          if (stat == "RJ") {
            nexstat = "OG";
            nexket = "OutGarasi";
            path = 1;
          } else if (stat == "OG") {
            nexstat = "AD";
            nexket = "ArriveDepo";
            path = 2;
          } else if (stat == "AD") {
            nexstat = "OD";
            nexket = "OutDepo";
            path = 3;
          } else if (stat == "OD") {
            nexstat = "AP";
            nexket = "ArrivePickup";
            path = 4;
          } else if (stat == "AP") {
            nexstat = "LP";
            nexket = "LoadPickup";
            path = 5;
          } else if (stat == "LP") {
            nexstat = "OP";
            nexket = "OutPickup";
            path = 6;
          } else if (stat == "OP") {
            nexstat = "AU";
            nexket = "ArriveUnload";
            path = 7;
          } else if (stat == "AU") {
            nexstat = "UL";
            nexket = "Unload";
            path = 8;
          } else if (stat == "UL") {
            nexstat = "OU";
            nexket = "OutUnload";
            path = 9;
          } else if (stat == "OU") {
            nexstat = "CL";
            nexket = "Close";
            path = 10;
          }
        });
      } else {
        items = null;
      }
      //print(items);
    }
    isLoading = false;
  }

  _getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    setState(() {
      _currentPosition = position;
    });
    print(_currentPosition);
    return _currentPosition;
  }

  nextStep(String status, String ket) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    vUsername = pref.getString('userName');
    var response = await http.post(ip + '/btnupdatetrack', body: {
      'sched_id': vSchedId,
      'line': vLine.toString(),
      'si_id': vSIID,
      'username': vUsername,
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
      "status": status,
      "fieldtable": ket,
    });
    if (response.statusCode == 200) {
      _notif1("Data Tersimpan", success);
    } else {
      _notif1("Terjadi kesalahan, Hubungi Administrator", error);
    }
  }

  runStep() {
    setState(() {
      isLoading = true;
    });
    _getCurrentLocation().then((value) {
      nextStep(nexstat, nexket).then((value) {
        getData().then((value) {
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Progress",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: [
            items != null
                ? Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        constraints: BoxConstraints(
                          maxHeight: 67,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.77,
                              isFirst: true,
                              indicatorStyle: IndicatorStyle(
                                height: 15,
                                color: path > 1 ? Colors.green : Colors.grey,
                                iconStyle: IconStyle(
                                    color:
                                        path > 1 ? Colors.white : Colors.grey,
                                    iconData: Icons.check,
                                    fontSize: 13),
                              ),
                              afterLineStyle: LineStyle(
                                  color: path > 1 ? Colors.green : Colors.grey),
                              startChild: Container(
                                width: MediaQuery.of(context).size.width / 10.3,
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    path == 2
                                        ? Image.asset(
                                            "assets/images/delivery.png",
                                          )
                                        : Image.asset("assets/images/bg.png"),
                                  ],
                                ),
                              ),
                              endChild: Container(
                                color: Colors.transparent,
                              ),
                            ),
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.77,
                              indicatorStyle: IndicatorStyle(
                                height: 15,
                                color: path > 2 ? Colors.green : Colors.grey,
                                iconStyle: IconStyle(
                                    color:
                                        path > 2 ? Colors.white : Colors.grey,
                                    iconData: Icons.check,
                                    fontSize: 13),
                              ),
                              beforeLineStyle: LineStyle(
                                  color: path > 2 ? Colors.green : Colors.grey),
                              afterLineStyle: LineStyle(
                                  color: path > 2 ? Colors.green : Colors.grey),
                              startChild: Container(
                                width: MediaQuery.of(context).size.width / 10.3,
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    path == 3
                                        ? Image.asset(
                                            "assets/images/delivery.png",
                                          )
                                        : Image.asset("assets/images/bg.png"),
                                  ],
                                ),
                              ),
                              endChild: Container(
                                color: Colors.transparent,
                              ),
                            ),
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.77,
                              indicatorStyle: IndicatorStyle(
                                height: 15,
                                color: path > 3 ? Colors.green : Colors.grey,
                                iconStyle: IconStyle(
                                    color:
                                        path > 3 ? Colors.white : Colors.grey,
                                    iconData: Icons.check,
                                    fontSize: 13),
                              ),
                              beforeLineStyle: LineStyle(
                                  color: path > 3 ? Colors.green : Colors.grey),
                              afterLineStyle: LineStyle(
                                  color: path > 3 ? Colors.green : Colors.grey),
                              startChild: Container(
                                width: MediaQuery.of(context).size.width / 10.3,
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    path == 4
                                        ? Image.asset(
                                            "assets/images/delivery.png",
                                          )
                                        : Image.asset("assets/images/bg.png"),
                                  ],
                                ),
                              ),
                              endChild: Container(
                                color: Colors.transparent,
                              ),
                            ),
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.77,
                              indicatorStyle: IndicatorStyle(
                                height: 15,
                                color: path > 4 ? Colors.green : Colors.grey,
                                iconStyle: IconStyle(
                                    color:
                                        path > 4 ? Colors.white : Colors.grey,
                                    iconData: Icons.check,
                                    fontSize: 13),
                              ),
                              beforeLineStyle: LineStyle(
                                  color: path > 4 ? Colors.green : Colors.grey),
                              afterLineStyle: LineStyle(
                                  color: path > 4 ? Colors.green : Colors.grey),
                              startChild: Container(
                                width: MediaQuery.of(context).size.width / 10.3,
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    path == 5
                                        ? Image.asset(
                                            "assets/images/delivery.png",
                                          )
                                        : Image.asset("assets/images/bg.png"),
                                  ],
                                ),
                              ),
                              endChild: Container(
                                color: Colors.transparent,
                              ),
                            ),
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.77,
                              indicatorStyle: IndicatorStyle(
                                height: 15,
                                color: path > 5 ? Colors.green : Colors.grey,
                                iconStyle: IconStyle(
                                    color:
                                        path > 5 ? Colors.white : Colors.grey,
                                    iconData: Icons.check,
                                    fontSize: 13),
                              ),
                              beforeLineStyle: LineStyle(
                                  color: path > 5 ? Colors.green : Colors.grey),
                              afterLineStyle: LineStyle(
                                  color: path > 5 ? Colors.green : Colors.grey),
                              startChild: Container(
                                width: MediaQuery.of(context).size.width / 10.3,
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    path == 6
                                        ? Image.asset(
                                            "assets/images/delivery.png",
                                          )
                                        : Image.asset("assets/images/bg.png"),
                                  ],
                                ),
                              ),
                              endChild: Container(
                                color: Colors.transparent,
                              ),
                            ),
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.77,
                              indicatorStyle: IndicatorStyle(
                                height: 15,
                                color: path > 6 ? Colors.green : Colors.grey,
                                iconStyle: IconStyle(
                                    color:
                                        path > 6 ? Colors.white : Colors.grey,
                                    iconData: Icons.check,
                                    fontSize: 13),
                              ),
                              beforeLineStyle: LineStyle(
                                  color: path > 6 ? Colors.green : Colors.grey),
                              afterLineStyle: LineStyle(
                                  color: path > 6 ? Colors.green : Colors.grey),
                              startChild: Container(
                                width: MediaQuery.of(context).size.width / 10.3,
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    path == 7
                                        ? Image.asset(
                                            "assets/images/delivery.png",
                                          )
                                        : Image.asset("assets/images/bg.png"),
                                  ],
                                ),
                              ),
                              endChild: Container(
                                color: Colors.transparent,
                              ),
                            ),
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.77,
                              indicatorStyle: IndicatorStyle(
                                height: 15,
                                color: path > 7 ? Colors.green : Colors.grey,
                                iconStyle: IconStyle(
                                    color:
                                        path > 7 ? Colors.white : Colors.grey,
                                    iconData: Icons.check,
                                    fontSize: 13),
                              ),
                              beforeLineStyle: LineStyle(
                                  color: path > 7 ? Colors.green : Colors.grey),
                              afterLineStyle: LineStyle(
                                  color: path > 7 ? Colors.green : Colors.grey),
                              startChild: Container(
                                width: MediaQuery.of(context).size.width / 10.3,
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    path == 8
                                        ? Image.asset(
                                            "assets/images/delivery.png",
                                          )
                                        : Image.asset("assets/images/bg.png"),
                                  ],
                                ),
                              ),
                              endChild: Container(
                                color: Colors.transparent,
                              ),
                            ),
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.77,
                              indicatorStyle: IndicatorStyle(
                                height: 15,
                                color: path > 8 ? Colors.green : Colors.grey,
                                iconStyle: IconStyle(
                                    color:
                                        path > 8 ? Colors.white : Colors.grey,
                                    iconData: Icons.check,
                                    fontSize: 13),
                              ),
                              beforeLineStyle: LineStyle(
                                  color: path > 8 ? Colors.green : Colors.grey),
                              afterLineStyle: LineStyle(
                                  color: path > 8 ? Colors.green : Colors.grey),
                              startChild: Container(
                                width: MediaQuery.of(context).size.width / 10.3,
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    path == 9
                                        ? Image.asset(
                                            "assets/images/delivery.png",
                                          )
                                        : Image.asset("assets/images/bg.png"),
                                  ],
                                ),
                              ),
                              endChild: Container(
                                color: Colors.transparent,
                              ),
                            ),
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.77,
                              indicatorStyle: IndicatorStyle(
                                height: 15,
                                color: path > 9 ? Colors.green : Colors.grey,
                                iconStyle: IconStyle(
                                    color:
                                        path > 9 ? Colors.white : Colors.grey,
                                    iconData: Icons.check,
                                    fontSize: 13),
                              ),
                              beforeLineStyle: LineStyle(
                                  color: path > 9 ? Colors.green : Colors.grey),
                              afterLineStyle: LineStyle(
                                  color: path > 9 ? Colors.green : Colors.grey),
                              startChild: Container(
                                width: MediaQuery.of(context).size.width / 10.3,
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    path == 10
                                        ? Image.asset(
                                            "assets/images/delivery.png",
                                          )
                                        : Image.asset("assets/images/bg.png"),
                                  ],
                                ),
                              ),
                              endChild: Container(
                                color: Colors.transparent,
                              ),
                            ),
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.77,
                              isLast: true,
                              indicatorStyle: IndicatorStyle(
                                height: 15,
                                color: path > 10 ? Colors.green : Colors.grey,
                                iconStyle: IconStyle(
                                    color:
                                        path > 10 ? Colors.white : Colors.grey,
                                    iconData: Icons.check,
                                    fontSize: 13),
                              ),
                              beforeLineStyle: LineStyle(
                                  color:
                                      path > 10 ? Colors.green : Colors.grey),
                              afterLineStyle: LineStyle(
                                  color:
                                      path > 10 ? Colors.green : Colors.grey),
                              startChild: Container(
                                width: MediaQuery.of(context).size.width / 8,
                                color: Colors.transparent,
                              ),
                              endChild: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 55,
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 40.0),
                                  child: Text(
                                    "STEP " + (path - 1).toString(),
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 40.0),
                                  child: Text(
                                    nexket,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            TimelineTile(
                              // isFirst: true,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.1,
                              indicatorStyle: IndicatorStyle(
                                color: Colors.green,
                                width: 40,
                                height: 60,
                                padding: const EdgeInsets.all(3),
                                indicator: Image.asset(
                                  'assets/images/cargo.png',
                                ),
                              ),
                              beforeLineStyle: LineStyle(color: Colors.green),
                              afterLineStyle: LineStyle(color: Colors.green),
                              endChild: Container(
                                // color: Colors.black12,
                                constraints: BoxConstraints(minHeight: 200),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Pickup",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            items[0]['pickup_name'],
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            items[0]['pickup_address'],
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.teal,
                                              ),
                                            ),
                                            Container(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 110,
                                              child: Text(
                                                "Contact Person",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              child: Icon(
                                                Icons.phone,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                            ),
                                            Container(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 110,
                                              child: Text(
                                                "Contact Number",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 130,
                                          child: Text(
                                            items[0]["pickup_contact"],
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 20,
                                        ),
                                        Container(
                                          width: 130,
                                          child: Text(
                                            items[0]["pickup_contact_telp"],
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TimelineTile(
                              isLast: true,
                              alignment: TimelineAlign.manual,
                              lineXY: 0.1,
                              indicatorStyle: IndicatorStyle(
                                color: Colors.green,
                                width: 40,
                                height: 60,
                                padding: const EdgeInsets.all(3),
                                indicator: Image.asset(
                                  'assets/images/received.png',
                                ),
                              ),
                              endChild: Container(
                                color: Colors.transparent,
                                constraints: BoxConstraints(minHeight: 200),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Tujuan",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          items[0]["dest_name"],
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            items[0]['dest_address'],
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.teal,
                                              ),
                                            ),
                                            Container(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 110,
                                              child: Text(
                                                "Contact Person",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              child: Icon(
                                                Icons.phone,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                            ),
                                            Container(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 110,
                                              child: Text(
                                                "Contact Number",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 130,
                                          child: Text(
                                            items[0]["pickup_contact"],
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 20,
                                        ),
                                        Container(
                                          width: 130,
                                          child: Text(
                                            items[0]["dest_contact_telp"],
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              beforeLineStyle: LineStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: RaisedButton(
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
                              Text(
                                "NEXT",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Icon(
                                Icons.next_plan,
                                size: 18,
                              ),
                            ],
                          ),
                          onPressed: () {
                            runStep();
                          },
                        ),
                      ),
                    ],
                  )
                : Container(child: Center(child: Text("Data Not Available"))),
            isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
