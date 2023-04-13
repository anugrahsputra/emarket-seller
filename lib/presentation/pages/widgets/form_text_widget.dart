import 'package:flutter/material.dart';

class FormText extends StatelessWidget {
  FormText({
    super.key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.prefixIcon,
    this.obscureText = false,
    this.prefixText = '',
  });

  final TextEditingController controller;
  final String hintText;
  final Widget prefixIcon;
  TextInputType keyboardType;
  bool obscureText;
  String prefixText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: const Color(0xff212529),
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixText: prefixText,
        isDense: true,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            style: BorderStyle.none,
            width: 0,
          ),
        ),
        filled: true,
      ),
    );
  }
}
