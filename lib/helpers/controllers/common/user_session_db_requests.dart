import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../../services/database/common/users.dart';

/// return value 0 represents no logged in user
/// return value -1 represents multiple user sessions [in which case logout all of the user];
/// return value of 1 or a dictionary value of user data represents, a valid login session
Future<dynamic> isLoggedInSession() async {
  try {
    var resultList = await UserDBProvider.db.isSomeUserLoggedIn();

    if (resultList.length <= 0) {
      return 0;
    } else {
      if (resultList.length == 1) {
        var userDetails = resultList[0];

        if (userDetails['loginStatus'] == 1) {
          return userDetails;
        } else {
          return 0;
        }
      } else {
        return -1;
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log("error checking user login session");
      log(e.toString());
    }
  }
}

Future<void> endUserSession() async {
  try {
    await UserDBProvider.db.forceLogOutAllUsers();
  } catch (e) {
    if (kDebugMode) {
      log(e.toString());
    }
  }
}

/// it will return user type
Future<dynamic> whichUserLoggedIn() async {
  try {
    // return "master";
    // return "head";
    // return "faculty";
    // return "ntStaff";
    // return "parent";
    return "student";
  } catch (e) {
    if (kDebugMode) {
      log(e.toString());
    }
  }
}
