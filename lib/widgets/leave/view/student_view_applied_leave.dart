import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../services/connection/student_mode_methods.dart';

class FutureBuilderForFetchStudentLeave extends StatefulWidget {
  const FutureBuilderForFetchStudentLeave({Key? key}) : super(key: key);

  @override
  State<FutureBuilderForFetchStudentLeave> createState() =>
      _FutureBuilderForFetchStudentLeaveState();
}

class _FutureBuilderForFetchStudentLeaveState
    extends State<FutureBuilderForFetchStudentLeave> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readStudentLeaveRequestRecords(),
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          if (snapshot.hasError ||
              snapshot.hasData != true ||
              snapshot.data == null ||
              snapshot.data == false ||
              snapshot.data.isEmpty) {
            return const SizedBox(
              height: 0,
            );
          } else {
            var leaveRequests = snapshot.data;
            return CalendarViewWidget(leaveRequests: leaveRequests);
          }
        }
      },
    );
  }
}

class CalendarViewWidget extends StatefulWidget {
  final List leaveRequests;
  const CalendarViewWidget({Key? key, required this.leaveRequests})
      : super(key: key);

  @override
  State<CalendarViewWidget> createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  final CalendarController _controller = CalendarController();

  String createSubject(startDate, endDate, leaveReason, className) {
    var subject = "";
    subject = subject + "From: $startDate" + "\n";
    subject = subject + "To: $endDate" + "\n";
    subject = subject + "Reason: $leaveReason" + "\n";
    subject = subject + "\n" + "$className";
    return subject;
  }

  List<Leave> _getLeaves() {
    List<Leave> leaveViewData = <Leave>[];

    if (widget.leaveRequests.isNotEmpty) {
      for (var i = 0; i < widget.leaveRequests.length; i++) {
        var record = widget.leaveRequests[i];
        // if (kDebugMode) {
        //   log(record.toString());
        // }
        DateTime startDateParsed = DateTime.parse(record['leaveFromDate']);
        DateTime endDateParsed =
            DateTime.parse("${record['leaveToDate']} 23:59:59");
        String leaveReason = record['leaveReason'];
        String className = record['leaveStudentClassName'];
        String subject = createSubject(record['leaveFromDate'],
            record['leaveToDate'], leaveReason, className);
        String leaveRequestStatus = record['leaveStatus'];
        Color backColor = Colors.white;

        if (leaveRequestStatus == 'draft' ||
            leaveRequestStatus == 'toapprove') {
          backColor = Colors.blue;
        } else if (leaveRequestStatus == 'approve') {
          backColor = Colors.green;
        } else {
          backColor = Colors.red;
        }

        Leave entry =
            Leave(startDateParsed, endDateParsed, subject, backColor, true);
        leaveViewData.add(entry);
      }
    }
    return leaveViewData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.80,
      child: SfCalendar(
        allowDragAndDrop: false,
        allowAppointmentResize: false,
        controller: _controller,
        view: CalendarView.month,
        viewHeaderStyle: const ViewHeaderStyle(
          dateTextStyle: TextStyle(),
          dayTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
        ),
        firstDayOfWeek: 1,
        showNavigationArrow: true,
        headerStyle: const CalendarHeaderStyle(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        monthViewSettings: const MonthViewSettings(
          dayFormat: 'EE',
          agendaItemHeight: 180.0,
          showTrailingAndLeadingDates: false,
          showAgenda: true,
          agendaStyle: AgendaStyle(
            dayTextStyle: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            dateTextStyle: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            appointmentTextStyle: TextStyle(
              overflow: TextOverflow.fade,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // dayFormat: 'EE',
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        appointmentTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 22.0,
        ),
        // monthCellBuilder: monthCellBuilder,
        dataSource: LeaveDataSource(_getLeaves()),
      ),
    );
  }
}

class Leave {
  DateTime startDate;
  DateTime endDate;
  String reason;
  Color backColors;
  // String className="";
  // bool synced;
  bool isAllDay = true;
  Leave(
    this.startDate,
    this.endDate,
    this.reason,
    this.backColors,
    this.isAllDay,
  );
}

class LeaveDataSource extends CalendarDataSource {
  LeaveDataSource(List<Leave> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startDate;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endDate;
  }

  @override
  Color getColor(int index) {
    return appointments![index].backColors;
    // return colorVal;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }

  @override
  String getSubject(int index) {
    return appointments![index].reason;
  }
}
