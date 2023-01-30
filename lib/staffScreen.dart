import 'package:flutter/material.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key, required this.title});

  final String title;

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}
