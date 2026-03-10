import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isObScureText;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomField({
    this.isObScureText = false,
    required this.controller,
    required this.hintText,
    this.onTap,
    this.readOnly = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      obscureText: isObScureText,
      decoration: InputDecoration(hintText: hintText),
      validator: (val) {
        if (val!.trim().isEmpty) {
          return "$hintText is missing!";
        }
        return null;
      },
    );
  }
}
