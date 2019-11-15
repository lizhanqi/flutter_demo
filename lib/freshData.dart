import 'dart:async';

import 'package:flutter/material.dart';


class freshData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<freshData> {
  List<int> items = List.generate(16, (i) => i);

  Future<Null> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 5), () {
      print('refresh');
      setState(() {
        items.clear();
        items = List.generate(40, (i) => i);
        return null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refresh"),
      ),
      body: new RefreshIndicator(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("Index$index"),
            );
          },
        ),
        onRefresh: _handleRefresh,
      ),
    );
  }
}