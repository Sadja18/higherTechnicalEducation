import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../helpers/validators/username_validators.dart';
import '../../helpers/validators/login_field_validators.dart';
import '../../services/connection/base.dart';
import '../../screens/common/dashboard_screen.dart';
import '../../services/database/handler.dart';

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
  late String userType;

  void showAlertBox(String message) async {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const SizedBox(
              height: 0,
            ),
            titlePadding: const EdgeInsets.all(0),
            content: Container(
              decoration: const BoxDecoration(),
              width: MediaQuery.of(context).size.width * 0.80,
              height: MediaQuery.of(context).size.height * 0.20,
              alignment: Alignment.topCenter,
              child: Text(message),
            ),
          );
        });
  }

  String preRequestValidation(enteredUserName, enteredUserPassword) {
    int validateState =
        loginFieldValidator(enteredUserName, enteredUserPassword);
    String message = "";
    switch (validateState) {
      case -1:
        message = "Passsword Field cannot be empty";
        break;
      case 0:
        message = "User Name Field cannot be empty";
        break;
      case 1:
        message = "Valid values";
        break;
      default:
        message = "";
        break;
    }
    return message;
  }

  void _onClickSubmit() async {
    var loginStatus = 0;
    String enteredUserName = _userNameController.text;
    String enteredUserPassword = _userPasswordController.text;

    String alertMessage0 =
        preRequestValidation(enteredUserName, enteredUserPassword);
    if (kDebugMode) {
      log('upass');
      log(enteredUserPassword);
      // log('uname');
      log(enteredUserName);
      // log("validation");
      // log(userType);
      // log("usertype");
      // log(alertMessage0);
    }

    if (alertMessage0 != "" &&
        alertMessage0.isNotEmpty &&
        alertMessage0 != 'Valid values') {
      showAlertBox(alertMessage0);
    } else {
      var userNameValidation;
      switch (userType) {
        case "master":
          userNameValidation = checkIfUserNameIsEmail(enteredUserName);
          if (userNameValidation == 1) {
            loginStatus = await tryLogin(enteredUserName, enteredUserPassword);
            if (loginStatus == 1) {
              Navigator.of(context).popAndPushNamed(DashboardScreen.routeName);
            } else {
              alertMessage0 = "Login failed.";
              showAlertBox(alertMessage0);
            }
          } else {
            alertMessage0 = "User Name should be an email";
            showAlertBox(alertMessage0);
          }

          break;
        case "head":
          userNameValidation = checkIfUserNameIsEmail(enteredUserName);
          if (userNameValidation == 1) {
            loginStatus = await tryLogin(enteredUserName, enteredUserPassword);
            if (loginStatus == 1) {
              Navigator.of(context).popAndPushNamed(DashboardScreen.routeName);
            } else {
              alertMessage0 = "Login Failed. Please try later";
              showAlertBox(alertMessage0);
            }
          } else {
            alertMessage0 = "User Name should be an email";
            showAlertBox(alertMessage0);
          }
          break;
        case "faculty":
          userNameValidation = checkIfUserNameIsEmail(enteredUserName);
          if (userNameValidation == 1) {
          } else {
            alertMessage0 = "User Name should be an email";
            showAlertBox(alertMessage0);
          }
          break;
        case "ntStaff":
          userNameValidation = checkIfUserNameIsEmail(enteredUserName);
          if (userNameValidation == 1) {
          } else {
            alertMessage0 = "User Name should be an email";
            showAlertBox(alertMessage0);
          }
          break;
        case "parent":
          userNameValidation = checkIfUserNameIsPhone(enteredUserName);
          if (userNameValidation == 1) {
            if (kDebugMode) {
              log('sending parent login request');
              loginStatus =
                  await tryLogin(enteredUserName, enteredUserPassword);

              if (loginStatus == 1) {
                Navigator.of(context)
                    .popAndPushNamed(DashboardScreen.routeName);
              } else {
                alertMessage0 = "Login failed.";
                showAlertBox(alertMessage0);
              }
              if (kDebugMode) {
                log('save flag');
                log(loginStatus.toString());
              }
            }
          } else {
            alertMessage0 = "User Name should be a phone number";
            showAlertBox(alertMessage0);
          }
          break;
        case "student":
          userNameValidation =
              checkIfUserNameIsStudentUserName(enteredUserName);
          if (userNameValidation == 1) {
            loginStatus = await tryLogin(enteredUserName, enteredUserPassword);
            if (loginStatus == 1) {
              Navigator.of(context).popAndPushNamed(DashboardScreen.routeName);
            } else {
              showAlertBox(
                  "Server Error occurred during login.Please retry later");
            }
          } else {
            alertMessage0 = "User Name should be an student admission id";
            showAlertBox(alertMessage0);
          }
          break;
        default:
          if (kDebugMode) {
            log(userType);
          }
      }
    }
  }

  dynamic tryLogin(enteredUserName, enteredUserPassword) async {
    // var response;
    var saveFlag = 0;

    switch (userType) {
      case "student":
        saveFlag =
            await sendStudentLoginRequest(enteredUserName, enteredUserPassword);
        break;
      case "master":
        saveFlag =
            await sendMasterLoginRequest(enteredUserName, enteredUserPassword);
        break;

      case "head":
        saveFlag =
            await sendHeadLoginRequest(enteredUserName, enteredUserPassword);
        break;
      case "parent":
        saveFlag =
            await sendParentLoginRequest(enteredUserName, enteredUserPassword);
        break;
      default:
        break;
    }
    return saveFlag;
  }

  @override
  void initState() {
    setState(() {
      userType = widget.userType;
    });
    super.initState();
  }

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
                            alignment: Alignment.center,
                            child: TextFormField(
                              // keyboardAppearance:,
                              textAlign: TextAlign.left,
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
                              textAlign: TextAlign.left,
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
                // log("userName");
                // log(_userNameController.text);
                // log('password');
                // log(_userPasswordController.text);
              }
              // DBProvider.db.dynamicRead(
              //     "ALTER TABLE Master ADD masterId INTEGER PRIMARY KEY;", []);

              _onClickSubmit();
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
