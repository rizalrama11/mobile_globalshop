import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_globalshop/model/SatuanModel.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_globalshop/model/api.dart';

class EditSatuan extends StatefulWidget {
  final VoidCallback reload;
  final SatuanModel model;
  EditSatuan(this.model, this.reload);

  @override
  _EditSatuanState createState() => _EditSatuanState();
}

class _EditSatuanState extends State<EditSatuan> {
  String idSatuan, namaSatuan, satuan;
  final _key = new GlobalKey<FormState>();

  TextEditingController txtIdSatuan, txtNamaSatuan, txtSatuan;
  setup() async {
    txtIdSatuan = TextEditingController(text: widget.model.idSatuan);
    txtNamaSatuan = TextEditingController(text: widget.model.namaSatuan);
    txtSatuan = TextEditingController(text: widget.model.satuan);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      updatedata();
    }
  }

  updatedata() async {
    final response = await http.post(BaseUrl.urlEditSatuan, body: {
      "nama_satuan": namaSatuan,
      "satuan": satuan,
      "id_satuan": idSatuan == null ? widget.model.idSatuan : idSatuan
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
        title: Text("Edit Data Satuan"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: txtNamaSatuan,
              validator: (e) {
                if (e.isEmpty) {
                  return "Silahkan isi data";
                }
              },
              onSaved: (e) => namaSatuan = e,
              decoration: InputDecoration(labelText: "Nama Satuan"),
            ),
            TextFormField(
              controller: txtSatuan,
              validator: (e) {
                if (e.isEmpty) {
                  return "Silahkan isi data";
                }
              },
              onSaved: (e) => satuan = e,
              decoration: InputDecoration(labelText: "Jumlah Satuan"),
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
