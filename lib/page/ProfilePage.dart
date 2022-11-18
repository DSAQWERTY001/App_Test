import 'package:app_test/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/state.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LoginUser>(
        future: LoginState(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: CircleAvatar(
                        // backgroundColor: Colors.black,
                        backgroundImage:
                            AssetImage("asserts/images/profile-picture.jpeg"),
                        // child: Text("data"),
                        radius: 75,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      snapshot.data!.userInfo["firstname_en"] +
                          " " +
                          snapshot.data!.userInfo["lastname_en"],
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Username : " + snapshot.data!.userInfo["username"],
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Email : " + snapshot.data!.userInfo["email"],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      // body: Container(
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text("Profile Page"),
      //         SizedBox(
      //           height: 25,
      //         ),
      //         ClipRRect(
      //           borderRadius: BorderRadius.circular(25),
      //           child: FlatButton(
      //             padding: EdgeInsets.symmetric(horizontal: 27, vertical: 17),
      //             color: Colors.blue,
      //             onPressed: () async {
      //               GlobalValues.setCheckUser(false);
      //               Navigator.push(context,
      //                   MaterialPageRoute(builder: (context) => MainPage()));
      //             },
      //             child: Text(
      //               "logout".toUpperCase(),
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
