class CartModel {
  String id_barang;
  String idUsers;
  String nama_barang;
  String gambar;
  String harga;
  String qty;

  CartModel(this.id_barang, this.idUsers, this.nama_barang, this.gambar,
      this.harga, this.qty);

  CartModel.fromJson(Map<String, dynamic> json) {
    id_barang = json['id_barang'];
    idUsers = json['userid'];
    nama_barang = json['nama_barang'];
    gambar = json['gambar'];
    harga = json['harga'];
    qty = json['qty'];
  }
}
