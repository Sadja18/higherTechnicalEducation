import 'package:flutter/material.dart';
import '../leave_screen/master.dart';

class TestScreen extends StatelessWidget {
  static const routeName = "screen-common-test";
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xfff21bce),
                Color(0xff826cf0),
              ],
            ),
          ),
          alignment: Alignment.topCenter,
          child: const Text(
            "TestScreen",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(MasterApproveFacultyLeaveScreen.routeName);
            },
            child: const Text("data")),
      ),
    );
  }
}
