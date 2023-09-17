import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/auth/controllers/verify_email_controller.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Verify Email.',
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w400,
                      // color: const Color(0xFFF7ECDD),
                      height: 1.2,
                    ),
                  ),
                  Text(
                    'Please verify email by clicking the link sent to your email address, then press continue',
                    style: GoogleFonts.jost(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Material(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12.0),
                    child: GetBuilder<VerifyEmailController>(
                      builder: (_) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(16.0),
                          onTap: _.verifying ? null : _.verifyEmail,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: _.verifying
                                ? const Center(
                                    child: SizedBox(
                                      width: 26.0,
                                      height: 26.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Continue',
                                    style: GoogleFonts.dmSerifDisplay(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  GetBuilder<VerifyEmailController>(
                    builder: (_) {
                      return InkWell(
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: Colors.transparent,
                        onTap: _.resent ? null : _.resendEmail,
                        child: Ink(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                _.resent ? 'Email sent' : 'Resend Email',
                                style: GoogleFonts.jost(
                                  fontSize: 16.0,
                                  color: _.resent ? Colors.grey : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Positioned(
                right: 0.0,
                child: InkWell(
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  onTap: Get.find<VerifyEmailController>().signOut,
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/images/settings/logout_icon.svg'),
                      const SizedBox(width: 8.0),
                      Text(
                        'Log out',
                        style: GoogleFonts.jost(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
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
