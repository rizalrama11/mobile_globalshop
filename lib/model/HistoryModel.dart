class HistoryModel {
  String id_faktur;
  String idUsers;
  String nama_barang;
  String tgl_jual;
  String gambar;
  String harga;
  String qty;

  HistoryModel(this.id_faktur, this.idUsers, this.nama_barang, this.tgl_jual, this.gambar,
      this.harga, this.qty);

  HistoryModel.fromJson(Map<String, dynamic> json) {
    id_faktur = json['id_faktur'];
    idUsers = json['userid'];
    nama_barang = json['nama_barang'];
    tgl_jual = json['tgl_jual'];
    gambar = json['gambar'];
    harga = json['harga'];
    qty = json['qty'];
  }
}
