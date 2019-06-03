import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../global.dart';
import './detail.dart';

class Cari extends StatefulWidget {
  @override
  _CariState createState() => _CariState();
}

class _CariState extends State<Cari> {
  //final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  List jsonData;
  bool statusInternet;

  String teks = "";
  TextEditingController controllerSearch = new TextEditingController();

  Future<String> ambilData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');
        print(statusInternet);
        setState(() {
          statusInternet = true;
        });

        var response = await http.get(
          "${URL}/barang?key=123",
          //headers: {"Accept": "application/json"},
          //body: {"barang_nama": "beatle", "key": "123"}
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> mapResponse = json.decode(response.body);

          if (mapResponse["status"] == "200") {
            setState(() {
              jsonData = mapResponse["data"];
            });
          }
        } else {
          throw Exception('Failed to load Barang from the internet');
        }
      }
    } on SocketException catch (_) {
      setState(() {
        statusInternet = false;
      });
      print('not connected');
    }
  }

  Future<String> searchData(String str) async {
    var response = await http.post("${URL}/barang",
        headers: {"Accept": "application/json"},
        body: {"barang_nama": teks, "key": "123"});

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);

      if (mapResponse["status"] == "200") {
        setState(() {
          jsonData = mapResponse["data"];
        });
      }
    } else {
      throw Exception('Failed to load Barang from the internet');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    statusInternet = false;

    this.ambilData();

    /*
    WidgetsBinding.instance
      .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    */
  }

  @override
  Widget build(BuildContext context) {
    if (statusInternet == false) {
      return Scaffold(
        appBar: new AppBar(
          title: new Text("Cari Barang"),
        ),
        body: RefreshIndicator(
          //key: _refreshIndicatorKey,
          onRefresh: ambilData,
          child: new Container(
              padding: EdgeInsets.all(10.0),
              child: new Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new TextField(
                      controller: controllerSearch,
                      onSubmitted: (String str) {
                        setState(() {
                          teks = str;
                          controllerSearch.text = "";
                        });

                        this.searchData(str);
                      },
                      decoration: new InputDecoration(
                          hintText: "Masukan kata kunci",
                          prefixIcon: Icon(Icons.search)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text("Kata kunci : \"${teks}\""),
                  ),
                  Text("Internet tidak konek!"),
                  Expanded(
                    child: new ListView.builder(
                      itemCount: jsonData == null ? 0 : jsonData.length,
                      itemBuilder: (BuildContext context, int i) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Detail(
                                        barang_id: jsonData[i]['barang_id'],
                                        barang_kategori_id: jsonData[i]
                                            ['barang_kategori_id'],
                                        barang_nama: jsonData[i]['barang_nama'],
                                        barang_stok: jsonData[i]['barang_stok'],
                                        barang_user_nama: jsonData[i]
                                            ['barang_user_nama'],
                                      )),
                            );
                          },
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: new Text(jsonData[i]['barang_nama']),
                          )),
                        );
                      },
                    ),
                  ),
                ],
              )),
        ),
      );
    } else {
      if (jsonData != null) {
        return Scaffold(
          appBar: new AppBar(
            title: new Text("Cari Barang"),
          ),
          body: RefreshIndicator(
            //key: _refreshIndicatorKey,
            onRefresh: ambilData,
            child: new Container(
                padding: EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: new TextField(
                        controller: controllerSearch,
                        onSubmitted: (String str) {
                          setState(() {
                            teks = str;
                            controllerSearch.text = "";
                          });

                          this.searchData(str);
                        },
                        decoration: new InputDecoration(
                            hintText: "Masukan kata kunci",
                            prefixIcon: Icon(Icons.search)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text("Kata kunci : \"${teks}\""),
                    ),
                    Expanded(
                      child: new ListView.builder(
                        itemCount: jsonData == null ? 0 : jsonData.length,
                        itemBuilder: (BuildContext context, int i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Detail(
                                          barang_id: jsonData[i]['barang_id'],
                                          barang_kategori_id: jsonData[i]
                                              ['barang_kategori_id'],
                                          barang_nama: jsonData[i]
                                              ['barang_nama'],
                                          barang_stok: jsonData[i]
                                              ['barang_stok'],
                                          barang_user_nama: jsonData[i]
                                              ['barang_user_nama'],
                                        )),
                              );
                            },
                            child: Card(
                                child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: new Text(jsonData[i]['barang_nama']),
                            )),
                          );
                        },
                      ),
                    ),
                  ],
                )),
          ),
        );
      } else {
        return Scaffold(
          appBar: new AppBar(
            title: new Text("Cari Barang"),
          ),
          body: RefreshIndicator(
            //key: _refreshIndicatorKey,
            onRefresh: ambilData,
            child: new Container(
                padding: EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: new TextField(
                        controller: controllerSearch,
                        onSubmitted: (String str) {
                          setState(() {
                            teks = str;
                            controllerSearch.text = "";
                          });

                          this.searchData(str);
                        },
                        decoration: new InputDecoration(
                            hintText: "Masukan kata kunci",
                            prefixIcon: Icon(Icons.search)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text("Kata kunci : \"${teks}\""),
                    ),
                    Center(
                      child: new CircularProgressIndicator(),
                    )
                  ],
                )),
          ),
        );
      }
    }
  }
}
