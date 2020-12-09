import 'dart:convert';
import 'dart:io';

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
  
  fetchUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.get(url, headers: {
      'Accept': 'application/json'
    });
    
    if(response.statusCode == 200) 
    {
      var items = jsonDecode(response.body);
      print('response body '+items);
      setState(() {
        users = items;
      });
    } else {
      setState(() {
        users = [];
      });
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
     List items = [
       "1","2"
     ];
     print(items);
     return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return getCard(index);
      }
    );
  }

  Widget getCard(index) {
    var fullName = index['data']['sched_id'];
    print(fullName);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Row(
            children: <Widget>[
              Column(children: <Widget>[
                Text("AAA"),
                Text("BBBB"),
                Text("CCCC"),
              ],)
            ],
          ),
        ),
      ),
    );
  }
}
