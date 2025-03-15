import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.white),
    );

    return TextFormField(
      style: TextStyle(color: Colors.white),
      readOnly: readOnly,
      onTap: onTap,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        border: border,
        enabledBorder: border,
        label: Text(label, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
