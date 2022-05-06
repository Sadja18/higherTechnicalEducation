// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../handler.dart';

Future<dynamic> testForUserHomeScreen() async {
  try {
    return [1];
  } catch (e) {
    log('switch mywidget error');
    log(e.toString());
  }
}

Future<void> readTablesInDB() async {
  try {
    var dbQuery = "SELECT name FROM sqlite_master WHERE type ='table';";
    var params = [];

    var resultUsers = await DBProvider.db.dynamicRead(dbQuery, params);
    if (kDebugMode) {
      log('users db read');
      log(resultUsers.toString());
    }
  } catch (e) {
    if (kDebugMode) {
      log('test failed');
    }
  }
}
