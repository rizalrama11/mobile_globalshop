import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_globalshop/model/api.dart';
import 'package:mobile_globalshop/model/SatuanModel.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_globalshop/views/EditSatuan.dart';
import 'package:mobile_globalshop/views/TambahSatuan.dart';

class MenuSatuan extends StatefulWidget {
  @override
  _MenuSatuanState createState() => _MenuSatuanState();
}

class _MenuSatuanState extends State<MenuSatuan> {
  String idSatuan, namaSatuan, satuan;
  final _key = new GlobalKey<FormState>();
  var loading = false;
  final list = new List<SatuanModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http.get(BaseUrl.urlListSatuan);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new SatuanModel(
            api['nomor'], api['id_satuan'], api['nama_satuan'], api['satuan']);
        list.add(ab);
      });

      setState(() {
        loading = false;
      });
    }
  }

  _hapusdata(String idSatuan) async {
    final response = await http
        .post(Uri.parse(BaseUrl.urlHapusSatuan), body: {"id_satuan": idSatuan});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _lihatData();
      });
    } else {
      print(pesan);
    }
  }

  dialogHapus(String idSatuan) async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Apakah anda yakin ingin menghapus data ini?",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 18.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Tidak",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 25.0),
                    InkWell(
                      onTap: () {
                        _hapusdata(idSatuan);
                      },
                      child: Text(
                        "Ya",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Data Satuan",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new TambahSatuan(_lihatData)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                x.nomor,
                                style: TextStyle(fontSize: 15.0),
                              ),
                              Text(
                                "Jenis Satuan : " + x.namaSatuan,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10.0,
                                height: 10.0,
                              ),
                              Text(
                                "Jumlah : " + x.satuan,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EditSatuan(x, _lihatData)));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            dialogHapus(x.idSatuan);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
