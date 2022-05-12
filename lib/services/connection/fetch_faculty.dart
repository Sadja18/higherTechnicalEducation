import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:higher/services/database/handler.dart';
import 'package:http/http.dart' as http;

import '../../models/uri_paths.dart';

Future<dynamic> getFacultyDataFromDatabaseMasterMode(int deptId) async {
  try {
    var response = await DBProvider.db
        .dynamicRead("SELECT * FROM Faculty WHERE deptId=?;", [deptId]);
    if (kDebugMode) {
      log(response.toString());
    }
    if (response.isNotEmpty) {
      var data = response.toList();
      return data;
    } else {
      return [];
    }
  } catch (e) {
    if (kDebugMode) {
      log('master fetch faculty');
      log(e.toString());
    }
  }
}
