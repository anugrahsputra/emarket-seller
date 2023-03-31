import 'package:flutter/material.dart';

class FormText extends StatelessWidget {
  FormText({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: const Color(0xff212529),
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          color: const Color(0xff495057),
          icon,
        ),
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
