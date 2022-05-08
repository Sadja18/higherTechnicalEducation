import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

String nameFormatter(fName, mName, lName) {
  var name = '';
  if (fName != "") {
    name = name + toBeginningOfSentenceCase(fName).toString();
  }
  if (mName != "") {
    name = name + " " + toBeginningOfSentenceCase(mName)!;
  }
  if (lName != "") {
    name = name + " " + toBeginningOfSentenceCase(lName)!;
  }
  return name;
}
