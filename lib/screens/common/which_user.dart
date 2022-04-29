import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer';

class WhichUser extends StatelessWidget {
  static const routeName = '/';
  const WhichUser({Key? key}) : super(key: key);

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
            "Select User Type",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 0,
        ),
        child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FractionColumnWidth(0.50),
            1: FractionColumnWidth(0.50),
          },
          children: [
            TableRow(
              children: [
                TableCell(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: const Text("Head of Institution"),
                    ),
                  ),
                ),
                TableCell(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: const Text("Head of Institution"),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: const Text("Head of Institution"),
                    ),
                  ),
                ),
                TableCell(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: const Text("Head of Department"),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: const Text("Teaching Staff"),
                    ),
                  ),
                ),
                TableCell(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: const Text("Non-Teaching Staff"),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: const Text("Parent"),
                    ),
                  ),
                ),
                TableCell(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: const Text("Student"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
