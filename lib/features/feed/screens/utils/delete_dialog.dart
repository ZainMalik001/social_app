import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/controllers/home_controller.dart';

class DeletePostDialog {
  const DeletePostDialog._();

  static show(String postID) {
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delete Post',
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 24.0,
                    ),
                  ),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: Get.back,
                    child: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                'Are you sure you want to delete this post?',
                style: GoogleFonts.jost(),
              ),
              const SizedBox(height: 16.0),
              Material(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () => Get.find<HomeController>().deletePost(postID),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Delete post?',
                      style:
                          GoogleFonts.jost(fontSize: 16.0, fontWeight: FontWeight.w500, color: const Color(0xFFF7ECDD)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeletingDialog {
  const DeletingDialog._();

  static void show() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Colors.red,
              ),
              const SizedBox(height: 12.0),
              Text(
                'Deleting post...',
                style: GoogleFonts.jost(fontSize: 16.0, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
