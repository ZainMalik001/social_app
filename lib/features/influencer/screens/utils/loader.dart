import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class LoaderDialog {
  const LoaderDialog._();

  static void show(String text) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFFF7ECDD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Colors.black,
              ),
              const SizedBox(height: 12.0),
              Text(
                text,
                style: GoogleFonts.jost(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
