import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile_globalshop/model/ProdukModel.dart';
import 'package:mobile_globalshop/model/api.dart';
import 'package:mobile_globalshop/views/EditProduk.dart';
import 'package:mobile_globalshop/views/LoadingPageOne.dart';
import 'package:mobile_globalshop/views/TambahProduk.dart';
import 'package:shimmer/shimmer.dart';

class MenuProduk extends StatefulWidget {
  @override
  _MenuProdukState createState() => _MenuProdukState();
}

class _MenuProdukState extends State<MenuProduk> {
  final money = NumberFormat("#,##0", "en_US");
  var loading = false;
  final list = new List<ProdukModel>();
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

    final response = await http.get(Uri.parse(BaseUrl.urlDataBarang));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new ProdukModel(
            api['nomor'],
            api['id_barang'],
            api['id_kategori'],
            api['id_satuan'],
            api['nama_barang'],
            api['harga'],
            api['image'],
            api['tglexpired']);
        list.add(ab);
      });

      setState(() {
        loading = false;
      });
    }
  }

  _prosesHapus(String idBrg) async {
    final response = await http
        .post(Uri.parse(BaseUrl.urlHapusProduk), body: {"idProduk": idBrg});
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

  dialogHapus(String idBrg) async {
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
                        _prosesHapus(idBrg);
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
                "Data Produk",
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
                  builder: (context) => new TambahProduk(_lihatData)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Center(child: LoadingPageOne())
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
                        Image.network(BaseUrl.paths + "" + x.image,
                            width: 100.0, height: 100.0, fit: BoxFit.cover),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "No. " + x.nomor,
                                style: TextStyle(fontSize: 15.0),
                              ),
                              Text(
                                x.nama_barang,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Rp. " + money.format(int.parse(x.harga)),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EditProduk(x, _lihatData)));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            dialogHapus(x.id_barang);
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
