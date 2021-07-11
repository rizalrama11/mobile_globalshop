class BaseUrl {
  static String url = "http://10.0.2.2/api_globalshop/";
  static String paths = "http://10.0.2.2/api_globalshop/upload/";

  //VIEW DATA
  static String urlDataBarang = url + "api/data_barang.php";
  static String urlListKategori = url + "api/list_kategori.php";
  static String urlListSatuan = url + "api/list_satuan.php";
  static String urlDataTerbaru = url + "api/data_barang_terbaru.php";
  static String urlDataTerlaris = url + "api/data_barang_terlaris.php";
  //ADD DATA
  static String urlTambahProduk = url + "api/add_barang.php";
  static String urlTambahKategori = url + "api/add_kategori.php";
  static String urlTambahSatuan = url + "api/add_satuan.php";
  //EDIT DATA
  static String urlEditProduk = url + "api/edit_barang.php";
  static String urlEditKategori = url + "api/edit_kategori.php";
  static String urlEditSatuan = url + "api/edit_satuan.php";
  //DELETE DATA
  static String urlHapusProduk = url + "api/delete_barang.php";
  static String urlHapusKategori = url + "api/delete_kategori.php";
  static String urlHapusSatuan = url + "api/delete_satuan.php";
  //CART
  static String urlAddCart = url + "api/add_cart.php";
  static String urlCountCart = url + "api/count_cart.php?userid=";
  static String urlMinusQty = url + "api/minus_qty_cart.php";
  static String urlDetailCart = url + "api/detail_cart.php?userid=";
  //CHECKOUT
  static String urlCheckout = url + "api/proses_checkout.php";
  //HISTORY
  static String urlHistory = url + "api/history.php?userid=";
  //LOGIN
  static String urlLogin = url + "api/login.php";
}
