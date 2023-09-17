import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/influencer/screens/widgets/add_socials_textfield.dart';

import '../../../core/widgets/appbar.dart';
import '../controllers/become_influencer_controller.dart';

class AddSocialsScreen extends StatelessWidget {
  const AddSocialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: const RubuAppbar(
          title: "Submit social proof",
          canPop: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 28.0),
                    Text(
                      'Try to fill out as many fields as you can to get approved',
                      style: GoogleFonts.jost(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    Text(
                      'Add Instagram Link',
                      style: GoogleFonts.jost(fontWeight: FontWeight.w400, fontSize: 12.0),
                    ),
                    const SizedBox(height: 8.0),
                    AddSocialsTextField(
                      controller: Get.find<BecomeInfluencerController>().instagramController,
                      hintText: 'Add your Instagram URL',
                      prefix: Image.asset(
                        'assets/images/influencer/socials/instagram.png',
                        width: 24.0,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      'Add Tiktok Link',
                      style: GoogleFonts.jost(fontWeight: FontWeight.w400, fontSize: 12.0),
                    ),
                    const SizedBox(height: 8.0),
                    AddSocialsTextField(
                      controller: Get.find<BecomeInfluencerController>().tiktokController,
                      hintText: 'Add your Tiktok URL',
                      prefix: Image.asset(
                        'assets/images/influencer/socials/tiktok.png',
                        width: 24.0,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      'Add Snapchat Link',
                      style: GoogleFonts.jost(fontWeight: FontWeight.w400, fontSize: 12.0),
                    ),
                    const SizedBox(height: 8.0),
                    AddSocialsTextField(
                      controller: Get.find<BecomeInfluencerController>().snapchatController,
                      hintText: 'Add your Snapchat URL',
                      prefix: Image.asset(
                        'assets/images/influencer/socials/snapchat.png',
                        width: 24.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
                child: Material(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: Get.find<BecomeInfluencerController>().createProfile,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Submit',
                        style: GoogleFonts.jost(
                            fontSize: 16.0, fontWeight: FontWeight.w500, color: const Color(0xFFF7ECDD)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: Get.back,
                child: Text(
                  'Go back',
                  style: GoogleFonts.jost(
                    fontSize: 16.0,
                    decoration: TextDecoration.underline,
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
