import 'package:app_test/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String user = "";
  String pass = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login page".toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.blue),
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
                      user = value;
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
                      pass = value;
                    },
                    obscureText: true,
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
            const SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 27, vertical: 14),
                color: Colors.blue,
                onPressed: signIn,
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

  Future signIn() async {
    SnackBar snackBar = SnackBar(
      content: Text(
        "Login...",
        style: TextStyle(fontSize: 36, color: Colors.black),
      ),
      backgroundColor: Colors.pinkAccent,
      duration: Duration(milliseconds: 1800),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    User? currentUser;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: user, password: pass)
        .catchError((onError) {
      final snackBar = SnackBar(
        content: Text(
          "Error Occured : " + onError.toString(),
          style: TextStyle(fontSize: 36, color: Colors.black),
        ),
        backgroundColor: Colors.pinkAccent,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    // if (currentUser != null) {
    //   await FirebaseFirestore.instance
    //       .collection("users")
    //       .doc(currentUser!.uid)
    //       .get()
    //       .then((snap) {
    //     if (!snap.exists) {
    //       Navigator.push(
    //           context, MaterialPageRoute(builder: (context) => MainPage()));
    //     } else {
    //       SnackBar snackBar = SnackBar(
    //         content: Text(
    //           "you are not admin",
    //           style: TextStyle(fontSize: 36, color: Colors.black),
    //         ),
    //         backgroundColor: Colors.pinkAccent,
    //         duration: Duration(milliseconds: 1800),
    //       );
    //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //     }
    //   });
    // }
  }
}