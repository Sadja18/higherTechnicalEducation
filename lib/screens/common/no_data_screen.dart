// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import './which_user.dart';

class NoDataExists extends StatefulWidget {
  static const routeName = "common-screen-nodatafound";
  const NoDataExists({Key? key}) : super(key: key);

  @override
  State<NoDataExists> createState() => _NoDataExistsState();
}

class _NoDataExistsState extends State<NoDataExists> {
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
            "Error",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed(WhichUser.routeName);
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(),
        alignment: Alignment.topCenter,
        child: const Text("Relevant Data Not Found"),
      ),
    );
  }
}
