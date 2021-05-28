class ProdukModel {
  String nomor;
  String id_barang;
  String id_kategori;
  String id_satuan;
  String nama_barang;
  String harga;
  String image;
  String tglexpired;

  ProdukModel(this.nomor, this.id_barang, this.id_kategori, this.id_satuan,
      this.nama_barang, this.harga, this.image, this.tglexpired);

  ProdukModel.fromJson(Map<String, dynamic> json) {
    nomor = json['nomor'];
    id_barang = json['id_barang'];
    id_kategori = json['id_kategori'];
    id_satuan = json['id_satuan'];
    nama_barang = json['nama_barang'];
    harga = json['harga'];
    image = json['image'];
    tglexpired = json['tglexpired'];
  }
}
