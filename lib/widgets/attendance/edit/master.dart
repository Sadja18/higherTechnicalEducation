import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';
import '../../common/date_select.dart';
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

  /// since the database stores date in fullYear-fullMonth-fullDate format
  /// we need a formatter to enable it
  final DateFormat format = DateFormat('yyyy-MM-dd');

  // a variable to store the selected date
  String? _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // reverse call back to store the selected Date
  void dateSelector(String? selectDate) {
    setState(() {
      _selectedDate = selectDate.toString();
      currentRowIndex = 0;
      rowsTapped = [];
      absenteeMemberData = {};
    });
    if (kDebugMode) {
      print('reverse date callback');
    }
  }
  // reverse call back to store the selected Date end

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
    double scrollOffset = 100.0;
    if (currentRowIndex == 0.0) {
      return 0.0;
    } else {
      return scrollOffset * currentRowIndex;
    }
  }

  Widget tableViewField(String fieldName, Widget fieldWidget, bgColor) {
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
                    style: TextStyle(
                      color: bgColor,
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
      height: MediaQuery.of(context).size.height * 0.120,
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
                child: Container(
                  decoration: const BoxDecoration(),
                  alignment: Alignment.topCenter,
                  // width: MediaQuery.of(context).size.width*0.0001,
                  height: MediaQuery.of(context).size.height * 0.115,
                  child: ClipOval(
                    child: Image(
                      image: Image.memory(
                        Base64Decoder().convert(
                          members[rowIndex]['profilePic'].toString(),
                        ),
                      ).image,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        // splashColor: Colors.purple,
        onTap: () {
          var currentEmpId = members[rowIndex]['employeeId'];
          if (kDebugMode) {
            log('mark $currentEmpId as ${!absenteeMemberData[currentEmpId]}');
          }
          setState(() {
            absenteeMemberData[currentEmpId] =
                !absenteeMemberData[currentEmpId];
            rowsTapped.add(rowIndex);
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
          child: Card(
            borderOnForeground: true,
            color: getRowColor(rowIndex),
            shadowColor: Colors.transparent,
            elevation: 16.0,
            child: Container(
              // margin: const EdgeInsets.only(
              //   top: 5.0,
              // ),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: getRowColor(rowIndex),
              ),
              child: staffCellTopRow(
                rowIndex,
              ),
            ),
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
      height: MediaQuery.of(context).size.height * 0.50,
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(
        top: 0.0,
        bottom: 0,
      ),
      decoration: BoxDecoration(
        // color: Colors.blueAccent.shade100,
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
          rowHeights: List<double>.generate(members.length, (int index) => 100),
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

  int getAbsenteeCount() {
    int count = 0;
    for (var key in absenteeMemberData.keys.toList()) {
      if (absenteeMemberData[key]) {
        count = count + 1;
      }
    }
    return count;
  }

  void showAbsenteesDialogPreview() async {
    var absentees = [];

    for (var empId in absenteeMemberData.keys.toList()) {
      if (absenteeMemberData[empId]) {
        for (var member in members) {
          if (member['employeeId'] == empId) {
            var empName = member['employeeName'];

            absentees.add([empId, member['teacherName']]);
          }
        }
      }
    }
    List<Widget> cells = [
      Table(
        columnWidths: const {
          0: FractionColumnWidth(0.30),
          1: FractionColumnWidth(0.60),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: const [
          TableRow(
            children: [
              TableCell(
                child: Text(
                  "Emp Id",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TableCell(
                child: Text(
                  "Emp Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ];

    for (var e in absentees) {
      cells.add(
        Table(
          columnWidths: const {
            0: FractionColumnWidth(0.30),
            1: FractionColumnWidth(0.60),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Center(
                    child: Text(
                      e[0].toString(),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text(
                      e[1].toString(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return showDialog(
        context: context,
        builder: (BuildContext _) {
          return AlertDialog(
            title: const Text("Absent Staff Members"),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.40,
              width: MediaQuery.of(context).size.width * 0.60,
              decoration: const BoxDecoration(
                  // color: Colors.red,
                  ),
              alignment: Alignment.topCenter,
              child: (absentees.isNotEmpty)
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: cells,
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: MediaQuery.of(context).size.height * 0.73,
      decoration: const BoxDecoration(
          // color: Colors.red,
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(),
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.symmetric(
              horizontal: 0.0,
              vertical: 0.0,
            ),
            child: Table(
              columnWidths: const {
                0: FractionColumnWidth(1),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: DateShowNew(
                        dateSelector: dateSelector,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Table(
                            columnWidths: const {
                              0: FractionColumnWidth(0.30),
                              1: FractionColumnWidth(0.30),
                              2: FractionColumnWidth(0.30),
                            },
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: tableViewField(
                                      "T:",
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                        decoration: const BoxDecoration(
                                            // color: Colors.blue,
                                            ),
                                        child: Text(
                                          members.length.toString(),
                                          style: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      Colors.blue,
                                    ),
                                  ),
                                  TableCell(
                                    child: tableViewField(
                                      "P:",
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                        decoration: const BoxDecoration(),
                                        child: Text(
                                          (members.length - getAbsenteeCount())
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                      Colors.green,
                                    ),
                                  ),
                                  TableCell(
                                    child: InkWell(
                                      onTap: () {
                                        showAbsenteesDialogPreview();
                                      },
                                      child: tableViewField(
                                        "A:",
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.30,
                                          decoration: const BoxDecoration(),
                                          child: Text(
                                            getAbsenteeCount().toString(),
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          leaveStickyTable(),
          InkWell(
            onTap: () {
              onSubmitPreview();
            },
            child: Card(
              elevation: 18.0,
              color: Colors.purpleAccent,
              borderOnForeground: true,
              semanticContainer: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  14.0,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(
                    14.0,
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.30,
                height: MediaQuery.of(context).size.height * 0.05,
                alignment: Alignment.center,
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
