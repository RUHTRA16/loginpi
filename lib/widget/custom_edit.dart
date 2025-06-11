import 'package:flutter/material.dart';

class CustomEdit extends StatelessWidget {
  final String label;
  final Icon icone;
  final bool isObscure;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomEdit({
    super.key,
    required this.label,
    required this.icone,
    required this.isObscure,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: isObscure,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: icone,
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
