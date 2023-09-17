import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/core/constants/keys.dart';

import 'injection_handler.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 12.0),
            //   height: 360,
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     children: [
            //       Expanded(
            //         flex: 2,
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.stretch,
            //           children: [
            //             Expanded(
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(12.0),
            //                 child: Image.asset(
            //                   'assets/images/welcome/1.png',
            //                   fit: BoxFit.cover,
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(height: 8.0),
            //             Expanded(
            //               child: Row(
            //                 crossAxisAlignment: CrossAxisAlignment.stretch,
            //                 children: [
            //                   Expanded(
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(12.0),
            //                       child: Image.asset(
            //                         'assets/images/welcome/3.png',
            //                         fit: BoxFit.cover,
            //                       ),
            //                     ),
            //                   ),
            //                   const SizedBox(width: 8.0),
            //                   Expanded(
            //                     flex: 2,
            //                     child: ClipRRect(
            //                       borderRadius: BorderRadius.circular(12.0),
            //                       child: Image.asset(
            //                         'assets/images/welcome/4.png',
            //                         fit: BoxFit.cover,
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             const SizedBox(height: 8.0),
            //             Expanded(
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(12.0),
            //                 child: Image.asset(
            //                   'assets/images/welcome/6.png',
            //                   fit: BoxFit.cover,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(width: 8.0),
            //       Expanded(
            //         flex: 1,
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.stretch,
            //           children: [
            //             Expanded(
            //               flex: 2,
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(12.0),
            //                 child: Image.asset(
            //                   'assets/images/welcome/2.png',
            //                   fit: BoxFit.cover,
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(height: 8.0),
            //             Expanded(
            //               flex: 3,
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(12.0),
            //                 child: Image.asset(
            //                   'assets/images/welcome/5.png',
            //                   fit: BoxFit.cover,
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(height: 8.0),
            //             Expanded(
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(10.0),
            //                 child: Image.asset(
            //                   'assets/images/welcome/7.png',
            //                   fit: BoxFit.cover,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      'assets/images/welcome/welcome.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Image.asset('assets/images/welcome/naaz.png'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Scroll through your favourite products.',
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w400,
                      // color: const Color(0xFFF7ECDD),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Material(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.0),
                      onTap: () => Get.toNamed("/login"),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Login',
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Material(
                    type: MaterialType.transparency,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2.0, color: Colors.black),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.0),
                      onTap: () => Get.toNamed("/register"),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 18.0),
                        child: Text(
                          'Create an account',
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Platform.isIOS
                  //     ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          sl.get<GetStorage>().write(StorageKeys.isAnonymous, true);
                          Get.offAllNamed('/home');
                        },
                        child: Ink(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Skip',
                                style: GoogleFonts.jost(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //     : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
