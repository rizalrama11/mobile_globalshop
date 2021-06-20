import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_globalshop/custom/currency.dart';
import 'package:mobile_globalshop/model/api.dart';
import 'package:mobile_globalshop/model/CartModel.dart';
import 'package:mobile_globalshop/views/Checkout.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _key = new GlobalKey<FormState>();
  final money = NumberFormat("#,##0", "en_US");
  final list = new List<CartModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  var loading = false;
  String idUsers;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("userid");
    });
    _countData(idUsers);
    _lihatData();
  }

  String totalBelanja = "0";
  String nilaiBayar = "0";

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.urlDetailCart + idUsers));
    print("hasil: " + BaseUrl.urlDetailCart + idUsers);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new CartModel(api['id_barang'], api['userid'],
            api['nama_barang'], api['gambar'], api['harga'], api['qty']);
        list.add(ab);
      });

      setState(() {
        _countData(idUsers);
        loading = false;
      });
    }
  }

  Future<void> _countData(String idUsers) async {
    setState(() {
      loading = true;
    });
    final responseCnt = await http.get(BaseUrl.urlCountCart + idUsers);
    print("Hasil: " + BaseUrl.urlCountCart + idUsers);
    if (responseCnt.contentLength == 2) {
      final dataCnt = jsonDecode(responseCnt.body);
      dataCnt.forEach((api) {
        totalBelanja = api(['totalharga']);
      });

      setState(() {
        loading = false;
      });
    }
  }

  dialogCheckOut(String iduser, String grandTotal) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Form(
              key: _key,
              child: ListView(
                  padding: EdgeInsets.all(16.0),
                  shrinkWrap: true,
                  children: [
                    Text("Form Pembayaran"),
                    TextFormField(
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        CurrencyFormat()
                      ],
                      validator: (e) {
                        if (e.isEmpty) {
                          return "Silahkan isi nilai bayar";
                        }
                      },
                      onSaved: (e) => nilaiBayar = e,
                      decoration: InputDecoration(labelText: "Nilai Bayar"),
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Batal",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 25.0,
                        ),
                        InkWell(
                          onTap: () {
                            check(iduser, grandTotal);
                          },
                          child: Text(
                            "Proses",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          );
        });
  }

  dialogCart(String txt) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Form(
              key: _key,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                shrinkWrap: true,
                children: [
                  Text(
                    txt,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  dialogDelProdukInCart(String idProduk, String harga, String paramUserID) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Form(
              key: _key,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                shrinkWrap: true,
                children: [
                  Text(
                    "Ingin Menghapus produk dari daftar pembelian?",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          minusQtyinCart(idProduk, harga, paramUserID);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Ya",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Tidak",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  check(String userid, String gt) {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      _checkout(userid, gt);
    }
  }

  _checkout(String iduser, String total) async {
    double dTotal = double.parse(total.replaceAll(",", ""));
    double dNilaiBayar = double.parse(nilaiBayar.replaceAll(",", ""));
    double dNilaiKembali = dNilaiBayar - dTotal;

    if (dNilaiBayar >= dTotal) {
      final response = await http.post(BaseUrl.urlCheckout, body: {
        "userid": iduser,
        "grandTotal": total.replaceAll(",", ""),
        "nilaibayar": nilaiBayar.replaceAll(",", ""),
        "nilaikembali": dNilaiKembali.toString()
      });

      final data = jsonDecode(response.body);
      int value = data['success'];
      String pesans = data['message'];
      if (value == 1) {
        setState(() {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => new Checkout()));
        });
      } else {
        Navigator.pop(context);
        print(pesans);
      }
    } else {
      dialogCart("Pembayaran Kurang");
    }
  }

  _addQtyinCart(String idProduk, String harga, String paramUserID) async {
    final response = await http.post(BaseUrl.urlAddCart,
        body: {"userid": paramUserID, "id_barang": idProduk, "harga": harga});

    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];

    if (value == 1) {
      print(pesan);
      setState(() {
        getPref();
      });
    } else {
      print(pesan);
      throw StateError("Failed to update data.");
    }
  }

  minusQtyinCart(String idproduk, String harga, String paramUserID) async {
    final response = await http.post(BaseUrl.urlMinusQty,
        body: {"userid": paramUserID, "id_barang": idproduk, "harga": harga});

    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];

    if (value == 1) {
      print(pesan);
      setState(() {
        getPref();
      });
    } else {
      print(pesan);
      getPref();
    }
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
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.1,
        backgroundColor: Color(0xffb4b4b4),
        title: Text(
          'Detail Belanja',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          new IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
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
                  int _currentAmount = int.parse(x.qty);
                  int _idBrg = x.id_barang == null ? 0 : int.parse(x.id_barang);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: Image.network(
                              BaseUrl.paths + "" + x.gambar,
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${x.nama_barang}",
                                style: Theme.of(context).textTheme.title,
                              ),
                              Text(
                                "Rp. " + "${money.format(int.parse(x.harga))}",
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.orange,
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      print("Hasil " + BaseUrl.urlMinusQty);
                                      if (_currentAmount > 0) {
                                        minusQtyinCart(
                                            x.id_barang, x.harga, x.idUsers);
                                      } else {
                                        _currentAmount = 0;
                                        dialogDelProdukInCart(
                                            x.id_barang, x.harga, x.idUsers);
                                      }
                                    },
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    "$_currentAmount",
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xfffbc30b),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      _addQtyinCart(
                                          x.id_barang, x.harga, x.idUsers);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: new Row(
          children: [
            Expanded(
              child: ListTile(
                title: new Text("Total : "),
                subtitle:
                    new Text("Rp. " + money.format(int.parse(totalBelanja))),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: new MaterialButton(
                  onPressed: () {
                    totalBelanja != "0"
                        ? dialogCheckOut(idUsers, totalBelanja)
                        : dialogCart("Tidak ada transaksi");
                  },
                  child: new Text(
                    "Check Out",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
