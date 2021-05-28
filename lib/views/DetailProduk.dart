import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_globalshop/model/ProdukModel.dart';
import 'package:mobile_globalshop/model/api.dart';
import 'package:mobile_globalshop/custom/constans.dart';
import 'package:intl/intl.dart';
import 'package:mobile_globalshop/model/KeranjangModel.dart';
import 'package:http/http.dart' as http;

class DetailProduk extends StatefulWidget {
  final ProdukModel listProduk;

  DetailProduk({@required this.listProduk});

  @override
  _DetailProdukState createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  int _currentImage = 0;
  final money = NumberFormat("#,##0", "en_US");

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (var i = 0; i < widget.listProduk.image.length; i++) {
      list.add(
          i == _currentImage ? buildIndicator(true) : buildIndicator(false));
    }
    return list;
  }

  Widget buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      height: 8.0,
      width: isActive ? 20.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }

  //add to cart
  tambahKeranjang(String idProduk, String harga) async {
    final response = await http.post(BaseUrl.urlAddCart,
        body: {"userid": "1", "id_barang": idProduk, "harga": harga});

    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];

    if (value == 1) {
      print(pesan);
      _countCart();
    } else {
      print(pesan);
    }
  }

  var loading = false;
  String jumlahnya = "0";
  final ex = List<KeranjangModel>();
  _countCart() async {
    if (this.mounted) {
      setState(() {
        loading = true;
      });
    }
    ex.clear();
    final response = await http.get(BaseUrl.urlCountCart + "1");
    final data = jsonDecode(response.body);
    data.forEach((api) {
      final exp = new KeranjangModel(api['jumlah']);
      ex.add(exp);
      if (this.mounted) {
        setState(() {
          jumlahnya = exp.jumlah;
        });
      }
    });

    if (this.mounted) {
      setState(() {
        _countCart();
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _countCart();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/img/logo.png",
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 32,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              jumlahnya == "0"
                  ? Container()
                  : Positioned(
                      right: 0.0,
                      child: Stack(
                        children: [
                          Icon(
                            Icons.brightness_1,
                            size: 20.0,
                            color: Colors.white,
                          ),
                          Positioned(
                            top: 3.0,
                            right: 6.0,
                            child: Text(
                              jumlahnya,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (int page) {
                    setState(() {
                      _currentImage = page;
                    });
                  },
                  children: <Widget>[
                    Container(
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          spreadRadius: 5,
                          color: Colors.black.withOpacity(0.1),
                        )
                      ]),
                      child: Hero(
                        tag: widget.listProduk.nama_barang,
                        child: Image.network(
                          BaseUrl.paths + widget.listProduk.image,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Image.asset(
                  "assets/img/nikelogo.png",
                  width: 70,
                  fit: BoxFit.cover,
                  color: Colors.black,
                ),
              ),
              Container(
                height: size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Container(
                        height: size.height * 0.2,
                        padding: EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.listProduk.nama_barang,
                              style: TextStyle(
                                fontFamily: "Averta",
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Rp. " +
                                      money.format(
                                          int.parse(widget.listProduk.harga)),
                                  style: TextStyle(
                                      fontFamily: "Averta",
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              size: 16,
                              color: kStarsColor,
                            ),
                            Icon(
                              Icons.star,
                              size: 16,
                              color: kStarsColor,
                            ),
                            Icon(
                              Icons.star,
                              size: 16,
                              color: kStarsColor,
                            ),
                            Icon(
                              Icons.star,
                              size: 16,
                              color: kStarsColor,
                            ),
                            Icon(
                              Icons.star_half,
                              size: 16,
                              color: kStarsColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 120,
                    ),

                    Center(
                      child: Container(
                        width: size.width * 0.5,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.all(16),
                        child: GestureDetector(
                          onTap: () {
                            tambahKeranjang(widget.listProduk.id_barang,
                                widget.listProduk.harga);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_basket,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Text(
                                "Add To Cart",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   height: size.height * 0.1,
                    //   decoration: BoxDecoration(
                    //     color: Color(0xff497786),
                    //     borderRadius: BorderRadius.circular(40),
                    //   ),
                    //   child: GestureDetector(
                    //     onTap: () {},
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: <Widget>[
                    //         Text(
                    //           "Add To Cart",
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 18,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           width: 16,
                    //         ),
                    //         Icon(
                    //           Icons.shopping_basket,
                    //           color: Colors.white,
                    //           size: 30,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
