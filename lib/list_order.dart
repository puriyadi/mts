import 'package:flutter/material.dart';
import 'package:mts/main_drawer.dart';

class ListOrder extends StatelessWidget {
  static const routeName = '/list_order';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receive Order'),
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Text(
          'List Order',
          style: TextStyle(fontSize: 20)
        ) ,
      ),
    );
  }
}