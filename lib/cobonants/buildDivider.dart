import 'package:flutter/material.dart';

class BuildDivider extends StatelessWidget {
  final String text;

  const BuildDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(thickness: 2),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Divider(thickness: 2),
        ),
      ],
    );
  }
}
