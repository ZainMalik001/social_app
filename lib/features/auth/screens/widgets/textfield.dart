import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool? allowObscure, obscured;
  final Color? borderColor;
  final TextCapitalization? capitalization;
  final TextInputType? inputType;
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.allowObscure,
    this.obscured,
    this.borderColor,
    this.capitalization,
    this.inputType,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool obscured;

  @override
  void initState() {
    obscured = (widget.allowObscure ?? false) && (widget.obscured ?? false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: obscured,
      textCapitalization: widget.capitalization ?? TextCapitalization.none,
      keyboardType: widget.inputType ?? TextInputType.text,
      style: GoogleFonts.jost(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: widget.borderColor ?? const Color(0xFFF7ECDD),
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.6,
            color: widget.borderColor ?? const Color(0xFFF7ECDD),
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.6,
            color: widget.borderColor ?? const Color(0xFFF7ECDD),
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.6,
            color: widget.borderColor ?? const Color(0xFFF7ECDD),
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        labelText: widget.hintText,
        labelStyle: GoogleFonts.jost(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: widget.borderColor?.withOpacity(0.5) ?? const Color(0x80F7ECDD),
        ),
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        suffixIcon: (widget.allowObscure ?? false)
            ? obscured
                ? InkWell(
                    onTap: () => setState(() => obscured = false),
                    child: Image.asset(
                      'assets/images/auth/obscured.png',
                      width: 16.0,
                      height: 16.0,
                      colorBlendMode: BlendMode.srcIn,
                      color: widget.borderColor ?? const Color(0x80F7ECDD),
                    ),
                  )
                : InkWell(
                    onTap: () => setState(() => obscured = true),
                    child: Image.asset(
                      'assets/images/auth/not_obscured.png',
                      width: 16.0,
                      height: 16.0,
                      colorBlendMode: BlendMode.srcIn,
                      color: widget.borderColor ?? const Color(0x80F7ECDD),
                    ),
                  )
            : null,
      ),
      cursorColor: widget.borderColor ?? const Color(0xFFF7ECDD),
    );
  }
}
