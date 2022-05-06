import 'package:flutter/material.dart';

class ApproveLeaveWidgetHead extends StatefulWidget {
  final List leaveRequests;
  const ApproveLeaveWidgetHead({Key? key, required this.leaveRequests})
      : super(key: key);

  @override
  State<ApproveLeaveWidgetHead> createState() => _ApproveLeaveWidgetHeadState();
}

class _ApproveLeaveWidgetHeadState extends State<ApproveLeaveWidgetHead> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Text(widget.leaveRequests.toString()),
    );
  }
}
