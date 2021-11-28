import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextFormField extends StatelessWidget {
  final TextEditingController controller;
  List<TextInputFormatter> inputFormatters;
  final String labelText;
  final String hintText;
  final Widget prefixIcon;
  final Widget suffixIcon;
  TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FormFieldValidator<String> validator;
  bool obscureText;
  bool readOnly;
  Function()? onTap;

  CommonTextFormField({
    Key? key,
    required this.controller,
    this.inputFormatters = const [],
    required this.labelText,
    required this.hintText,
    required this.textInputAction,
    required this.validator,
    this.obscureText = false,
    required this.prefixIcon,
    required this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap ?? () {},
      readOnly: readOnly,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabled: true,
        errorMaxLines: 2,
      ),
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: TextStyle(
        fontFamily: 'Poppins',
      ),
    );
  }
}
