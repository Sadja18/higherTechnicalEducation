import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  static const routenName = "screen-common-test";
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
        child: const Text("GO crazy"),
      ),
    );
  }
}
