import 'dart:convert';
import 'dart:math';

import 'package:app_test/component/cardcom.dart';
import 'package:app_test/component/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final user = GlobalValues.getUsernameLoggedin();
  var _onValue = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("EventCreate")
            // .doc("AdminCreate")
            // .collection(user!)
            // .where('Event Name', isEqualTo: "Testfromflutter")
            .orderBy('End Date')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    check = DateTime.now().isAfter(edate) ? true : false;
                    // var x = getUserVote(data['Event Name'], user!);
                    if (DateTime.now().isAfter(edate)) {
                      Future getscoreVote() async {
                        final responseScore = await Http.get(Uri.parse(
                            'https://e-voting-api-kmutnb-ac-th.vercel.app/getEventScore/${data['Event Name']}'));
                        final responseWinner = await Http.get(Uri.parse(
                            'https://e-voting-api-kmutnb-ac-th.vercel.app/winner/${data['Event Name']}'));
                        var data_score = jsonDecode(responseScore.body);
                        var data_winner = jsonDecode(responseWinner.body);
                        // print(data_score["score"]);
                        FirebaseFirestore.instance
                            .collection("EventCreate")
                            .doc(document.id)
                            .update({
                          'Score': data_score["score"],
                          'winner': data_winner["winner"]
                        });
                      }

                      getscoreVote();
                    }
                    // var a;
                    // print(x.then((value) => a = value));
                    // print(a);
                    // print(GlobalValues.getLoginStatus());
                    for (int i = 0; i < vot.length; i++) {
                      if (data['Voter'][i] == user &&
                          DateTime.now().isAfter(edate)) {
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
                            page: false,
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
    );
  }
}

// Future getUserVote(String name, String voter) async {
//   final response = await Http.get(Uri.parse(
//       'https://e-voting-api-kmutnb-ac-th.vercel.app/didVoted/$name/$voter'));
//   var data = jsonDecode(response.body);
//   if (response.statusCode == 200) {
//     Map data = jsonDecode(response.body);
//     return data["voted"];
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



// class VoteSelect extends StatefulWidget {
//   final List<dynamic> data;
//   const VoteSelect({Key? key, required this.data}) : super(key: key);

//   @override
//   State<VoteSelect> createState() => _VoteSelectState();
// }

// class _VoteSelectState extends State<VoteSelect> {
//   @override
//   Widget build(BuildContext context) {
//     SingingCharacter? _character = SingingCharacter.lafayette;
//     var _onValue = '';
//     final List<String> data_target =
//         widget.data.map((e) => e.toString()).toList();
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: Text("title"),
//         ),
//       ),
//       // body: Container(),
//       body: Container(
//         child: Column(
//           children: [
//             Text("data"),
//             // Expanded(
//             //     child: Column(
//             //   children: [
//             //     Text("data"),
//             //   ],
//             // )),
//             Expanded(
//               child: ListView.separated(
//                   // cacheExtent: 2,
//                   itemBuilder: (context, index) => Container(
//                         height: 40,
//                         child: RadioListTile(
//                           title: Text(widget.data[index]),
//                           value: data_target[index],
//                           groupValue: _onValue,
//                           onChanged: (value) {
//                             setState(() {
//                               _onValue = value.toString();
//                             });
//                           },
//                         ),
//                       ),
//                   separatorBuilder: (_, __) => SizedBox(
//                         height: 10,
//                       ),
//                   itemCount: widget.data.length),
//             ),
//             Row(
//                 // children: data.map((e) => ListTile(
//                 //       title: Text(e),
//                 //       leading: Radio<SingingCharacter>(
//                 //         groupValue: _character,
//                 //         onChanged: (SingingCharacter? value) {
//                 //           setState(() {
//                 //             _character = value;
//                 //           });
//                 //         },
//                 //       ),
//                 //     )),
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }
