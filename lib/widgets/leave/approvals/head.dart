import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class ApproveLeaveWidgetHead extends StatefulWidget {
  final List<Map<String, Object?>> leaveRequests;
  const ApproveLeaveWidgetHead({Key? key, required this.leaveRequests})
      : super(key: key);

  @override
  State<ApproveLeaveWidgetHead> createState() => _ApproveLeaveWidgetHeadState();
}

class _ApproveLeaveWidgetHeadState extends State<ApproveLeaveWidgetHead> {
  /// bgColorMap[staffId] = if(leaveStatus == 'toapprove')?Colors.blue: (leaveStatus=='approve')?Colors.green: Colors.red;

  Map<int, Color> bgColorMap = {};
  Map<int, String> leaveRequestStatus = {};
  ScrollController verticalBodyController =
      ScrollController(initialScrollOffset: 0.0);
  ScrollController verticalTitleController =
      ScrollController(initialScrollOffset: 0.0);
  ScrollController horizontalTitleController =
      ScrollController(initialScrollOffset: 0.0);
  ScrollController horizontalBodyController =
      ScrollController(initialScrollOffset: 0.0);

  int currentRowIndex = 0;

  late List<Map<String, Object?>> leaveRequests = [{}];

  // List updatedRequestStatus = [];

  Widget columnsTitleBuilder(index) {
    return const SizedBox(
      height: 0,
    );
  }

  Widget contentCellBuilder(colIndex, rowIndex) {
    return Container(
      height: 0,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          // border: Border.all(),
          ),
    );
  }

  Color getBgColor(rowIndex) {
    if (leaveRequests.isNotEmpty) {
      switch (leaveRequests[rowIndex]['leaveStatus']) {
        case 'approve':
          return Colors.green;
        case 'toapprovep':
          return Colors.orangeAccent;
        case 'reject':
          return Colors.red;
        case 'toapprove':
          return Colors.blue;
        default:
          return Colors.blue;
      }
    } else {
      return Colors.blue;
    }
  }

  void userInputHandler(
      int rowIndex, int staffId, Color bgColor, String leaveRequestStatus) {}

  Widget dialogTitle(rowIndex) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.80,
      child: Text(
        leaveRequests[rowIndex]['leaveFacultyUserName'].toString(),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
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

  Future<void> showUserInputDialog(int staffId) async {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(
              2.0,
            ),
            title: dialogTitle(staffId),
            content: Container(
              height: leaveRequests[staffId]['leaveAttachement'] != null &&
                      leaveRequests[staffId]['leaveAttachement'] != ""
                  ? MediaQuery.of(context).size.height * 0.30
                  : MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.95,
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    tableViewField(
                      "From:",
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          dateFormatter(
                              leaveRequests[staffId]['leaveFromDate']),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    tableViewField(
                      "To:",
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          dateFormatter(leaveRequests[staffId]['leaveToDate']),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    tableViewField(
                      "Remark:",
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          leaveRequests[staffId]['leaveReason'].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    leaveRequests[staffId]['leaveAttachement'] != null &&
                            leaveRequests[staffId]['leaveAttachement'] != ""
                        ? tableViewField(
                            "Attachment:",
                            Container(
                              alignment: Alignment.topCenter,
                              child: TextButton(
                                onPressed: () {
                                  if (kDebugMode) {
                                    print('show attachment preview');
                                  }
                                },
                                child: const Text(
                                  "Preview",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                  ],
                ),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  if (kDebugMode) {
                    log("Approve");
                    log(leaveRequests[staffId].toString());
                  }

                  setState(() {
                    currentRowIndex = staffId;
                    leaveRequests[staffId]['leaveStatus'] = 'approve';
                  });
                  Navigator.of(context).pop();
                },
                child: Card(
                  elevation: 16.0,
                  color: Colors.green,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 8.0,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                    child: const Text(
                      "Approve",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (kDebugMode) {
                    print("Reject");
                  }
                  setState(() {
                    currentRowIndex = staffId;
                    leaveRequests[staffId]['leaveStatus'] = 'reject';
                  });
                  Navigator.of(context).pop();
                },
                child: Card(
                  elevation: 16.0,
                  color: Colors.red,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 8.0,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                    ),
                    child: const Text(
                      "Reject",
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

  String dateFormatter(fullYmmDD) {
    String formatted =
        DateFormat('MMM dd, yy').format(DateTime.parse(fullYmmDD));
    return formatted;
  }

  Widget rowsTitleBuilder(int rowIndex) {
    return InkWell(
      onTap: () {
        if (kDebugMode) {
          print(rowIndex);
          print(leaveRequests.toString());
          print(widget.leaveRequests.toString());
        }
        showUserInputDialog(rowIndex);
      },
      child: Card(
        color: getBgColor(rowIndex),
        elevation: 18.0,
        shadowColor: Colors.pinkAccent,
        borderOnForeground: true,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: getBgColor(rowIndex),
            borderRadius: BorderRadius.circular(
              12.0,
            ),
          ),
          child: Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FractionColumnWidth(0.50),
              1: FractionColumnWidth(0.50),
            },
            children: [
              TableRow(
                children: [
                  /// staff name
                  TableCell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        leaveRequests[rowIndex]['leaveFacultyUserName']
                            .toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  /// faculty dept name
                  TableCell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        leaveRequests[rowIndex]['leaveFacultyDeptName']
                            .toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  /// leave type Name
                  TableCell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FractionColumnWidth(0.50),
                          1: FractionColumnWidth(0.50),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    "Type: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    leaveRequests[rowIndex]['leaveTypeName']
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///  number of days
                  TableCell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FractionColumnWidth(0.50),
                          1: FractionColumnWidth(0.50),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width,
                                  child: const Text(
                                    "Days: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    leaveRequests[rowIndex]['leaveDays']
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FractionColumnWidth(0.40),
                          1: FractionColumnWidth(0.60),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width,
                                  child: const Text(
                                    "From: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    dateFormatter(leaveRequests[rowIndex]
                                        ['leaveFromDate']),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FractionColumnWidth(0.40),
                          1: FractionColumnWidth(0.60),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width,
                                  child: const Text(
                                    "To: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    dateFormatter(
                                        leaveRequests[rowIndex]['leaveToDate']),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double verticalRowScrollOffset() {
    double scrollOffset = 120.0;
    if (currentRowIndex == 0.0) {
      return 0.0;
    } else {
      return scrollOffset * currentRowIndex;
    }
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
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.symmetric(
        vertical: 3.0,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.70,
      decoration: const BoxDecoration(
          // border: Border.all(),
          ),
      child: StickyHeadersTable(
        initialScrollOffsetX: 0.0,
        initialScrollOffsetY: verticalRowScrollOffset(),
        scrollControllers: scrollControllers(),
        cellDimensions: CellDimensions.variableColumnWidthAndRowHeight(
          columnWidths: [],
          rowHeights:
              List<double>.generate(leaveRequests.length, (int index) => 120),
          stickyLegendWidth: MediaQuery.of(context).size.width * 0.99,
          stickyLegendHeight: 0,
        ),
        columnsLength: 0,
        rowsLength: widget.leaveRequests.length,
        columnsTitleBuilder: columnsTitleBuilder,
        rowsTitleBuilder: rowsTitleBuilder,
        contentCellBuilder: contentCellBuilder,
        legendCell: const SizedBox(
          height: 0,
        ),
      ),
    );
  }

  @override
  void initState() {
    if (kDebugMode) {
      log(widget.leaveRequests.runtimeType.toString());
    }
    List<Map<String, Object?>> tmpList = [];
    for (var leaveRequest in widget.leaveRequests) {
      Map<String, Object?> record = {};

      leaveRequest.forEach((key, value) {
        record[key] = value;
      });
      tmpList.add(record);
    }
    setState(() {
      leaveRequests = tmpList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      alignment: Alignment.topCenter,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          leaveStickyTable(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.40,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 6.0,
              ),
              child: InkWell(
                onTap: () {
                  if (kDebugMode) {
                    log('sync to api');
                  }
                },
                child: Card(
                  elevation: 18.0,
                  borderOnForeground: true,
                  color: const Color.fromARGB(255, 241, 49, 228),
                  shadowColor: Colors.blueGrey,
                  child: Container(
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ApproveStudentLeaveHeadWidget extends StatefulWidget {
  final List<Map<String, Object?>> leaveRequests;
  const ApproveStudentLeaveHeadWidget({Key? key, required this.leaveRequests})
      : super(key: key);

  @override
  State<ApproveStudentLeaveHeadWidget> createState() =>
      _ApproveStudentLeaveHeadWidgetState();
}

class _ApproveStudentLeaveHeadWidgetState
    extends State<ApproveStudentLeaveHeadWidget> {
  late List<Map<String, Object?>> leaveRequests;
  late int currentRowIndex = 0;
  ScrollController verticalBodyController =
      ScrollController(initialScrollOffset: 0.0);
  ScrollController verticalTitleController =
      ScrollController(initialScrollOffset: 0.0);
  ScrollController horizontalTitleController =
      ScrollController(initialScrollOffset: 0.0);
  ScrollController horizontalBodyController =
      ScrollController(initialScrollOffset: 0.0);

  double verticalRowScrollOffset() {
    double scrollOffset = 160.0;
    if (currentRowIndex == 0.0) {
      return 0.0;
    } else {
      return scrollOffset * currentRowIndex;
    }
  }

  ScrollControllers scrollControllers() {
    return ScrollControllers(
      verticalTitleController: verticalTitleController,
      verticalBodyController: verticalBodyController,
      horizontalTitleController: horizontalTitleController,
      horizontalBodyController: horizontalBodyController,
    );
  }

  Widget columnsTitleBuilder(index) {
    return const SizedBox(
      height: 0,
    );
  }

  Widget contentCellBuilder(colIndex, rowIndex) {
    return Container(
      height: 0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
    );
  }

  Color getBgColor(rowIndex) {
    if (leaveRequests.isNotEmpty) {
      switch (leaveRequests[rowIndex]['leaveStatus']) {
        case 'approve':
          return Colors.green;
        case 'reject':
          return Colors.red;
        case 'toapprove':
          return Colors.blue;
        default:
          return Colors.blue;
      }
    } else {
      return Colors.blue;
    }
  }

  String dateFormatter(fullYmmDD) {
    String formatted =
        DateFormat('MMM dd, yy').format(DateTime.parse(fullYmmDD));
    return formatted;
  }

  void showUserInputDialog(rowIndex) async {
    if (kDebugMode) {
      log(dateFormatter(leaveRequests[rowIndex]['leaveFromDate']));
      log(dateFormatter(leaveRequests[rowIndex]['leaveToDate']));
    }
    return showDialog(
        context: context,
        builder: (BuildContext _) {
          return AlertDialog(
            title: Container(
              alignment: Alignment.topCenter,
              child: Text(
                leaveRequests[rowIndex]['leaveStudentName'].toString(),
              ),
            ),
            content: Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width * 0.70,
              height: MediaQuery.of(context).size.height * 0.20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(
                        // color: Color.fromARGB(255, 210, 98, 193),
                        ),
                    child: Table(
                      columnWidths: const {
                        0: FractionColumnWidth(0.50),
                        1: FractionColumnWidth(0.50),
                      },
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: const Text(
                                  "From: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  1 == 2
                                      ? "From"
                                      : dateFormatter(leaveRequests[rowIndex]
                                          ['leaveFromDate']),
                                  style: const TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: const Text(
                                  "To: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  1 == 2
                                      ? "End"
                                      : dateFormatter(leaveRequests[rowIndex]
                                          ['leaveToDate']),
                                  style: const TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: const Text(
                                  "Reason: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  1 == 2
                                      ? "Reason"
                                      : leaveRequests[rowIndex]['leaveReason']
                                          .toString(),
                                  style: const TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Card(
                  elevation: 16.0,
                  color: Colors.blue,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 8.0,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
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
                    currentRowIndex = rowIndex;
                    leaveRequests[rowIndex]['leaveStatus'] = 'approve';
                  });
                  Navigator.of(context).pop();
                },
                child: Card(
                  elevation: 16.0,
                  color: Colors.green,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 8.0,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                    child: const Text(
                      "Approve",
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
                    currentRowIndex = rowIndex;
                    leaveRequests[rowIndex]['leaveStatus'] = 'reject';
                  });
                  Navigator.of(context).pop();
                },
                child: Card(
                  elevation: 16.0,
                  color: Colors.red,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 8.0,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                    ),
                    child: const Text(
                      "Reject",
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

  Widget rowsTitleBuilder(rowIndex) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () {
          if (kDebugMode) {
            print(rowIndex);
            print(leaveRequests.toString());
            print(widget.leaveRequests.toString());
          }
          showUserInputDialog(rowIndex);
        },
        child: Card(
          color: getBgColor(rowIndex),
          elevation: 18.0,
          shadowColor: Colors.pinkAccent,
          borderOnForeground: true,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: getBgColor(rowIndex),
              borderRadius: BorderRadius.circular(
                12.0,
              ),
            ),
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FractionColumnWidth(0.50),
                1: FractionColumnWidth(0.50),
              },
              children: [
                TableRow(
                  children: [
                    /// staff name
                    TableCell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          1 == 2
                              ? "Student Name"
                              : leaveRequests[rowIndex]['leaveStudentName']
                                  .toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    /// student dept name
                    TableCell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          1 == 2
                              ? "Student Dept"
                              : leaveRequests[rowIndex]['leaveStudentDeptName']
                                  .toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    /// leave type Name
                    TableCell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        child: Table(
                          columnWidths: const <int, TableColumnWidth>{
                            // 0: FractionColumnWidth(0.50),
                            // 0: FractionColumnWidth(0.50),
                          },
                          children: [
                            TableRow(
                              children: [
                                // TableCell(
                                //   child: Container(
                                //     width: MediaQuery.of(context).size.width,
                                //     alignment: Alignment.centerLeft,
                                //     child: const Text(
                                //       "Class: ",
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.white,
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                TableCell(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      1 == 2
                                          ? "Class Name"
                                          : leaveRequests[rowIndex]
                                                  ['leaveStudentClassName']
                                              .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    ///  number of days
                    TableCell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        child: Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FractionColumnWidth(0.50),
                            1: FractionColumnWidth(0.50),
                          },
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Text(
                                      "Days: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      1 == 2
                                          ? "Days"
                                          : leaveRequests[rowIndex]['leaveDays']
                                              .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        child: Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FractionColumnWidth(0.40),
                            1: FractionColumnWidth(0.60),
                          },
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Text(
                                      "From: ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      1 == 2
                                          ? "From"
                                          : dateFormatter(
                                              leaveRequests[rowIndex]
                                                  ['leaveFromDate']),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        child: Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FractionColumnWidth(0.40),
                            1: FractionColumnWidth(0.60),
                          },
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Text(
                                      "To: ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      1 == 2
                                          ? "End"
                                          : leaveRequests[rowIndex]
                                                  ['leaveToDate']
                                              .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
    );
  }

  Widget leaveStickyTable() {
    return Container(
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: BoxDecoration(
        border: Border.all(),
        // color: Colors.red,
      ),
      child: StickyHeadersTable(
        initialScrollOffsetX: 0.0,
        initialScrollOffsetY: verticalRowScrollOffset(),
        scrollControllers: scrollControllers(),
        cellDimensions: CellDimensions.variableColumnWidthAndRowHeight(
          columnWidths: [],
          rowHeights:
              List<double>.generate(leaveRequests.length, (int index) => 160),
          stickyLegendWidth: MediaQuery.of(context).size.width * 0.99,
          stickyLegendHeight: 0,
        ),
        columnsLength: 0,
        rowsLength: widget.leaveRequests.length,
        columnsTitleBuilder: columnsTitleBuilder,
        rowsTitleBuilder: rowsTitleBuilder,
        contentCellBuilder: contentCellBuilder,
        legendCell: const SizedBox(
          height: 0,
        ),
      ),
    );
  }

  @override
  void initState() {
    List<Map<String, Object?>> tmpList = [];
    for (var leaveRequest in widget.leaveRequests) {
      Map<String, Object?> record = {};

      leaveRequest.forEach((key, value) {
        record[key] = value;
      });
      tmpList.add(record);
    }
    setState(() {
      leaveRequests = tmpList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.deepOrangeAccent,
        border: Border.all(),
      ),
      alignment: Alignment.topCenter,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            leaveStickyTable(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.40,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 6.0,
                ),
                child: InkWell(
                  onTap: () {
                    if (kDebugMode) {
                      log('sync to api');
                    }
                  },
                  child: Card(
                    elevation: 18.0,
                    borderOnForeground: true,
                    color: const Color.fromARGB(255, 241, 49, 228),
                    shadowColor: Colors.blueGrey,
                    child: Container(
                      // height: MediaQuery.of(context).size.height * 0.08,
                      // width: MediaQuery.of(context).size.width * 0.40,
                      alignment: Alignment.center,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(
                      //     10.0,
                      //   ),
                      //   color: Colors.purpleAccent,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
