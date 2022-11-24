import 'package:app_test/component/%E0%B8%BAButton.dart';
import 'package:app_test/component/encrypt.dart';
import 'package:app_test/main.dart';
import 'package:app_test/page/DashboardPage.dart';
import 'package:app_test/page/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as Http;

class VoteSelect extends StatefulWidget {
  final String Eventname;
  final String Descrip;
  final List<dynamic> data;
  final String user;
  const VoteSelect(
      {Key? key,
      required this.data,
      required this.Eventname,
      required this.Descrip,
      required this.user})
      : super(key: key);

  @override
  State<VoteSelect> createState() => _VoteSelectState();
}

class _VoteSelectState extends State<VoteSelect> {
  var _onValue = "";
  String encrypto = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> data_target =
        widget.data.map((e) => e.toString()).toList();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            children: [Text("Vote Candidate Page")],
          ),
        ),
      ),
      // body: Container(),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Event Name : " + widget.Eventname,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Description : " + widget.Descrip,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                  // cacheExtent: 2,
                  itemBuilder: (context, index) => Container(
                        height: 40,
                        child: RadioListTile(
                          title: Text(data_target[index]),
                          value: data_target[index],
                          groupValue: _onValue,
                          onChanged: (value) {
                            setState(() {
                              _onValue = value.toString();
                            });
                          },
                        ),
                      ),
                  separatorBuilder: (_, __) => SizedBox(
                        height: 10,
                      ),
                  itemCount: data_target.length),
            ),
            Expanded(
                child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        RButton(
                            str: "Cancel",
                            press: () {
                              Navigator.pop(context);
                            },
                            bColor: Colors.red,
                            tColor: Colors.white),
                      ],
                    ),
                    Row(
                      children: [
                        RButton(
                            str: "Submit",
                            press: () async {
                              encrypto = EncryptData.encryptAES(widget.user);
                              if (_onValue == "") {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text(
                                        'Please Choose your chioce.'),
                                    content:
                                        const Text('AlertDialog description'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                showRepageDialog(context);
                                final response = await Http.get(Uri.parse(
                                    'https://e-voting-api-kmutnb-ac-th.vercel.app/addVote/${widget.Eventname}/$_onValue/$encrypto'));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyHomePage(title: "title")));
                              }
                            },
                            bColor: Colors.blue,
                            tColor: Colors.white)
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ))
            // Row(
            //     // children: data.map((e) => ListTile(
            //     //       title: Text(e),
            //     //       leading: Radio<SingingCharacter>(
            //     //         groupValue: _character,
            //     //         onChanged: (SingingCharacter? value) {
            //     //           setState(() {
            //     //             _character = value;
            //     //           });
            //     //         },
            //     //       ),
            //     //     )),
            //     ),
          ],
        ),
      ),

      // bottomNavigationBar: Stack(
      //   children: [
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         Row(
      //           children: [
      //             RButton(
      //                 str: "Cancle",
      //                 press: () {
      //                   Navigator.pop(context);
      //                 },
      //                 bColor: Colors.red,
      //                 tColor: Colors.white),
      //           ],
      //         ),
      //         Row(
      //           children: [
      //             RButton(
      //                 str: "Submit",
      //                 press: () async {
      //                   if (_onValue == "") {
      //                     showDialog(
      //                       context: context,
      //                       builder: (BuildContext context) => AlertDialog(
      //                         title: const Text('Please Choose your chioce.'),
      //                         content: const Text('AlertDialog description'),
      //                         actions: <Widget>[
      //                           TextButton(
      //                             onPressed: () => Navigator.pop(context),
      //                             child: const Text('OK'),
      //                           ),
      //                         ],
      //                       ),
      //                     );
      //                   } else {
      //                     showRepageDialog(context);
      //                     final response = await Http.get(Uri.parse(
      //                         'https://e-voting-api-kmutnb-ac-th.vercel.app/addVote/${widget.Eventname}/$_onValue/${widget.user}'));
      //                     Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                             builder: (context) =>
      //                                 MyHomePage(title: "title")));
      //                   }
      //                 },
      //                 bColor: Colors.blue,
      //                 tColor: Colors.white)
      //           ],
      //         ),
      //       ],
      //     ),
      //     SizedBox(
      //       height: 10,
      //     )
      //   ],
      // ),
    );
  }

  static Future<void> showRepageDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Please Wait a minute'),
        children: [
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
