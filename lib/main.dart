import 'package:flutter/material.dart';
import 'package:mobile_globalshop/mainUser.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.black),
    home: mainUser(),
  ));
}
