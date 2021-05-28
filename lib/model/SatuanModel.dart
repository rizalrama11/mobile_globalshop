class SatuanModel {
  String nomor;
  String idSatuan;
  String namaSatuan;
  String satuan;

  SatuanModel(this.nomor, this.idSatuan, this.namaSatuan, this.satuan);

  SatuanModel.fromJson(Map<String, dynamic> json) {
    nomor = json['nomor'];
    idSatuan = json['id_satuan'];
    namaSatuan = json['nama_satuan'];
    satuan = json['satuan'];
  }
}
