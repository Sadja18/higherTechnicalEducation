// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<dynamic> getFacultyLeaveRequestsFromServerMasterMode() async {
  try {
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
