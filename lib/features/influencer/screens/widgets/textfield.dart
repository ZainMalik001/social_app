import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfluencerTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  const InfluencerTextField({super.key, required this.controller, this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.0,
            color: Color(0xFF0A0F19),
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.0,
            color: Color(0xFF0A0F19),
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.0,
            color: Color(0xFF0A0F19),
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        labelText: hintText,
        labelStyle: GoogleFonts.jost(fontSize: 14.0, color: const Color(0x800A0F19)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      ),
      style: GoogleFonts.jost(fontSize: 14.0, color: const Color(0xFF0A0F19)),
      cursorColor: const Color(0xFF0A0F19),
    );
  }
}
