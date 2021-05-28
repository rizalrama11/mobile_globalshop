import 'package:flutter/material.dart';
import 'package:mobile_globalshop/model/api.dart';
import 'package:http/http.dart' as http;

class TambahSatuan extends StatefulWidget {
  final VoidCallback reload;
  TambahSatuan(this.reload);

  @override
  _TambahSatuanState createState() => _TambahSatuanState();
}

class _TambahSatuanState extends State<TambahSatuan> {
  String namaSatuan, satuan;
  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      simpansatuan();
    }
  }

  simpansatuan() async {
    try {
      var uri = Uri.parse(BaseUrl.urlTambahSatuan);
      var request = http.MultipartRequest("POST", uri);
      request.fields['nama_satuan'] = namaSatuan;
      request.fields['satuan'] = satuan;
      var response = await request.send();
      if (this.mounted) {
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      }
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getPref();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150.0,
    );
    return Scaffold(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        appBar: AppBar(
          title: Text("Tambah Satuan"),
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
            padding: EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 50.0),
            children: <Widget>[
              TextFormField(
                validator: (e) {
                  if (e.isEmpty) {
                    return "Silahkan isi nama satuan";
                  }
                },
                onSaved: (e) => namaSatuan = e,
                decoration: InputDecoration(labelText: "Nama Satuan"),
              ),
              TextFormField(
                validator: (e) {
                  if (e.isEmpty) {
                    return "Silahkan isi jumlah satuan";
                  }
                },
                onSaved: (e) => satuan = e,
                decoration: InputDecoration(labelText: "Satuan"),
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
        ));
  }
}
