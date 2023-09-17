import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class SadScreen extends StatelessWidget {
  const SadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/home/sad.png'),
                      const SizedBox(height: 32.0),
                      Text(
                        'Don’t be Sad',
                        style: GoogleFonts.dmSerifDisplay(fontSize: 32.0),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Your request to be a creator has been rejected, Gain some popularity on other social media platforms to get approved',
                        style: GoogleFonts.jost(fontSize: 12.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
              child: Material(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: Get.back,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Continue',
                      style:
                          GoogleFonts.jost(fontSize: 16.0, fontWeight: FontWeight.w500, color: const Color(0xFFF7ECDD)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
