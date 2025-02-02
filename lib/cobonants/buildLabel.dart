import 'package:flutter/material.dart';

class buildLabel extends StatelessWidget {
  final String text;
  const buildLabel({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ); 
  }
}
  

