import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_globalshop/model/api.dart';
import 'package:mobile_globalshop/model/KategoriModel.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_globalshop/views/EditKategori.dart';
import 'package:mobile_globalshop/views/TambahKategori.dart';

class MenuKategori extends StatefulWidget {
  @override
  _MenuKategoriState createState() => _MenuKategoriState();
}

class _MenuKategoriState extends State<MenuKategori> {
  final _key = new GlobalKey<FormState>();
  var loading = false;
  final list = new List<KategoriModel>();
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

    final response = await http.get(Uri.parse(BaseUrl.urlListKategori));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new KategoriModel(
            api['nomor'], api['id_kategori'], api['nama_kategori']);
        list.add(ab);
      });

      setState(() {
        loading = false;
      });
    }
  }

  _hapusdata(String idKtg) async {
    final response = await http.post(Uri.parse(BaseUrl.urlHapusKategori),
        body: {"id_kategori": idKtg});
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

  dialogHapus(String idKtg) async {
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
                        _hapusdata(idKtg);
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
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Data Kategori",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.teal[200],
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new TambahKategori(_lihatData)));
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
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Nama Kategori: " + x.namaKategori,
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EditKategori(x, _lihatData)));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            dialogHapus(x.idKategori);
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
