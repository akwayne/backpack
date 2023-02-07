import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.errorText,
    this.obscureText,
  });

  final TextEditingController controller;
  final String label;
  final String? errorText;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor.withOpacity(0.8),
          hintText: label,
          labelText: label,
          errorText: errorText,
        ),
      ),
    );
  }
}
