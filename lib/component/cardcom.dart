import 'dart:convert';

import 'package:app_test/page/DashboardPage.dart';
import 'package:app_test/page/Votepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../page/VoteSelectPage.dart';
import 'package:http/http.dart' as Http;

import 'encrypt.dart';

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
  final List<dynamic> winner;
  final int allvoter;
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
    required this.winner,
    required this.allvoter,
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
                  final encrypto = EncryptData.encryptAES(voter);
                  final response = await Http.get(Uri.parse(
                      'https://e-voting-api-kmutnb-ac-th.vercel.app/didVoted/$TextTitle/$encrypto'));
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
                    Column(
                      children: [
                        Text("Start : " + StaDate.toString().substring(0, 16),
                            style: TextStyle(color: Colors.white70)),
                        Text("End   : " + EndDate.toString().substring(0, 16),
                            style: TextStyle(color: Colors.white70))
                      ],
                    ),
                    // page
                    //     ? Text("Start : " + StaDate.toString() + " ",
                    //         style: TextStyle(color: Colors.white70))
                    //     : Text("End : " + EndDate.toString(),
                    //         style: TextStyle(color: Colors.white70))
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
    String s = "";
    String ts = "";
    String tn = "";
    const initialValue = 0.0;
    final resultvoted = score.fold<double>(
        initialValue, (previousValue, element) => previousValue + element);
    if (winner.length > 1) {
      s = ",";
    }
    if (StaDate.minute < 10) {
      ts = "0";
    }
    if (EndDate.minute < 10) {
      tn = "0";
    }
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(child: Text(TextTitle)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (Descrip != "") (Text(Descrip + "\n")),
              Container(
                child: Row(
                  children: [
                    Text("winner : "),
                    Expanded(
                      child: Row(
                        children: winner
                            .map((e) => Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Text(e + s),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    )
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("All Voter : " + allvoter.toString()),
                      SizedBox(
                        height: 10,
                      ),
                      Text("All Voted : " + resultvoted.toInt().toString()),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Candidate"),
                Text("Score"),
              ]),
              SizedBox(
                height: 13,
              ),
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
                              child: Text("  " + e + "\n"),
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
                                Text(e.toString() + "  " + "\n"),
                              ],
                            ))
                        .toList(),
                  ),
                ],
              )),
              // Text("${alldata.length}"),
              Text("Start : " + StaDate.toString().substring(0, 16) + "\n"),
              Text("End   : " + EndDate.toString().substring(0, 16) + "\n"),
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
