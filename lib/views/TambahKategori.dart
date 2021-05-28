import 'package:flutter/material.dart';
import 'package:mobile_globalshop/model/api.dart';
import 'package:http/http.dart' as http;

class TambahKategori extends StatefulWidget {
  final VoidCallback reload;
  TambahKategori(this.reload);

  @override
  _TambahKategoriState createState() => _TambahKategoriState();
}

class _TambahKategoriState extends State<TambahKategori> {
  String namaKategori;
  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      simpankategori();
    }
  }

  simpankategori() async {
    try {
      var uri = Uri.parse(BaseUrl.urlTambahKategori);
      var request = http.MultipartRequest("POST", uri);
      request.fields['nama_kategori'] = namaKategori;
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Tambah Kategori"),
        ),
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 50.0),
            children: <Widget>[
              TextFormField(
                validator: (e) {
                  if (e.isEmpty) {
                    return "Silahkan isi nama kategori";
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
        ));
  }
}
