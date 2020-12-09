import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mts/constant.dart';
import 'package:mts/main_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReceiveOrder extends StatefulWidget {
  static const routeName = '/receive_order';
  @override
  _ReceiveOrderState createState() => _ReceiveOrderState();
}

class _ReceiveOrderState extends State<ReceiveOrder> {
  List users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.fetchUser();
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

  void fetchUser() async {
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

  void _btnreceivejob (String vSchedId, int vLine, String vSIID) async {
    String vUsername = '';
    SharedPreferences pref = await SharedPreferences.getInstance();
    vUsername = pref.getString('userName');
    var response = await http.post(ip + '/btnreceivejob', body: {
      'sched_id': vSchedId,
      'line': vLine,
      'si_id': vSIID,
      'username': vUsername,
    });

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      print(items);
    }  
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
        title: Text('Receive Order'),
      ),
      drawer: MainDrawer(),
      body: getBody(),
    );
  }

  Widget getBody() {
    //List items = ["1","2"];

    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return getCard(users[index]);
        });
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
              title: Text('Schedule : ' + vSchedid ),
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
                          "------------------------------------------------------------------"),
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
                          "------------------------------------------------------------------"),
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
                          "------------------------------------------------------------------"),
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
                  Row(
                    children: [
                      ButtonTheme(
                        minWidth: 20,
                        child: RaisedButton(
                          onPressed: () {
                            this._btnreceivejob(vSchedid, vLine, vSIID);
                          },
                          child: Text('TERIMA ORDER'),
                        ),
                      ),
                      SizedBox(width: 5),
                      ButtonTheme(
                        minWidth: 20,
                        child: RaisedButton(
                          color: Colors.red,
                          onPressed: () {
                            
                          },
                          child: Text('TOLAK ORDER'),
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
