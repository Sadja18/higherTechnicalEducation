import 'package:flutter/material.dart';

class HeadLeaveScreen extends StatelessWidget {
  static const routeName = "/screen-head-leave";
  const HeadLeaveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Leave'),
        backgroundColor: Theme.of(context).primaryColor,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xfff21bce),
                Color(0xff826cf0),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: const Text("Approve Leave HoD mode"),
      ),
    );
  }
}
