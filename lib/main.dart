import 'package:flutter/material.dart';

import './barang/index.dart';

void main() {
  runApp(MaterialApp(
    title: "Aplikasi Stock",
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Center(child: new Text("Home")),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: Icon(
                Icons.album,
                color: Colors.red,
              ),
              title: Text('Master Barang'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Barang()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.fast_forward, color: Colors.green),
              title: Text('Invoice Masuk'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.fast_rewind, color: Colors.blue),
              title: Text('Invoice Keluar'),
            ),
          ),
        ],
      ),
    );
  }
}
