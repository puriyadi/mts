import 'package:flutter/material.dart';
import 'package:mts/main_drawer.dart';

class ReceiveOrder extends StatefulWidget {
  static const routeName = '/receive_order';
  @override
  _ReceiveOrderState createState() => _ReceiveOrderState();
}

class _ReceiveOrderState extends State<ReceiveOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receive Order'),
      ),
      drawer: MainDrawer(),
      body: ListView.builder(
        itemBuilder: (context, index){
          return Text("index $index");
        }
      )
    );
   }
}
