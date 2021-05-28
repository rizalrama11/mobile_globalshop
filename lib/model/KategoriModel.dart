class KategoriModel {
  String nomor;
  String idKategori;
  String namaKategori;

  KategoriModel(this.nomor, this.idKategori, this.namaKategori);

  KategoriModel.fromJson(Map<String, dynamic> json) {
    nomor = json['nomor'];
    idKategori = json['id_kategori'];
    namaKategori = json['nama_kategori'];
  }
}
