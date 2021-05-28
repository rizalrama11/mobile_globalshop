import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_globalshop/custom/currency.dart';
import 'package:mobile_globalshop/custom/datePicker.dart';
import 'package:mobile_globalshop/model/ProdukModel.dart';
import 'package:mobile_globalshop/model/KategoriModel.dart';
import 'package:mobile_globalshop/model/SatuanModel.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_globalshop/model/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class EditProduk extends StatefulWidget {
  final VoidCallback reload;
  final ProdukModel model;
  EditProduk(this.model, this.reload);

  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  String idBarang, namaBarang, harga, tglExpired, kategoriID, satuanID;

  final _key = new GlobalKey<FormState>();
  //tambahan file foto
  File _imageFile;

  TextEditingController txtIdBarang, txtnamaBarang, txtHarga;
  setup() async {
    tglExpired = widget.model.tglexpired;
    txtnamaBarang = TextEditingController(text: widget.model.nama_barang);
    txtHarga = TextEditingController(text: widget.model.harga);
    txtIdBarang = TextEditingController(text: widget.model.id_barang);
  }

  //tambahan ddl
  KategoriModel _currentKategori;
  SatuanModel _currentSatuan;
  final listKategori = new List<KategoriModel>();
  final listSatuan = new List<SatuanModel>();
  final String linkKategori = BaseUrl.urlListKategori;
  final String linkSatuan = BaseUrl.urlListSatuan;

  Future<List<KategoriModel>> _fetchKategori() async {
    var response = await http.get(Uri.parse(linkKategori));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<KategoriModel> listOfKategori = items.map<KategoriModel>((json) {
        return KategoriModel.fromJson(json);
      }).toList();

      return listOfKategori;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  Future<List<SatuanModel>> _fetchSatuan() async {
    var response = await http.get(Uri.parse(linkSatuan));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<SatuanModel> listOfSatuan = items.map<SatuanModel>((json) {
        return SatuanModel.fromJson(json);
      }).toList();

      return listOfSatuan;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  _pilihGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080);

    setState(() {
      _imageFile = image;
      Navigator.pop(context);
    });
  } //end pilih gallery

  _pilihCamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080);

    setState(() {
      _imageFile = image;
      Navigator.pop(context);
    });
  } //end pilih kamera

//dialog
  dialogFileFoto() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Silahkan pilih sumber file",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 18.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          _pilihCamera();
                        },
                        child: Text(
                          "Kamera",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: 25.0,
                    ),
                    InkWell(
                        onTap: () {
                          _pilihGallery();
                        },
                        child: Text(
                          "Gallery",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        )),
                  ],
                )
              ],
            ),
          );
        });
  }

  // TextEditingController txtIdBarang, txtnamaBarang, txtHarga, txtUserId;
  // setup() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     userid = preferences.getString("userid");
  //   });

  //   tglExpired = widget.model.tglexpired;
  //   txtnamaBarang = TextEditingController(text: widget.model.nama_barang);
  //   txtHarga = TextEditingController(text: widget.model.harga);
  //   txtIdBarang = TextEditingController(text: widget.model.id_barang);
  // }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      prosesbarang();
    }
  }

  prosesbiasa() async {
    final response = await http.post(Uri.parse(BaseUrl.urlEditProduk), body: {
      "nama_barang": namaBarang,
      "id_kategori": kategoriID == null ? widget.model.id_kategori : kategoriID,
      "id_satuan": satuanID == null ? widget.model.id_satuan : satuanID,
      "harga": harga.replaceAll(",", ""),
      "tglexpired": "$tglExpired",
      "idProduk": widget.model.id_barang
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

  String body(http.Response response) => response.body;

  prosesbarang() async {
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.urlEditProduk);
      var request = http.MultipartRequest("POST", uri);
      request.fields['nama_barang'] = namaBarang;
      request.fields['harga'] = harga.replaceAll(",", "");
      request.fields['userid'] = "1";
      request.fields['id_kategori'] =
          kategoriID == null ? widget.model.id_kategori : kategoriID;
      request.fields['id_satuan'] =
          satuanID == null ? widget.model.id_satuan : satuanID;
      request.fields['idProduk'] = widget.model.id_barang;
      request.fields['tglexpired'] = "$tglExpired";
      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));

      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        if (this.mounted) {
          setState(() {
            widget.reload();
            Navigator.pop(context);
          });
        }
      } else {
        print("image fail");
        //but save data edit
        prosesbiasa();
      }
    } catch (e) {
      prosesbiasa();
      debugPrint(e);
    }
  }

  String labelText;
  DateTime tgl = new DateTime.now();
  var formatTgl = new DateFormat('yyyy-MM-dd');
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  Future<Null> _selectedDate(BuildContext context) async {
    tgl = DateTime.parse(widget.model.tglexpired);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: tgl,
        firstDate: DateTime(1992),
        lastDate: DateTime(2099));

    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        tglExpired = formatTgl.format(tgl);
      });
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data Produk"),
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
            Text("Foto Produk"),
            Container(
                width: double.infinity,
                height: 150.0,
                child: InkWell(
                    onTap: () {
                      dialogFileFoto();
                    },
                    child: _imageFile == null
                        ? Image.network(BaseUrl.paths + widget.model.image)
                        : Image.file(_imageFile, fit: BoxFit.fill))),
            Text("Kategori Produk"),
            FutureBuilder<List<KategoriModel>>(
                future: _fetchKategori(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<KategoriModel>> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return DropdownButton<KategoriModel>(
                    items: snapshot.data
                        .map((listkategori) => DropdownMenuItem<KategoriModel>(
                              child: Text(listkategori.namaKategori),
                              value: listkategori,
                            ))
                        .toList(),
                    onChanged: (KategoriModel value) {
                      setState(() {
                        _currentKategori = value;
                        kategoriID = _currentKategori.idKategori;
                      });
                    },
                    isExpanded: false,
                    hint: Text(kategoriID == null ||
                            kategoriID == widget.model.id_kategori
                        ? widget.model.id_kategori
                        : _currentKategori.idKategori),
                  );
                }),
            Text("Satuan Produk"),
            FutureBuilder<List<SatuanModel>>(
                future: _fetchSatuan(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<SatuanModel>> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return DropdownButton<SatuanModel>(
                    items: snapshot.data
                        .map((listsatuan) => DropdownMenuItem<SatuanModel>(
                              child: Text(listsatuan.namaSatuan),
                              value: listsatuan,
                            ))
                        .toList(),
                    onChanged: (SatuanModel value) {
                      setState(() {
                        _currentSatuan = value;
                        satuanID = _currentSatuan.idSatuan;
                      });
                    },
                    isExpanded: false,
                    hint: Text(
                        satuanID == null || satuanID == widget.model.id_satuan
                            ? widget.model.id_satuan
                            : _currentSatuan.idSatuan),
                  );
                }),
            TextFormField(
              controller: txtnamaBarang,
              validator: (e) {
                if (e.isEmpty) {
                  return "Silahkan isi data";
                }
              },
              onSaved: (e) => namaBarang = e,
              decoration: InputDecoration(labelText: "Nama Produk"),
            ),
            TextFormField(
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                CurrencyFormat()
              ],
              controller: txtHarga,
              validator: (e) {
                if (e.isEmpty) {
                  return "Silahkan isi data";
                }
              },
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: "Harga Produk"),
            ),
            Text("Tgl Expired"),
            DateDropDown(
              labelText: labelText,
              valueText: tglExpired,
              valueStyle: valueStyle,
              onPressed: () {
                _selectedDate(context);
              },
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
