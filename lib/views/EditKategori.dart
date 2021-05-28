import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_globalshop/model/KategoriModel.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_globalshop/model/api.dart';

class EditKategori extends StatefulWidget {
  final VoidCallback reload;
  final KategoriModel model;
  EditKategori(this.model, this.reload);

  @override
  _EditKategoriState createState() => _EditKategoriState();
}

class _EditKategoriState extends State<EditKategori> {
  String kategoriID, namaKategori;
  final _key = new GlobalKey<FormState>();

  TextEditingController txtNamaKategori, txtIdKategori;
  setup() async {
    txtNamaKategori = TextEditingController(text: widget.model.namaKategori);
    txtIdKategori = TextEditingController(text: widget.model.idKategori);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      updatedata();
    }
  }

  updatedata() async {
    final response = await http.post(BaseUrl.urlEditKategori, body: {
      "nama_kategori": namaKategori,
      "id_kategori": kategoriID == null ? widget.model.idKategori : kategoriID
    });
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];

    if (value == 1) {
      setState(() {
        print(pesan);
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
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
        title: Text("Edit Data Kategori"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: txtNamaKategori,
              validator: (e) {
                if (e.isEmpty) {
                  return "Silahkan isi data";
                }
              },
              onSaved: (e) => namaKategori = e,
              decoration: InputDecoration(labelText: "Nama Kategori"),
            ),
            MaterialButton(
              color: Colors.black,
              onPressed: () {
                check();
              },
              child: Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
