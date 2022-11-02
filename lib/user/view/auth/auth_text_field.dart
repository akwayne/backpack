import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.errorText,
  });

  final TextEditingController controller;
  final String hintText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        obscureText: (hintText.contains('Password')) ? true : false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor.withOpacity(0.8),
          hintText: hintText,
          errorText: errorText,
        ),
        validator: (value) {
          return value != '' ? null : 'Field must not be empty';
        },
      ),
    );
  }
}
