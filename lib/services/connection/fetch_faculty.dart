import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../models/uri_paths.dart';

Future<dynamic> getFacultyDataFromServerMasterMode() async {
  try {
    var userName = 'pplgovt-dmn-dd@nic.in';
    var userPassword = 'collegeadmin@1234';
    var dbname = 'college';
    var collegeId = '13';
    var requestBodyMap = {
      'userName': userName,
      'userPassword': userPassword,
      'dbname': dbname,
      'collegeId': collegeId,
      'str': '1'
    };

    var response = await http.post(
        Uri.parse('$baseUriLocal$masterUriStart$masterUriFetchFacultyProfile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBodyMap));
    if (response.statusCode == 200) {
      var respBody = jsonDecode(response.body);
      if (respBody['message'].toString().toLowerCase() == 'success') {
        if (kDebugMode) {
          log("master faculty profile response.body");
        }
        return respBody['data'];
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log('master fetch faculty');
      log(e.toString());
    }
  }
}
