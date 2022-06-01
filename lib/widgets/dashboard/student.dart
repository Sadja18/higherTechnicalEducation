import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AttendanceOverAllCircularChart extends StatefulWidget {
  final String subjectName;
  final double presentPercentage;
  const AttendanceOverAllCircularChart({
    Key? key,
    required this.presentPercentage,
    required this.subjectName,
  }) : super(key: key);

  @override
  State<AttendanceOverAllCircularChart> createState() =>
      _AttendanceOverAllCircularChartState();
}

class _AttendanceOverAllCircularChartState
    extends State<AttendanceOverAllCircularChart> {
  late List<AttendanceValler> _chartData;
  late TooltipBehavior _toolTipBehavior;

  List<AttendanceValler> getAttendanceData() {
    final List<AttendanceValler> values = [
      AttendanceValler(
        "Present",
        51.00,
        Color.fromARGB(255, 78, 154, 80),
      ),
      AttendanceValler(
        "Absent",
        100.00 - 51.00,
        Colors.red,
      ),
    ];
    return values;
  }

  @override
  void initState() {
    _chartData = getAttendanceData();
    _toolTipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topCenter,
      child: SfCircularChart(
        title: ChartTitle(text: "Overall Attendance %"),
        // legend: Legend(
        //   isVisible: true,
        //   isResponsive: true,
        //   overflowMode: LegendItemOverflowMode.wrap,
        // ),
        tooltipBehavior: _toolTipBehavior,
        series: <CircularSeries>[
          PieSeries<AttendanceValler, String>(
            dataSource: _chartData,
            pointColorMapper: (AttendanceValler data, _) => data.color,
            xValueMapper: (AttendanceValler data, _) => data.legendName,
            yValueMapper: (AttendanceValler data, _) => data.attendanceValue,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
            enableTooltip: true,
          ),
        ],
      ),
    );
  }
}

class AttendanceValler {
  final String legendName;
  final double attendanceValue;
  final Color color;
  AttendanceValler(this.legendName, this.attendanceValue, this.color);
}

class AttendanceSubjectWise extends StatefulWidget {
  final dynamic attendanceMap;

  const AttendanceSubjectWise({
    Key? key,
    required this.attendanceMap,
  }) : super(key: key);

  @override
  State<AttendanceSubjectWise> createState() => _AttendanceSubjectWiseState();
}

class _AttendanceSubjectWiseState extends State<AttendanceSubjectWise> {
  late List<AttendanceSubjectValler> subjectsData;
  late TooltipBehavior _toolTipBehaviorSubjectWise;

  List<AttendanceSubjectValler> getSubjectWiseData() {
    var data = <AttendanceSubjectValler>[];
    if (widget.attendanceMap != null && widget.attendanceMap.isNotEmpty) {
      var subjectsM = widget.attendanceMap['subjects'];
      if (subjectsM != null && subjectsM.length > 0) {
        for (var entry in subjectsM) {
          var subjectName = entry['subject'];
          var stringPercentage = entry['percentage'];
          var percentage =
              double.parse(stringPercentage.split('%')[0].toString());

          data.add(AttendanceSubjectValler(subjectName, percentage));
        }
      }
    }
    return data;
  }

  @override
  void initState() {
    subjectsData = getSubjectWiseData();
    _toolTipBehaviorSubjectWise = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topCenter,
      child: SfCircularChart(
        title: ChartTitle(text: "Subject Attendance %"),
        // legend: Legend(
        //   isVisible: true,
        //   isResponsive: true,
        //   overflowMode: LegendItemOverflowMode.wrap,
        // ),
        tooltipBehavior: _toolTipBehaviorSubjectWise,
        series: <CircularSeries>[
          PieSeries<AttendanceSubjectValler, String>(
            dataSource: subjectsData,
            // pointColorMapper: (AttendanceSubjectValler data, _) => data.color,
            xValueMapper: (AttendanceSubjectValler data, _) => data.subjectName,
            yValueMapper: (AttendanceSubjectValler data, _) => data.percentage,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
            enableTooltip: true,
          ),
        ],
      ),
    );
  }
}

class AttendanceSubjectValler {
  final String subjectName;
  final double percentage;
  AttendanceSubjectValler(this.subjectName, this.percentage);
}
