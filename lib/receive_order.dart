import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mts/constant.dart';
import 'package:mts/main_drawer.dart';
import 'package:http/http.dart' as http;

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
    var url = ip+'/receivejob';
    var response = await http.get(url);

    if(response.statusCode == 200) {
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
    var fullName = index;
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
