import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';
import '../../common/image_assist.dart';

class StaffAttendanceWidget extends StatefulWidget {
  final List members;
  const StaffAttendanceWidget({Key? key, required this.members})
      : super(key: key);

  @override
  State<StaffAttendanceWidget> createState() => _StaffAttendanceWidgetState();
}

class _StaffAttendanceWidgetState extends State<StaffAttendanceWidget> {
  late List members;
  int currentRowIndex = 0;
  Map absenteeMemberData = {};
  List rowsTapped = [];

  ScrollController verticalBodyController =
      ScrollController(initialScrollOffset: 0.0);
  ScrollController verticalTitleController =
      ScrollController(initialScrollOffset: 0.0);
  ScrollController horizontalTitleController =
      ScrollController(initialScrollOffset: 0.0);
  ScrollController horizontalBodyController =
      ScrollController(initialScrollOffset: 0.0);

  Color getRowColor(rowIndex) {
    var empId = members[rowIndex]['employeeId'];
    if (absenteeMemberData[empId] && rowsTapped.contains(rowIndex)) {
      return Colors.red;
    }
    // else if (!absenteeMemberData[empId] && rowsTapped.contains(rowIndex)) {
    //   return Colors.green;
    // }
    else {
      return Colors.green;
    }
  }

  double verticalRowScrollOffset() {
    double scrollOffset = 120.0;
    if (currentRowIndex == 0.0) {
      return 0.0;
    } else {
      return scrollOffset * currentRowIndex;
    }
  }

  Widget tableViewField(String fieldName, Widget fieldWidget) {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      decoration: const BoxDecoration(),
      width: MediaQuery.of(context).size.width * 0.95,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FractionColumnWidth(0.40),
          1: FractionColumnWidth(0.60),
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

  Widget staffCellTopRow(rowIndex) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FractionColumnWidth(0.30),
          1: FractionColumnWidth(0.70),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              TableCell(
                child: AvatarGeneratorNew(
                  base64Code: members[rowIndex]['profilePic'],
                ),
              ),
              TableCell(
                child: Text(
                  members[rowIndex]['teacherName'],
                  style: const TextStyle(
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget rowsTitleBuilder(rowIndex) {
    return InkWell(
      // splashColor: Colors.purple,
      onTap: () {
        var currentEmpId = members[rowIndex]['employeeId'];
        if (kDebugMode) {
          log('mark $currentEmpId as ${!absenteeMemberData[currentEmpId]}');
        }
        setState(() {
          absenteeMemberData[currentEmpId] = !absenteeMemberData[currentEmpId];
          rowsTapped.add(rowIndex);
        });
      },
      child: Card(
        borderOnForeground: true,
        color: getRowColor(rowIndex),
        shape: RoundedRectangleBorder(
          // side: Border.symmetric(vertical: BorderSide.none),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        shadowColor: Colors.pinkAccent,
        elevation: 16.0,
        child: Container(
          margin: const EdgeInsets.only(
            top: 5.0,
          ),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: getRowColor(rowIndex),
            // border: Border.all(
            //   color: Colors.white,
            //   width: 3.0,
            // ),
            // borderRadius: BorderRadius.circular(
            //   10.0,
            // ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              staffCellTopRow(
                rowIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ScrollControllers scrollControllers() {
    return ScrollControllers(
      verticalTitleController: verticalTitleController,
      verticalBodyController: verticalBodyController,
      horizontalTitleController: horizontalTitleController,
      horizontalBodyController: horizontalBodyController,
    );
  }

  Widget leaveStickyTable() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.65,
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(
        top: 5.0,
        bottom: 0,
      ),
      decoration: BoxDecoration(
        color: Colors.blueAccent.shade100,
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      child: StickyHeadersTable(
        initialScrollOffsetX: 0.0,
        initialScrollOffsetY: verticalRowScrollOffset(),
        scrollControllers: scrollControllers(),
        cellDimensions: CellDimensions.variableColumnWidthAndRowHeight(
          columnWidths: [],
          rowHeights: List<double>.generate(members.length, (int index) => 90),
          stickyLegendWidth: MediaQuery.of(context).size.width * 0.99,
          stickyLegendHeight: 0,
        ),
        columnsLength: 0,
        rowsLength: members.length,
        columnsTitleBuilder: (i) => const SizedBox(
          height: 0,
        ),
        rowsTitleBuilder: rowsTitleBuilder,
        contentCellBuilder: (i, j) => const SizedBox(
          height: 0,
        ),
        legendCell: const SizedBox(
          height: 0,
        ),
      ),
    );
  }

  Future<void> onSubmitPreview() async {
    List absenteeList = [];
    if (absenteeMemberData.isNotEmpty) {
      members.forEach((member) {
        var employeeId = member['employeeId'];
        var teacherName = member['teacherName'];
        if (absenteeMemberData[employeeId] == true) {
          absenteeList.add([employeeId, teacherName]);
        }
      });
    }
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xfff21bce),
                    Color(0xff826cf0),
                  ],
                ),
              ),
              child: const Text(
                "Absent Staff Memebers",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            titlePadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(0),
            content: Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.40,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FractionColumnWidth(0.30),
                    1: FractionColumnWidth(0.70),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: absenteeList.isEmpty
                      ? const []
                      : absenteeList
                          .map(
                            (e) => TableRow(
                              children: [
                                TableCell(
                                  child: Text(
                                    e[0].toString(),
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    e[1].toString(),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Card(
                  color: Colors.red,
                  elevation: 10.0,
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.20,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    absenteeList = [];
                    rowsTapped = [];
                  });
                  Navigator.of(context).pop();
                },
                child: Card(
                  color: Colors.blue,
                  elevation: 10.0,
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.20,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    child: const Text(
                      "Reset",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.of(context).pop();
                  if (kDebugMode) {
                    log("Save data to db");
                  }
                },
                child: Card(
                  color: Colors.green,
                  elevation: 10.0,
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.20,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    setState(() {
      members = widget.members;
    });
    for (var member in members) {
      setState(() {
        absenteeMemberData[member['employeeId']] = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          leaveStickyTable(),
          InkWell(
            onTap: () {
              if (kDebugMode) {
                print('attendance submit');
              }
              onSubmitPreview();
            },
            child: Card(
              elevation: 18.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.60,
                height: MediaQuery.of(context).size.height * 0.05,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                // margin: const EdgeInsets.symmetric(
                //   vertical: 5.0,
                // ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
