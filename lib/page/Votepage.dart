import 'dart:convert';

import 'package:app_test/component/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/cardcom.dart';
import 'package:http/http.dart' as Http;

class VotePage extends StatefulWidget {
  VotePage({Key? key}) : super(key: key);

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  final user = GlobalValues.getUsernameLoggedin();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Container(),
      body: RefreshIndicator(
        onRefresh: () async {
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("EventCreate")
                .orderBy('Start Date')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return !snapshot.hasData
                  ? Center(
                      child: Center(
                      child: Text("Vote Not Found"),
                    ))
                  : ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        List<dynamic> vot = data['Voter'];
                        Timestamp ts = data['Start Date'] as Timestamp;
                        Timestamp te = data['End Date'] as Timestamp;
                        bool check;
                        DateTime sdate = ts.toDate();
                        DateTime edate = te.toDate();
                        check = DateTime.now().isAfter(sdate) &&
                                DateTime.now().isBefore(edate)
                            ? true
                            : false;
                        // T? cast<T>(x) => x is T ? x : null;
                        // var x = getUserVote(data['Event Name'], user!);

                        // bool? CT = cast<bool>(x);
                        for (int i = 0; i < vot.length; i++) {
                          if (data['Voter'][i] == user &&
                              DateTime.now().isBefore(edate)) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: CardExpo(
                                TextTitle: data['Event Name'],
                                Descrip: data['Description'],
                                check: check,
                                Candi: data['Candidate'],
                                score: data['Score'],
                                EndDate: edate,
                                StaDate: sdate,
                                voter: data['Voter'][i],
                                page: true,
                                winner: data['winner'],
                                allvoter: vot.length,
                              ),
                            );
                          }
                        }

                        return Container();
                      }).toList(),
                    );
            },
          ),
        ),
      ),
    );
  }

  Future getUserVote(String name, String voter) async {
    final response = await Http.get(Uri.parse(
        'https://e-voting-api-kmutnb-ac-th.vercel.app/didVoted/$name/$voter'));
    var data = jsonDecode(response.body);
    return data["voted"];
  }
}
