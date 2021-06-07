import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_globalshop/views/AboutUs.dart';
import 'package:mobile_globalshop/views/Cart.dart';
import 'package:mobile_globalshop/views/DetailProduk.dart';
import 'package:mobile_globalshop/views/ListMenu.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'model/ProdukModel.dart';
import 'package:mobile_globalshop/custom/constans.dart';
import 'model/api.dart';
import 'model/KeranjangModel.dart';
import 'package:mobile_globalshop/views/Cart.dart';

class MenuUser extends StatefulWidget {
  final VoidCallback signOut;
  MenuUser(this.signOut);

  @override
  _MenuUserState createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  final money = NumberFormat("#,##0", "en_US");
  var loading = false;
  final listProduk = new List<ProdukModel>();

  Future<void> _lihatData() async {
    listProduk.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.urlDataBarang);
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

        listProduk.add(ab);
      });

      setState(() {
        loading = false;
      });
    }
  }

  //addtocart
  tambahKeranjang(String idProduk, String harga) async {
    final response = await http.post(BaseUrl.urlAddCart,
        body: {"userid": "1", "id_barang": idProduk, "harga": harga});
    print(BaseUrl.urlAddCart);
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

  String jumlahnya = "0";
  final ex = List<KeranjangModel>();
  _countCart() async {
    setState(() {
      loading = true;
    });
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
    _lihatData();
    _countCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffb4b4b4),
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 24),
          child: IconButton(
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
            icon: Icon(
              Icons.menu,
              size: 32,
              color: Colors.black,
            ),
          ),
        ),
        title: Image.asset(
          "assets/img/logo.png",
        ),
        actions: <Widget>[
          Stack(
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.only(right: 24),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new Cart()));
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
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
      key: _scaffoldKey,
      body: RefreshIndicator(
        onRefresh: () async {
          _lihatData();
        },
        key: _refresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(left: 24, top: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Produk Terlaris",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Averta",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 300,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: buildItems(),
                  ),
                ),
                Text(
                  "Produk Terbaru",
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: "Averta",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 300,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: buildItems(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: new Text(
                "Rizal Ramadhan / 1118100172",
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: new Text(
                "rizalrama20@gmail.com",
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: AssetImage("assets/img/user.png"),
              ),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: AssetImage("assets/img/bg.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.8), BlendMode.dstATop)),
              ),
            ),
            ListTile(
              leading: Material(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.home),
                ),
              ),
              title: Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: Material(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new ListMenu()));
                  },
                  icon: Icon(Icons.data_usage),
                ),
              ),
              title: Text("Master Data"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new ListMenu()));
              },
            ),
            ListTile(
              leading: Material(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.history),
                ),
              ),
              title: Text("Riwayat Transaksi"),
              onTap: () {},
            ),
            ListTile(
              leading: Material(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => new AboutUs()));
                  },
                  icon: Icon(Icons.person),
                ),
              ),
              title: Text("About Us"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new AboutUs()));
              },
            ),
            ListTile(
              leading: Material(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      signOut();
                    });
                  },
                  icon: Icon(Icons.follow_the_signs),
                ),
              ),
              title: Text("Logout"),
              onTap: () {
                setState(() {
                  signOut();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(ProdukModel listProduk) {
    return GestureDetector(
      onTap: () {
        //halaman detail
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailProduk(listProduk: listProduk)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: kGradient,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                width: 1,
                color: Colors.grey[300],
              ),
            ),
            margin: EdgeInsets.only(right: 24),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 0,
                  ),
                  child: Center(
                    child: Image.network(
                      BaseUrl.paths + listProduk.image,
                      width: 190,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("Berhasil menambahkan data produk: " +
                        listProduk.nama_barang);
                    //fitur add to cart
                    tambahKeranjang(listProduk.id_barang, listProduk.harga);
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xfffbc30b),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                      width: 60,
                      height: 60,
                      child: Center(
                        child: Icon(
                          Icons.add_shopping_cart,
                          size: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            listProduk.nama_barang.length > 20
                ? listProduk.nama_barang.substring(0, 15) + ' ... '
                : listProduk.nama_barang,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Rp. " + money.format(int.parse(listProduk.harga)),
            style: TextStyle(
              fontSize: 16,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildItems() {
    List<Widget> list = [];
    for (var listProduk in listProduk) {
      list.add(buildItem(listProduk));
    }
    return list;
  }
}
