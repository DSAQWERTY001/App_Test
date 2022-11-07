import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VotePage extends StatefulWidget {
  VotePage({Key? key}) : super(key: key);

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  final user = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Vote Page'),
            ],
          ),
        ),
      ),
    );
  }
}
