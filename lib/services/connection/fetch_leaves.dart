// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models/uri_paths.dart';

Future<dynamic> getFacultyLeaveRequestsFromServerMasterMode() async {
  try {
    String userName = "pplgovt-dmn-dd@nic.in";
    String userPassword = 'collegeadmin@1234';
    String dbname = 'college';
    String collegeId = '13';
    String str = '1';

    var response = await http.post(
      Uri.parse('$baseUriLocal$masterUriStart$masterUriFetchLeave'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user': userName,
        'password': userPassword,
        'dbname': 'dbname',
        'collegeId': collegeId,
        'str': str
      }),
    );

    if (response.statusCode == 200) {
      var respBody = jsonDecode(response.body);
      if (respBody['message'].toString().toLowerCase() == 'success') {
        if (kDebugMode) {
          log('master mode faculty leaves');
          log(response.body);
        }
      }
    }

    if (response.statusCode == 200) {
      var respBody = jsonDecode(response.body);

      if (kDebugMode) {
        log(response.body);
      }
    }
    return [
      {
        "leaveRequestId": 1,
        "leaveRequestName": 2,
      }
    ];
  } catch (e) {
    if (kDebugMode) {
      log('error fetching faculty leave requests master mode');
      log(e.toString());
    }
  }
}

Future<dynamic> getFacultyLeaveRequestsFromServerHeadMode() async {
  try {
    return [
      {
        "leaveRequestId": 1,
        "leaveRequestName": 2,
      }
    ];
  } catch (e) {
    if (kDebugMode) {
      log('error fetching faculty leave requests head mode');
      log(e.toString());
    }
  }
}
