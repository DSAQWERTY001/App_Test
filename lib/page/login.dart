import 'dart:convert';

import 'package:app_test/component/state.dart';
import 'package:app_test/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;

class LoginPage extends StatefulWidget {
  bool err;
  LoginPage({Key? key, required this.err}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String user = "";
  String pass = "";
  bool _passwordShow = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.err) {
        print(widget.err);
        final snackBar = SnackBar(
          content: Text(
            "Error : username or password invalid!",
          ),
          backgroundColor: Colors.pinkAccent,
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: CircleAvatar(
                // backgroundColor: Colors.black,
                backgroundImage: AssetImage("asserts/icons/BlLogo22.png"),
                // child: Text("data"),
                radius: 50,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 10,
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      GlobalValues.setUsername(value);
                    },
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                      ),
                      labelText: "username",
                      labelStyle: TextStyle(color: Colors.blue),
                      icon: Icon(
                        Icons.person_outline,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    onChanged: (value) {
                      GlobalValues.setPassword(value);
                    },
                    obscureText: !_passwordShow,
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                      ),
                      labelText: "password",
                      labelStyle: TextStyle(color: Colors.blue),
                      icon: Icon(
                        Icons.admin_panel_settings_outlined,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 45,
                ),
                Checkbox(
                  focusColor: Colors.blue,
                  activeColor: Colors.blue,
                  value: _passwordShow,
                  onChanged: (e) {
                    setState(() {
                      _passwordShow = e ?? false;
                    });
                  },
                ),
                Text(
                  "Show Password",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 27, vertical: 14),
                color: Colors.blue,
                onPressed: () async {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(),
                      ));
                },
                child: Text(
                  "login".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future signIn() async {
  //   SnackBar snackBar = SnackBar(
  //     content: Text(
  //       "Login...",
  //       style: TextStyle(fontSize: 36, color: Colors.black),
  //     ),
  //     backgroundColor: Colors.pinkAccent,
  //     duration: Duration(milliseconds: 1800),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   User? currentUser;
  //   await FirebaseAuth.instance
  //       .signInWithEmailAndPassword(email: user, password: pass)
  //       .catchError((onError) {
  //     final snackBar = SnackBar(
  //       content: Text(
  //         "Error Occured : " + onError.toString(),
  //         style: TextStyle(fontSize: 36, color: Colors.black),
  //       ),
  //       backgroundColor: Colors.pinkAccent,
  //       duration: Duration(seconds: 5),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   });
  // }
}

Future<LoginUser> LoginState() async {
  final response = await Http.post(
      Uri.parse('https://api.account.kmutnb.ac.th/api/account-api/user-authen'),
      headers: {
        'Authorization': 'Bearer WtGQihSKCcYOnNE7Z1IQNyz2betLpSIv',
      },
      body: {
        'scopes': 'student,personel',
        'username': GlobalValues.getUsername(),
        'password': GlobalValues.getPassword(),
      });
  var data = jsonDecode(response.body);
  return LoginUser.fromJson(jsonDecode(response.body));
}

class LoginUser {
  final String Status;
  final userInfo;

  LoginUser({
    required this.userInfo,
    required this.Status,
  });
  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      Status: json["api_status"],
      userInfo: json["userInfo"],
    );
  }
}
