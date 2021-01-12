import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mts/constant.dart';
// import 'package:mts/main_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class ReceiveOrder extends StatefulWidget {
  static const routeName = '/receive_order';
  @override
  _ReceiveOrderState createState() => _ReceiveOrderState();
}

final warn = "assets/images/warning.png";
final error = "assets/images/icon_error.png";
final success = "assets/images/icon_success.png";

class _ReceiveOrderState extends State<ReceiveOrder> {
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

  List users = [];
  bool isLoading = true;
  Position _currentPosition;
  int data;

  @override
  void initState() {
    super.initState();
    // _notif1("welcome", success);
    _getCurrentLocation().then((value) {
      this.fetchUser().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }
  /*
  fetchUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String vUsername = pref.getString('userName');

    final response = await http.post(ip+'/receivejob', body: {
      'empl_id':  vUsername 
    }, headers: {
      'Accept': 'application/json'
    });
    
    if(response.statusCode == 200) 
    {
      Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        users = data['data'];
      });
    } else {
      setState(() {
        users = [];
      });
    }   
  }
  */

  fetchUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String vUsername = pref.getString('userName');

    var response = await http.get(ip + '/receivejob?empl_id=' + vUsername);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body)['data'];
      print(items);
      setState(() {
        users = items;
      });
    } else {
      setState(() {
        users = [];
      });
    }
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

  void _btnreceivejob(String vSchedId, int vLine, String vSIID) async {
    String vUsername = '';
    setState(() {
      isLoading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    vUsername = pref.getString('userName');
    var response = await http.post(ip + '/btnreceivejob', body: {
      'sched_id': vSchedId,
      'line': vLine.toString(),
      'si_id': vSIID,
      'username': vUsername,
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
    });

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      print(items);
      _notif1("Order berhasil diterima", success);
    }
    this.fetchUser().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _btnrefusejob(String vSchedId, int vLine, String vSIID) async {
    String vUsername = '';
    setState(() {
      isLoading = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    vUsername = pref.getString('userName');
    var response = await http.post(ip + '/btnrefusejob', body: {
      'sched_id': vSchedId,
      'line': vLine.toString(),
      'si_id': vSIID,
      'username': vUsername,
      // "latitude": _currentPosition.latitude.toString(),
      // "longitude": _currentPosition.longitude.toString(),
    });

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      print(items);
      _notif1("Order berhasil ditolak", error);
    }
    this.fetchUser().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }
  /*
  Future fetchUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final queryParameters = {
      'empl_id': pref.getString('userName')
    };

    final uri = Uri.http(ip, '/receivejob', queryParameters);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
    /*
    final response = await http.get(ip + '/userprofile',
      headers: {'Authorization': 'bearer ' + pref.getString('token')});
    */
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      print('dataa' );
    } else {
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          'Receive Order',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      // drawer: MainDrawer(),
      body: Stack(children: [
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
            : getBody(),
      ]),
    );
  }

  Widget getBody() {
    //List items = ["1","2"];

    return users.length > 0
        ? ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return getCard(users[index]);
            })
        : Center(
            child: Text("No Data Available..."),
          );
  }

  Widget getCard(index) {
    int vLine = 0;

    var vSchedid = index['sched_id'].toString();
    vLine = index['line'];
    var vSIID = index['si_id'].toString();
    var vBussUnit = index['buss_unit'].toString();
    var vDepo = index['depo'].toString();
    var vCustName = index['cust_name'].toString();
    var vCustAddress = index['cust_address'].toString();
    var vCustPhone = index['cust_phone1'].toString();
    var vCustHandphone = index['cust_handphone1'].toString();
    var vCustContact = index['cust_pic'].toString();

    var vPickupName = index['pickup_name'].toString();
    var vPickupContact = index['pickup_contact'].toString();
    var vPickupAddress = index['pickup_address'].toString();
    var vDestName = index['dest_name'].toString();
    var vDestContact = index['dest_contact'].toString();
    var vDestAddress = index['dest_address'].toString();

    var vContId = index['cont_id'].toString();
    var vContNo = index['cont_no'].toString();
    var vPadLock = index['padlock'].toString();
    var vSealNo = index['seal_no'].toString();
    var vDriverName = index['drv_name'].toString();
    var vPlatNo = index['vhc_plat_no'].toString();

    //print(vSchedid);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Schedule : ' + vSchedid),
              subtitle: Text('SI No. ' + vSIID + ' - ' + vBussUnit),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "DEPO: " + vDepo,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "CUSTOMER: " + vCustName,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "ADDRESS: " + vCustAddress,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "TELP: " + vCustPhone,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "HANDPHONE: " + vCustHandphone,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "KONTAK: " + vCustContact,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                          "--------------------------------------------------"),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "MUAT: " + vPickupName,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "KONTAK: " + vPickupContact,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "ADDRESS: " + vPickupAddress,
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                          "--------------------------------------------------"),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "BONGKAR: " + vDestName,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "KONTAK: " + vDestContact,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "ADDRESS: " + vDestAddress,
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                          "--------------------------------------------------"),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "CONTAINER: " + vContId + ", NO CONT: " + vContNo,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "GEMBOK: " + vPadLock + ', SEAL NO: ' + vSealNo,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "SOPIR: " + vDriverName,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "MOBIL: " + vPlatNo,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonTheme(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        minWidth: 20,
                        height: 40,
                        child: RaisedButton(
                          onPressed: () {
                            this._btnreceivejob(vSchedid, vLine, vSIID);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                'TERIMA',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ButtonTheme(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        minWidth: 30,
                        height: 40,
                        child: RaisedButton(
                          color: Colors.red,
                          onPressed: () {
                            this._btnrefusejob(vSchedid, vLine, vSIID);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                'TOLAK',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
