import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserLoginWidget extends StatefulWidget {
  final String userType;
  const UserLoginWidget({Key? key, required this.userType}) : super(key: key);

  @override
  State<UserLoginWidget> createState() => _UserLoginWidgetState();
}

class _UserLoginWidgetState extends State<UserLoginWidget> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _userPasswordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      // dec
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.40,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 241, 234, 234),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Table(
            children: [
              // for username
              TableRow(
                children: [
                  TableCell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.15,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        vertical: 4.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "User Name",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.purpleAccent.shade400,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.purpleAccent.shade100,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              // keyboardAppearance:,
                              decoration: InputDecoration(
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                constraints: BoxConstraints.tightForFinite(
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                ),
                              ),
                              controller: _userNameController,
                              autofocus: false,
                              focusNode: _userNameFocusNode,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // for user Password
              TableRow(
                children: [
                  TableCell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.15,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        vertical: 4.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "User Password",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.purpleAccent.shade400,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.purpleAccent.shade100,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              decoration: InputDecoration(
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                constraints: BoxConstraints.tightForFinite(
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  width:
                                      MediaQuery.of(context).size.width * 0.90,
                                ),
                                suffixIcon: InkWell(
                                  // color: Colors.white,
                                  onTap: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(),
                                    width: MediaQuery.of(context).size.width *
                                        0.20,
                                    alignment: Alignment.centerRight,
                                    child: Icon(_obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                ),
                              ),
                              obscureText: _obscurePassword,
                              controller: _userPasswordController,
                              autofocus: false,
                              focusNode: _userPasswordFocusNode,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () {
              if (kDebugMode) {
                log(widget.userType.toString());
                log("userName");
                log(_userNameController.text);
                log('password');
                log(_userPasswordController.text);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[
                    Color(0xfff21bce),
                    Color(0xff826cf0),
                  ],
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.05,
              child: const Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
