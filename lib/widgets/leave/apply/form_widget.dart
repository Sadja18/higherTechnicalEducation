import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../services/connection/faculty_mode_fetches.dart';
import '../../../helpers/controllers/common/user_session_db_requests.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../common/date_select.dart';

class ApplyForLeaveWidget extends StatefulWidget {
  final String userType;
  const ApplyForLeaveWidget({Key? key, required this.userType})
      : super(key: key);

  @override
  State<ApplyForLeaveWidget> createState() => _ApplyForLeaveWidgetState();
}

class _ApplyForLeaveWidgetState extends State<ApplyForLeaveWidget> {
  TextEditingController _reasonController = TextEditingController();
  final FocusNode _reasonNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  late File _image;
  late var selectedLeaveType = {};
  late var selectedLeaveSession;
  String _image64Code = "";
  String _selectedEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _selectedStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  double dateDiff = DateTime.now().difference(DateTime.now()).inHours / 24;
  // late List leaveTypesData;

  void uploadedImagePreview() async {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const SizedBox(
              height: 0,
            ),
            titlePadding: const EdgeInsets.all(0),
            // contentPadding: const EdgeInsets.all(0),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.90,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Image(
                  image:
                      Image.memory(const Base64Decoder().convert(_image64Code))
                          .image,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            ),
          );
        });
  }

  Future getImageFromCamera() async {
    var image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      if (image.path.isNotEmpty) {
        setState(() {
          _image = File(image.path);
        });
        List<int> imageBytes = await File(image.path).readAsBytes();
        String img64 = base64Encode(imageBytes);

        if (img64.isNotEmpty && img64 != "") {
          setState(() {
            _image64Code = img64;
          });
        }
      }

      if (kDebugMode) {
        print(_image64Code.toString());
      }
    }
  }

  Future getImagefromGallery() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (image.path.isNotEmpty) {
        setState(() {
          _image = File(image.path);
        });
        List<int> imageBytes = await File(image.path).readAsBytes();
        String img64 = base64Encode(imageBytes);

        if (img64.isNotEmpty && img64 != "") {
          setState(() {
            _image64Code = img64;
          });
        }
      }

      if (kDebugMode) {
        print(_image64Code.toString());
      }
    }
  }

  Widget tableViewField(String fieldName, Widget fieldWidget) {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      decoration: const BoxDecoration(),
      width: MediaQuery.of(context).size.width * 0.90,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FractionColumnWidth(0.35),
          1: FractionColumnWidth(0.65),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              TableCell(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context),
                  child: Text(
                    fieldName,
                    style: const TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: fieldWidget,
              ),
            ],
          )
        ],
      ),
    );
  }

  String textFieldName() {
    if (widget.userType == 'student') {
      return "Reason:";
    } else {
      return "Remark:";
    }
  }

  double dateDiffCalc() {
    var to = DateTime.parse(_selectedEndDate);
    var from = DateTime.parse(_selectedStartDate);
    var dateDifference = (to.difference(from).inHours / 24);
    // if(dateDifference)
    dateDifference = dateDifference + 1;
    setState(() {
      dateDiff = dateDifference;
    });
    return dateDifference;
  }

  void startDateSelector(String? selectedDate) {
    setState(() {
      _selectedStartDate = selectedDate!;
    });
    dateDiffCalc();
    // getALlLeaveAllocationsForCurrentFacultyVoidMode();
  }

  void endDateSelector(String? selectedDate) {
    setState(() {
      _selectedEndDate = selectedDate!;
    });
    dateDiffCalc();
  }

  Widget showAttachment() {
    return FutureBuilder(
        future: whichUserLoggedIn(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 0,
            );
          } else {
            if (snapshot.hasError ||
                snapshot.hasData != true ||
                snapshot.data == null ||
                [1, 2, 3, 4, 5, 6].contains(snapshot.data) == false ||
                snapshot.data == false) {
              return const SizedBox(
                height: 0,
              );
            } else {
              var userType = snapshot.data;
              switch (userType) {
                case 6:
                  return tableViewField(
                    "Attachment:",
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FractionColumnWidth(0.40),
                          1: FractionColumnWidth(0.40)
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          getImagefromGallery();
                                        },
                                        child: const Icon(
                                          Icons.browse_gallery_outlined,
                                          size: 35,
                                          color: Colors.purple,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          getImageFromCamera();
                                        },
                                        child: const Icon(
                                          Icons.add_a_photo_outlined,
                                          size: 35,
                                          color: Colors.purple,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TableCell(
                                child: (_image64Code == "")
                                    ? const SizedBox(
                                        height: 0,
                                      )
                                    : InkWell(
                                        onTap: () {
                                          if (kDebugMode) {
                                            print("Show Preview");
                                          }
                                          uploadedImagePreview();
                                        },
                                        child: const Text(
                                          "Preview",
                                          style: TextStyle(
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                default:
                  return const SizedBox(
                    height: 0,
                  );
              }
            }
          }
        });
  }

  Widget showLeaveType() {
    return FutureBuilder(
      future: whichUserLoggedIn(),
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError ||
            snapshot.hasData != true ||
            snapshot.data == null ||
            snapshot.data == false ||
            [1, 2, 3, 4, 5, 6].contains(snapshot.data) == false) {
          return const SizedBox(
            height: 0,
          );
        } else {
          return tableViewField(
              "Leave Type",
              InkWell(
                onTap: () {
                  showLeaveSelectionDialog();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: MediaQuery.of(context).size.width * 0.60,
                    alignment: Alignment.center,
                    child: const Text(
                      "Select Leave Type",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ));
        }
      },
    );
  }

  void leaveTypeCallBack(Map selectedLeaveTypeFromChild, String leaveSession) {
    if (kDebugMode) {
      log("Selection values");
      log(selectedLeaveType.toString());
      log(leaveSession);
    }
    setState(() {
      selectedLeaveType = selectedLeaveTypeFromChild;
      selectedLeaveSession = leaveSession;
    });
    Navigator.of(context).pop();
  }

  void showLeaveSelectionDialog() async {
    var leaveTypeData = await getALlLeaveAllocationsForCurrentFacultyVoidMode();
    if (leaveTypeData != null && leaveTypeData.isNotEmpty) {
      return showDialog(
          context: context,
          builder: (BuildContext _) {
            return AlertDialog(
              title: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Colors.purpleAccent),
                child: const Text(
                  "Leave Type",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              titlePadding: const EdgeInsets.all(0.0),
              contentPadding: const EdgeInsets.all(0.0),
              content: LeaveTypeDropdown(
                  leaveTypes: leaveTypeData,
                  leaveTypeCallBack: leaveTypeCallBack),
            );
          });
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext _) {
            return AlertDialog(
              title: const Text(""),
              content: Container(
                alignment: Alignment.center,
                child: const Text(
                  "No Leave Allocation found.\n"
                  "Please contact the administrator",
                ),
              ),
            );
          });
    }
  }

  Future<dynamic> getALlLeaveAllocationsForCurrentFacultyVoidMode() async {
    var startDate = _selectedStartDate;
    var dateDifference = dateDiff + 1;
    var data =
        await getLeaveAllocationsForCurrentFaculty(startDate, dateDifference);
    if (data != null && data.isNotEmpty) {
      return data;
    }
  }

  // Widget leaveTypeDropdownFuture() {
  //   var startDate = _selectedStartDate;
  //   var dateDifference = dateDiff + 1;
  //   return FutureBuilder(
  //     future: getLeaveAllocationsForCurrentFaculty(startDate, dateDifference),
  //     builder: (BuildContext c, AsyncSnapshot s) {
  //       if (s.connectionState == ConnectionState.waiting) {
  //         return const SizedBox(
  //           child: CircularProgressIndicator.adaptive(),
  //         );
  //       } else {
  //         if (s.hasError ||
  //             s.hasData != true ||
  //             s.data == null ||
  //             s.data == false ||
  //             s.data.isEmpty) {
  //           return const SizedBox(
  //             height: 0,
  //           );
  //         } else {
  //           var leaveTypeData = s.data;
  //           return;
  //         }
  //       }
  //     },
  //   );
  // }
  void showAlertDialog(String message) async {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Center(child: Text("Invalid Entries")),
            content: Center(child: Text(message)),
          );
        });
  }

  void showSuccessDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext _) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return const AlertDialog(
            title: Text("Saving"),
            content: SizedBox(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        });
    // sleep(const Duration(seconds: 2));
    // Navigator.of(context).pop();
  }

  @override
  void initState() {
    // getALlLeaveAllocationsForCurrentFacultyVoidMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = kToolbarHeight;
    var formWidgetHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + appBarHeight + 1);
    return Container(
      decoration: const BoxDecoration(),
      height: formWidgetHeight,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            tableViewField(
              "From:",
              Container(
                alignment: Alignment.centerLeft,
                child: DateShowNew(dateSelector: startDateSelector),
              ),
            ),
            tableViewField(
              "To:",
              Container(
                alignment: Alignment.centerLeft,
                child: DateShowNew(dateSelector: endDateSelector),
              ),
            ),
            showLeaveType(),
            tableViewField(
                textFieldName(),
                Container(
                  alignment: Alignment.centerLeft,
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.purple,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    controller: _reasonController,
                    focusNode: _reasonNode,
                    onChanged: (value) {
                      if (kDebugMode) {
                        print("value change reason");
                        print(value.toString());
                      }
                    },
                  ),
                )),
            // showDays(),
            showAttachment(),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  if (kDebugMode) {
                    print("reason submitted");
                    // var reason = _reasonController.text;
                    // print(reason);
                    log(dateDiff.toString());
                    log(selectedLeaveSession.toString());
                    log(selectedLeaveType.toString());
                    log(DateTime.parse(_selectedEndDate)
                        .isBefore(DateTime.parse(_selectedStartDate))
                        .toString());
                    log(_reasonController.text.isEmpty.toString());
                    log(selectedLeaveType.isEmpty.toString());
                    log((selectedLeaveSession == "").toString());
                  }
                  var message = "";

                  if (DateTime.parse(_selectedEndDate)
                      .isBefore(DateTime.parse(_selectedStartDate))) {
                    message = "To date should be after From Date";
                    showAlertDialog(message);
                  } else {
                    if (_reasonController.text.isEmpty) {
                      message = "Reason should not be empty";
                      showAlertDialog(message);
                    } else {
                      if (selectedLeaveType.isEmpty ||
                          selectedLeaveSession == "") {
                        message = "Please select a leave type";
                        showAlertDialog(message);
                      } else {
                        showSuccessDialog();
                      }
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaveTypeDropdown extends StatefulWidget {
  final List leaveTypes;

  /// Map leaveType, String leaveSession
  final Function(Map, String) leaveTypeCallBack;
  const LeaveTypeDropdown({
    Key? key,
    required this.leaveTypes,
    required this.leaveTypeCallBack,
  }) : super(key: key);

  @override
  State<LeaveTypeDropdown> createState() => _LeaveTypeDropdownState();
}

class _LeaveTypeDropdownState extends State<LeaveTypeDropdown> {
  late var selectedLeaveType = {};
  late var selectedLeaveTypeName = "";
  late var selectedLeaveSession = "";
  late var selectedLeaveSessionName = "";
  List leaveSessions = ['Full Day', "First Half", "Second Half"];

  void setSelectedLeaveType(selection) {
    for (var leaveType in widget.leaveTypes) {
      if (leaveType['leaveTypeName'] == selection) {
        if (kDebugMode) {
          log("Selection in chgikdmabdvjc");
          log(leaveType.toString());
        }
        setState(() {
          selectedLeaveType = leaveType;
        });
      }
      // if(selec)
    }
    if (selectedLeaveType['isHalf'] != "true") {
      selectedLeaveSession = "full";
    }
  }

  void setSelectedLeaveSession(selection) {
    switch (selection) {
      case "First Half":
        setState(() {
          selectedLeaveSession = 'first';
        });
        break;
      case "Second Half":
        setState(() {
          selectedLeaveSession = 'second';
        });
        break;
      default:
        setState(() {
          selectedLeaveSession = 'full';
        });
    }
  }

  @override
  void initState() {
    // setState(() {
    // selectedLeaveTypeName = widget.leaveTypes[0]['leaveTypeName'];
    // selectedLeaveSessionName = leaveSessions[0];
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.30,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                DropdownButton(
                  // value: selectedLeaveSessionName,
                  hint: const Text("Select Leave Type"),
                  items: widget.leaveTypes
                      .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
                            child: Text(e['leaveTypeName']),
                            value: e['leaveTypeName'],
                          ))
                      .toList(),
                  onChanged: (selection) {
                    setSelectedLeaveType(selection.toString());
                    setState(() {
                      selectedLeaveTypeName = selection.toString();
                    });
                  },
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    selectedLeaveTypeName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            (selectedLeaveType.isNotEmpty &&
                    selectedLeaveType['isHalf'] != null &&
                    selectedLeaveType['isHalf'] == "true")
                ? Row(
                    children: [
                      DropdownButton(
                        // value: selectedLeaveSessionName,
                        hint: const Text("Select Duration"),
                        items: leaveSessions
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(
                                  e.toString(),
                                ),
                                value: e,
                              ),
                            )
                            .toList(),
                        onChanged: (selection) {
                          setSelectedLeaveSession(selection);
                          setState(() {
                            selectedLeaveSessionName = selection.toString();
                          });
                        },
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          selectedLeaveSessionName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                : const SizedBox(
                    height: 0,
                  ),
            (selectedLeaveSession.isEmpty || selectedLeaveType.isEmpty)
                ? const SizedBox(
                    height: 0,
                  )
                : InkWell(
                    onTap: () {
                      widget.leaveTypeCallBack(
                          selectedLeaveType, selectedLeaveSession);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
          ],
        ));
  }
}
