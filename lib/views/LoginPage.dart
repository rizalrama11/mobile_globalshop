import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_globalshop/MenuUser.dart';
import 'package:mobile_globalshop/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var _autoValidate = false;

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  login() async {
    final response = await http.post(BaseUrl.urlLogin,
        body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];

    //user
    String usernameAPI = data['username'];
    String namaAPI = data['nama'];
    String userIdAPI = data['userid'];
    String userLevel = data['level'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, usernameAPI, namaAPI, userIdAPI, userLevel);
      });

      print(pesan);
    } else {
      print(pesan);
    }
  }

  savePref(int val, String usernameAPI, String namaAPI, String userIdAPI,
      userLevel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", val);
      preferences.setString("username", usernameAPI);
      preferences.setString("nama", namaAPI);
      preferences.setString("userid", userIdAPI);
      preferences.setString("level", userLevel);
      preferences.commit();
    });
  }

  var value;
  var level;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      level = preferences.getString("level");

      if (value == 1) {
        _loginStatus = LoginStatus.signIn;
      } else {
        _loginStatus = LoginStatus.notSignIn;
      }
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      preferences.setString("level", "");
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              decoration: BoxDecoration(
                color: Color(0xffb4b4b4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              "assets/img/logo.png",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Form(
                        autovalidate: _autoValidate,
                        key: _key,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              new Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Login",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 28.0,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: "Averta",
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: SizedBox(
                                      height: 20,
                                      width: 200,
                                      child: Divider(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                ],
                              ),
                              TextFormField(
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Silahkan isi username";
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (e) => username = e,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xffe7edeb),
                                  hintText: "Username",
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                obscureText: _secureText,
                                onSaved: (e) => password = e,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xffe7edeb),
                                  hintText: "Password",
                                  prefixIcon: Icon(
                                    Icons.password,
                                    color: Colors.grey[600],
                                  ),
                                  suffixIcon: IconButton(
                                      icon: Icon(_secureText
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: showHide),
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Container(
                                width: double.infinity,
                                child: RaisedButton(
                                  onPressed: () {
                                    check();
                                  },
                                  color: Color(0xfffbc30b),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        // return Scaffold(
        //   body: Form(
        //     key: _key,
        //     autovalidate: _autoValidate,
        //     child: ListView(
        //       padding: EdgeInsets.only(top: 90.0, left: 20.0, right: 20.0),
        //       children: [
        //         Image.asset(
        //           'assets/img/logo.png',
        //           height: 60,
        //           width: 60,
        //         ),
        //         Text(
        //           "Prodigy Store v0.1",
        //           textAlign: TextAlign.center,
        //           textScaleFactor: 1.2,
        //         ),
        //         TextFormField(
        //           validator: (e) {
        //             if (e.isEmpty) {
        //               return "Silahkan isi username";
        //             } else {
        //               return null;
        //             }
        //           },
        //           onSaved: (e) => username = e,
        //           decoration: InputDecoration(
        //             labelText: "Username",
        //           ),
        //         ),
        //         TextFormField(
        //           obscureText: _secureText,
        //           onSaved: (e) => password = e,
        //           decoration: InputDecoration(
        //             labelText: "Password",
        //             suffixIcon: IconButton(
        //               icon: Icon(_secureText
        //                   ? Icons.visibility_off
        //                   : Icons.visibility),
        //               onPressed: showHide(),
        //             ),
        //           ),
        //         ),
        //         MaterialButton(
        //           padding: EdgeInsets.all(25.0),
        //           color: Colors.black,
        //           onPressed: () {
        //             check();
        //           },
        //           child: Text(
        //             "Login",
        //             style: TextStyle(color: Colors.white),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // );
        break;
      case LoginStatus.signIn:
        return MenuUser(signOut);
        break;
    }
  }
}
