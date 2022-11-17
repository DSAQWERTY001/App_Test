import 'package:app_test/component/state.dart';
import 'package:app_test/page/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'page/Homepage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder<LoginUser>(
          future: LoginState(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.Status == "success") {
                return MyHomePage(title: "title");
              }
              return LoginPage();
            } else {
              return LoginPage();
            }
          },
        ),

        // body: StreamBuilder<User?>(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       // print(FirebaseAuth.instance.currentUser!.uid);
        //       // print(FirebaseAuth.instance.currentUser!.email);
        //       // Duration(
        //       //   seconds: 50,
        //       // );
        //       return MyHomePage(title: "title");
        //     } else {
        //       return LoginPage();
        //     }
        //   },
        // ),
      );
}
