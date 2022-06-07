RegExp emailRegex = RegExp(
    r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$",
    multiLine: false,
    caseSensitive: false);

/// \d{10} checks if the string length is 10 digits
/// \d{11} checks if the string length is 11 digits
/// In India, possible mobile number length can be 10 or 11
/// sample user login
/// 9876565643; parent@1234
RegExp phoneRegex = RegExp(r'^[6-9]\d{9}|\d{10}|\d{11}$', multiLine: false);

RegExp base64EncodeRegex = RegExp(
    r'^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$',
    multiLine: true);

/// return value == 1 means, the entered user name is a valid phone number
int checkIfUserNameIsPhone(String enteredUserName) {
  if (phoneRegex.hasMatch(enteredUserName)) {
    return 1;
  } else {
    return 0;
  }
}

/// return value == 1 means that the entered user name is a valid email Id
int checkIfUserNameIsEmail(String enteredUserName) {
  if (emailRegex.hasMatch(enteredUserName)) {
    return 1;
  } else {
    return 0;
  }
}

///  return value == 1 means that the entered user name is a student userName
int checkIfUserNameIsStudentUserName(String enteredUserName) {
  if (emailRegex.hasMatch(enteredUserName) ||
      phoneRegex.hasMatch(enteredUserName)) {
    return 0;
  } else {
    return 1;
  }
}
