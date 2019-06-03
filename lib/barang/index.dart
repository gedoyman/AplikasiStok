import 'package:flutter/material.dart';

import './cari.dart';

class Barang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Master Barang"),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: Icon(
                Icons.search,
                color: Colors.red,
              ),
              title: Text('Cari'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cari()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.add, color: Colors.green),
              title: Text('Tambah'),
            ),
          ),
        ],
      ),
    );
  }
}
