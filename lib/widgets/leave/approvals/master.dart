import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class MasterLeaveApproveTableWidget extends StatefulWidget {
  final List leaveRequests;
  const MasterLeaveApproveTableWidget({Key? key, required this.leaveRequests})
      : super(key: key);

  @override
  State<MasterLeaveApproveTableWidget> createState() =>
      _MasterLeaveApproveTableWidgetState();
}

class _MasterLeaveApproveTableWidgetState
    extends State<MasterLeaveApproveTableWidget> {
  /// bgColorMap[staffId] = if(leaveStatus == 'toapprovep')?Colors.blue: (leaveStatus=='approve')?Colors.green: Colors.red;
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

  List leaveRequests = [{}];

  Widget columnsTitleBuilder(index) {
    return const SizedBox(
      height: 0,
    );
  }

  Widget contentCellBuilder(colIndex, rowIndex) {
    return Container(
      // height: 0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
    );
  }

  void userInputHandler(
      int rowIndex, int staffId, Color bgColor, String leaveRequestStatus) {}

  Widget dialogTitle(staffId) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.80,
      child: Text(
        leaveRequests[staffId]['leaveFacultyUserName'].toString(),
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
              TextButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("Approve");
                  }
                  setState(() {
                    currentRowIndex = staffId;
                    leaveRequests[staffId]['leaveStatus'] = 'approve';
                  });
                },
                child: const Text(
                  "Approve",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("Reject");
                  }
                  setState(() {
                    currentRowIndex = staffId;
                    leaveRequests[staffId]['leaveStatus'] = 'reject';
                  });
                },
                child: const Text(
                  "Reject",
                  style: TextStyle(
                    color: Colors.red,
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

  Color getRowBgColor(rowIndex) {
    switch (leaveRequests[rowIndex]['leaveStatus']) {
      case "toapprovep":
        return Colors.blue;
      case "approve":
        return Colors.green;
      case "reject":
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget rowsTitleBuilder(int rowIndex) {
    return InkWell(
      onTap: () {
        if (kDebugMode) {
          print(rowIndex);
        }
        showUserInputDialog(rowIndex);
      },
      child: Card(
        color: getRowBgColor(rowIndex),
        elevation: 18.0,
        shadowColor: Colors.pinkAccent,
        borderOnForeground: true,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(
            horizontal: 6.0,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: getRowBgColor(rowIndex),
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
        vertical: 6.0,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.60,
      // decoration: BoxDecoration(
      //   border: Border.all(),
      // ),
      // key: ObjectKey(leaveRequests),
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
    setState(() {
      leaveRequests = widget.leaveRequests;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      decoration: const BoxDecoration(),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            leaveStickyTable(),
            InkWell(
              onTap: () {},
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.purpleAccent,
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
            )
          ],
        ),
      ),
    );
  }
}
