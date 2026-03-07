import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;

  const CustomField({required this.hintText, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(decoration: InputDecoration(hintText: hintText));
  }
}
