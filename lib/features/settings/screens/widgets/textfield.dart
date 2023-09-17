import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool obscured, shouldObscure, showBorderTop;
  final String hintText;
  final int? maxLines;
  final TextCapitalization? capitalization;
  final TextInputType? inputType;
  const SettingsTextField({
    super.key,
    required this.controller,
    required this.shouldObscure,
    required this.obscured,
    required this.hintText,
    this.showBorderTop = true,
    this.maxLines,
    this.capitalization,
    this.inputType,
  });

  @override
  State<SettingsTextField> createState() => _SettingsTextFieldState();
}

class _SettingsTextFieldState extends State<SettingsTextField> {
  late bool obscured;

  @override
  void initState() {
    obscured = widget.obscured;
    super.initState();
  }

  void toggleObscure() {
    setState(() {
      obscured = !obscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.showBorderTop
          ? const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.black),
              ),
            )
          : null,
      child: TextField(
        controller: widget.controller,
        obscureText: obscured,
        textCapitalization: widget.capitalization ?? TextCapitalization.none,
        keyboardType: widget.inputType ?? TextInputType.text,
        style: GoogleFonts.jost(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF0A0F19),
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 0.0,
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 0.0,
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 0.0,
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          hintText: widget.hintText,
          hintStyle: GoogleFonts.jost(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: const Color(0x800A0F19),
          ),
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          suffixIcon: widget.shouldObscure
              ? InkWell(
                  onTap: toggleObscure,
                  child: Image.asset(
                    obscured ? 'assets/images/auth/obscured.png' : 'assets/images/auth/not_obscured.png',
                    width: 16.0,
                    height: 16.0,
                    colorBlendMode: BlendMode.srcIn,
                    color: Colors.black,
                  ),
                )
              : null,
        ),
        maxLines: widget.maxLines ?? 1,
        cursorColor: const Color(0xFF0A0F19),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
