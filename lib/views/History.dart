// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mobile_globalshop/custom/currency.dart';
// import 'package:mobile_globalshop/model/api.dart';
// import 'package:mobile_globalshop/model/HistoryModel.dart';
// import 'package:mobile_globalshop/views/Checkout.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class History extends StatefulWidget {

//   @override
//   _HistoryState createState() => _HistoryState();
// }

// class _HistoryState extends State<History> {
//   final _key = new GlobalKey<FormState>();
//   final money = NumberFormat("#,##0", "en_US");
//   final list = new List<HistoryModel>();
//   final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
//   var loading = false;
//   String idUsers;
//   getPref() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       idUsers = preferences.getString("userid");
//     });
//     _lihatData();
//   }

//     Future<void> _lihatData() async {
//     list.clear();
//     setState(() {
//       loading = true;
//     });
//     final response = await http.get(Uri.parse(BaseUrl.urlHistory + idUsers));
//     print("hasil: " + BaseUrl.urlDetailCart + idUsers);
//     if (response.contentLength == 2) {
//     } else {
//       final data = jsonDecode(response.body);
//       data.forEach((api) {
//         final ab = new HistoryModel(api['id_barang'], api['userid'],
//             api['nama_barang'], api['gambar'], api['harga'], api['qty']);
//         list.add(ab);
//       });

//       setState(() {
//         loading = false;
//       });
//     }
//   }




//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }
