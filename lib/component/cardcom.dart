import 'dart:convert';

import 'package:app_test/page/DashboardPage.dart';
import 'package:app_test/page/Votepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../page/VoteSelectPage.dart';
import 'package:http/http.dart' as Http;

class CardExpo extends StatelessWidget {
  final String TextTitle;
  final String Descrip;
  final bool check;
  final DateTime StaDate;
  final DateTime EndDate;
  final List<dynamic> Candi;
  final List<dynamic> score;
  final String voter;
  final bool page;
  const CardExpo({
    Key? key,
    required this.TextTitle,
    required this.Descrip,
    required this.check,
    required this.StaDate,
    required this.EndDate,
    required this.Candi,
    required this.score,
    required this.voter,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool checkCurVoter = false;
    return ListView.builder(
      primary: false,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 8.0,
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.amber),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          margin: new EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            child: ListTile(
                enabled: check,
                // enabled: true,
                onTap: () async {
                  // Center(
                  //   child: FutureBuilder<Album>(
                  //     future: getUserVote(
                  //       TextTitle,voter
                  //     ),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         checkvote = true;
                  //       } else {
                  //         checkvote = false;
                  //       }
                  //       return checkvote;
                  //       // By default, show a loading spinner.
                  //     },
                  //   ),
                  // );
                  // FutureBuilder<Album>(
                  //   future: getUserVote(TextTitle, voter),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       checkvote = snapshot.data!.title;
                  //       print(snapshot.data!.title);
                  //     }
                  //     return CircularProgressIndicator();
                  //   },
                  // );
                  final response = await Http.get(Uri.parse(
                      'https://e-voting-api-kmutnb-ac-th.vercel.app/didVoted/$TextTitle/$voter'));
                  if (DateTime.now().isAfter(EndDate) ||
                      jsonDecode(response.body)["voted"]) {
                    FirebaseFirestore.instance.collection('EventCreate');
                    showLoadingDialog(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VoteSelect(
                                data: Candi,
                                Eventname: TextTitle,
                                Descrip: Descrip,
                                user: voter,
                              )),
                    );
                  }
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(
                                width: 1.0, color: Colors.amber))),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Status\n  ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white)),
                      WidgetSpan(
                          child: Icon(
                        Icons.fiber_manual_record,
                        color: DateTime.now().isBefore(StaDate)
                            ? Colors.red
                            : page
                                ? Colors.green
                                : Colors.blueGrey.shade300,
                      ))
                    ]))
                    // child: Icon(
                    //   Icons.autorenew,
                    //   color: Colors.white,
                    // ),
                    ),
                title: Text(
                  TextTitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Row(
                  children: <Widget>[
                    // Icon(Icons.linear_scale, color: Colors.yellowAccent),
                    Text(Descrip, style: TextStyle(color: Colors.white70))
                  ],
                ),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Colors.white, size: 30.0)),
          ),
        );
      },
    );
  }

  Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(TextTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(Descrip + "\n"),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: Candi.map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(e + "\n"),
                            ),
                            SizedBox(
                              width: 40,
                            )
                          ],
                        )).toList(),
                  ),
                  Column(
                    children: score
                        .map((e) => Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(e.toString() + "\n"),
                              ],
                            ))
                        .toList(),
                  ),
                ],
              )),
              // Text("${alldata.length}"),
              Text(StaDate.toString() + "\n"),
              Text(EndDate.toString() + "\n"),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Future<Album> getUserVote(String name, String voter) async {
//   final response = await Http.get(Uri.parse(
//       'https://e-voting-api-kmutnb-ac-th.vercel.app/didVoted/$name/$voter'));

//   if (response.statusCode == 200) {
//     return Album.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed to load album');
//   }
// }

// class Album {
//   final bool title;

//   const Album({
//     required this.title,
//   });

//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       title: json['voted'],
//     );
//   }
// }
