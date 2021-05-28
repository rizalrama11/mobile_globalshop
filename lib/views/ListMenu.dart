import 'package:flutter/material.dart';
import 'package:mobile_globalshop/views/MenuKategori.dart';
import 'package:mobile_globalshop/views/MenuProduk.dart';
import 'package:mobile_globalshop/views/MenuSatuan.dart';

class ListMenu extends StatefulWidget {
  @override
  _ListMenuState createState() => _ListMenuState();
}

class _ListMenuState extends State<ListMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Master Data",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 5.0),
        children: <Widget>[
          new Divider(
            height: 4.0,
            indent: 1.0,
          ),
          ListTile(
            leading: Material(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.purple.withOpacity(0.1),
              child: IconButton(
                padding: EdgeInsets.all(0.0),
                icon: Icon(Icons.category),
                color: Colors.black,
                iconSize: 30.0,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new MenuKategori()));
                },
              ),
            ),
            title: Text("Kategori Produk"),
            contentPadding: EdgeInsets.all(7.0),
            subtitle: Text("Pengelolaan Data Kategori"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new MenuKategori()));
            },
          ),
          new Divider(
            height: 4.0,
            indent: 1.0,
          ),
          ListTile(
            leading: Material(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.purple.withOpacity(0.1),
              child: IconButton(
                padding: EdgeInsets.all(0.0),
                icon: Icon(Icons.confirmation_number_rounded),
                color: Colors.black,
                iconSize: 30.0,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new MenuKategori()));
                },
              ),
            ),
            title: Text("Satuan Produk"),
            contentPadding: EdgeInsets.all(7.0),
            subtitle: Text("Pengelolaan Data Satuan"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new MenuSatuan()));
            },
          ),
          new Divider(
            height: 4.0,
            indent: 1.0,
          ),
          ListTile(
            leading: Material(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.purple.withOpacity(0.1),
              child: IconButton(
                padding: EdgeInsets.all(0.0),
                icon: Icon(Icons.sports_soccer),
                color: Colors.black,
                iconSize: 30.0,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new MenuProduk()));
                },
              ),
            ),
            title: Text("Data Produk"),
            contentPadding: EdgeInsets.all(7.0),
            subtitle: Text("Pengelolaan Data Produk"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new MenuProduk()));
            },
          ),
          new Divider(
            height: 4.0,
            indent: 1.0,
          ),
        ],
      ),
    );
  }
}
