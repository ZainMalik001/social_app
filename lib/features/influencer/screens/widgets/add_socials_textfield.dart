import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSocialsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget prefix;
  const AddSocialsTextField({super.key, required this.controller, required this.hintText, required this.prefix});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.jost(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF0A0F19),
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.6,
            color: Color(0xFF0A0F19),
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.6,
            color: Color(0xFF0A0F19),
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.6,
            color: Color(0xFF0A0F19),
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.jost(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: const Color(0x800A0F19),
        ),
        prefixIcon: prefix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      ),
      cursorColor: const Color(0xFF0A0F19),
    );
  }
}
