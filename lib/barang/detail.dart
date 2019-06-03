import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../global.dart';

class Detail extends StatefulWidget {
  final String barang_id;
  final String barang_kategori_id;
  final String barang_nama;
  final String barang_stok;
  final String barang_user_nama;

  Detail({
    this.barang_id,
    this.barang_kategori_id,
    this.barang_nama,
    this.barang_stok,
    this.barang_user_nama,
  });

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _mySelection;
  String messageUpdate;

  //bool _saving = false;

  final String url = "${URL}/kategori?key=123";

  List data = List(); //edited line

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    Map<String, dynamic> resBody = json.decode(res.body);

    setState(() {
      data = resBody["data"];
      _mySelection = widget.barang_kategori_id;
    });

    print(resBody["data"]);

    return "Sucess";
  }

  Future<String> prosesUpdate() async {
    /*
    setState(() {
      _saving = true;
    });
    */
    var res = await http.put("${URL}/barang", headers: {
      "Accept": "application/json",
      "key": "123",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "barang_kategori_id": _mySelection,
      "barang_nama": controllerBarangNama.text.toString(),
      "barang_stok": controllerBarangStok.text.toString(),
      "barang_user_nama": controllerUserNama.text.toString(),
      "barang_id": controllerBarangId.text.toString()
    });

    if (res.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(res.body);

      if (mapResponse["status"] == "200") {
        setState(() {
          messageUpdate = mapResponse["message"];
          //_saving = false;
          //print(_saving);
        });
        print('Masuk');  
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text(messageUpdate),
          duration: new Duration(seconds: 5),
        ));  
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("gagal"),
          duration: new Duration(seconds: 5),
        ));
      throw Exception('Failed to load Barang from the internet');
    }
  }

  TextEditingController controllerBarangId;

  TextEditingController controllerBarangNama;
  TextEditingController controllerBarangStok;
  TextEditingController controllerUserNama;

  @override
  void initState() {
    super.initState();

    this.getSWData();

    controllerBarangId = new TextEditingController(text: widget.barang_id);
    controllerBarangNama = new TextEditingController(text: widget.barang_nama);
    controllerBarangStok = new TextEditingController(text: widget.barang_stok);
    controllerUserNama =
        new TextEditingController(text: widget.barang_user_nama);
  }

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.barang_nama),
        ),
        body: ListView(
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            new TextField(
              controller: controllerBarangId,
              decoration: new InputDecoration(
                  enabled: false,
                  hintText: "Barang ID",
                  labelText: "Barang ID",
                  border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0))),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            Row(
              children: <Widget>[
                new Text("Kategori : "),
                new DropdownButton(
                  items: data.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item['kategori_nama']),
                      value: item['kategori_id'].toString(),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      _mySelection = newVal;
                    });
                  },
                  value: _mySelection,
                ),
              ],
            ),
            new Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            new TextField(
              controller: controllerBarangNama,
              decoration: new InputDecoration(
                  hintText: "Nama",
                  labelText: "Nama",
                  border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0))),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            new TextField(
              controller: controllerBarangStok,
              decoration: new InputDecoration(
                  hintText: "Stok",
                  labelText: "Stok",
                  border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0))),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            new TextField(
              enabled: false,
              controller: controllerUserNama,
              decoration: new InputDecoration(
                  hintText: "Username",
                  labelText: "Username",
                  border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0))),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            new RaisedButton(
              padding: const EdgeInsets.all(8.0),
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () => prosesUpdate(),
              child: new Text("Update"),
            ),
            
          ],
        ),
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.barang_nama),
        ),
        body: new Center(
          child: new CircularProgressIndicator(),
        ) 
      );
    }
  }
}
