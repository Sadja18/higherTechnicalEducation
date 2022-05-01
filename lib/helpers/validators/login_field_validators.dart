/// return value
/// -1 means password is empty
/// 0 means username is empty
/// 1 means they have values
int loginFieldValidator(String enteredUserName, String enteredUserPassword) {
  if (enteredUserName.isEmpty || enteredUserName == "") {
    return 0;
  } else {
    if (enteredUserPassword.isEmpty || enteredUserPassword == "") {
      return -1;
    } else {
      return 1;
    }
  }
}
