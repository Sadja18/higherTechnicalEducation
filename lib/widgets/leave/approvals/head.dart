import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class ApproveLeaveWidgetHead extends StatefulWidget {
  final List leaveRequests;
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

  Color getBgColor() {
    return Colors.blue;
  }

  void userInputHandler(
      int rowIndex, int staffId, Color bgColor, String leaveRequestStatus) {}

  Widget dialogTitle() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.80,
      child: Text('${(100 * 101) / leaveRequests.length}'),
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
            title: dialogTitle(),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.35,
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
                        child: const Text("From Date"),
                      ),
                    ),
                    tableViewField(
                      "To:",
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text("To Date"),
                      ),
                    ),
                    tableViewField(
                      "Remark:",
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text("Remark"),
                      ),
                    ),
                    tableViewField(
                      "Attachment:",
                      Container(
                        alignment: Alignment.topCenter,
                        child: const Text("Attachment preview"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Approve",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
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
        color: getBgColor(),
        elevation: 18.0,
        shadowColor: Colors.pinkAccent,
        borderOnForeground: true,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: getBgColor(),
            borderRadius: BorderRadius.circular(
              12.0,
            ),
          ),
          child: Text(
            leaveRequests[rowIndex].toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  double verticalRowScrollOffset() {
    double scrollOffset = 75.0;
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
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: StickyHeadersTable(
        initialScrollOffsetX: 0.0,
        initialScrollOffsetY: verticalRowScrollOffset(),
        scrollControllers: scrollControllers(),
        cellDimensions: CellDimensions.variableColumnWidthAndRowHeight(
          columnWidths: [],
          rowHeights:
              List<double>.generate(leaveRequests.length, (int index) => 75),
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
      decoration: const BoxDecoration(),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          leaveStickyTable(),
          InkWell(
            onTap: () {
              if (kDebugMode) {
                log('sync to api');
              }
            },
            child: Card(
              elevation: 18.0,
              borderOnForeground: true,
              color: Colors.purple,
              shadowColor: Colors.blueGrey,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.60,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.purpleAccent,
                ),
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
