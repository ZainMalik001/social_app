import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class UnavailableDialog {
  static void show() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: Get.back,
                  child: const Icon(
                    Icons.close_rounded,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12.0),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 28.0),
              child: Text(
                "We don't have this website currently in our network, we will add it at the soonest and share with you",
                style: GoogleFonts.jost(fontSize: 20.0, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
