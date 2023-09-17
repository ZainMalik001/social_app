import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/become_influencer_controller.dart';

class BecomeInfluencerScreen extends StatelessWidget {
  const BecomeInfluencerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: Center(
            child: Material(
              color: const Color(0xFF0A0F19),
              borderRadius: BorderRadius.circular(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: Get.back,
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 12.0,
                    color: Color(0xFFF7ECDD),
                  ),
                ),
              ),
            ),
          ),
          leadingWidth: 72.0,
          title: Text(
            'Become a creator',
            style: GoogleFonts.jost(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0A0F19),
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          // child: Column(
          //   children: [
          //     Expanded(
          //       child: ListView(
          //         padding: const EdgeInsets.symmetric(horizontal: 24.0),
          //         children: [
          //           Stack(
          //             children: [
          //               GetBuilder<BecomeInfluencerController>(
          //                 builder: (_) {
          //                   return Stack(
          //                     children: [
          //                       Padding(
          //                         padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 72.0),
          //                         child: AspectRatio(
          //                           aspectRatio: 5 / 2,
          //                           child: _.coverImage == null
          //                               ? Container(
          //                                   decoration: BoxDecoration(
          //                                     color: const Color(0xFFD9D9D9),
          //                                     borderRadius: BorderRadius.circular(12.0),
          //                                   ),
          //                                 )
          //                               : ClipRRect(
          //                                   borderRadius: BorderRadius.circular(12.0),
          //                                   child: Image.file(
          //                                     _.coverImage!.absolute,
          //                                     width: 120.0,
          //                                     height: 120.0,
          //                                     fit: BoxFit.cover,
          //                                   ),
          //                                 ),
          //                         ),
          //                       ),
          //                       Positioned(
          //                         right: 4.0,
          //                         top: 28.0,
          //                         child: Material(
          //                           borderRadius: BorderRadius.circular(12.0),
          //                           color: const Color(0xFF0A0F19),
          //                           child: InkWell(
          //                             onTap: _.getCoverFromGallery,
          //                             child: Padding(
          //                               padding: const EdgeInsets.all(8.0),
          //                               child: SvgPicture.asset(
          //                                 'assets/images/influencer/camera.svg',
          //                                 colorFilter: const ColorFilter.mode(Color(0xFFF7ECDD), BlendMode.srcIn),
          //                                 width: 20,
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                       Positioned.fill(
          //                         child: Align(
          //                           alignment: Alignment.bottomCenter,
          //                           child: SizedBox(
          //                             width: 120.0,
          //                             height: 136.0,
          //                             child: Stack(
          //                               children: [
          //                                 if (_.profileImage == null) ...[
          //                                   Container(
          //                                     width: 120.0,
          //                                     height: 120.0,
          //                                     margin: const EdgeInsets.only(bottom: 12.0),
          //                                     decoration: BoxDecoration(
          //                                       color: const Color(0xFFA3A3A3),
          //                                       borderRadius: BorderRadius.circular(12.0),
          //                                     ),
          //                                   ),
          //                                 ] else ...[
          //                                   ClipRRect(
          //                                     borderRadius: BorderRadius.circular(12.0),
          //                                     child: Image.file(
          //                                       _.profileImage!.absolute,
          //                                       width: 120.0,
          //                                       height: 120.0,
          //                                       fit: BoxFit.cover,
          //                                     ),
          //                                   ),
          //                                 ],
          //                                 Positioned(
          //                                   bottom: 0.0,
          //                                   right: 0.0,
          //                                   child: Material(
          //                                     borderRadius: BorderRadius.circular(12.0),
          //                                     color: const Color(0xFF0A0F19),
          //                                     child: InkWell(
          //                                       onTap: _.getProfileFromGallery,
          //                                       child: Padding(
          //                                         padding: const EdgeInsets.all(8.0),
          //                                         child: SvgPicture.asset(
          //                                           'assets/images/influencer/camera.svg',
          //                                           colorFilter:
          //                                               const ColorFilter.mode(Color(0xFFF7ECDD), BlendMode.srcIn),
          //                                           width: 20,
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   );
          //                 },
          //               )
          //             ],
          //           ),
          //           const SizedBox(height: 24.0),
          //           GetBuilder<BecomeInfluencerController>(
          //             builder: (_) {
          //               return TextField(
          //                 controller: _.usernameController,
          //                 decoration: InputDecoration(
          //                   border: OutlineInputBorder(
          //                     borderSide: const BorderSide(
          //                       width: 1.0,
          //                       color: Color(0xFF0A0F19),
          //                     ),
          //                     borderRadius: BorderRadius.circular(12.0),
          //                   ),
          //                   enabledBorder: OutlineInputBorder(
          //                     borderSide: const BorderSide(
          //                       width: 1.0,
          //                       color: Color(0xFF0A0F19),
          //                     ),
          //                     borderRadius: BorderRadius.circular(12.0),
          //                   ),
          //                   focusedBorder: OutlineInputBorder(
          //                     borderSide: const BorderSide(
          //                       width: 1.0,
          //                       color: Color(0xFF0A0F19),
          //                     ),
          //                     borderRadius: BorderRadius.circular(12.0),
          //                   ),
          //                   labelText: 'Username',
          //                   labelStyle: GoogleFonts.jost(fontSize: 14.0, color: const Color(0x800A0F19)),
          //                   contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          //                 ),
          //                 style: GoogleFonts.jost(fontSize: 14.0, color: const Color(0xFF0A0F19)),
          //                 cursorColor: const Color(0xFF0A0F19),
          //               );
          //             },
          //           ),
          //           const SizedBox(height: 16.0),
          //           GetBuilder<BecomeInfluencerController>(
          //             builder: (_) {
          //               return TextField(
          //                 controller: _.descriptionController,
          //                 decoration: InputDecoration(
          //                   border: OutlineInputBorder(
          //                     borderSide: const BorderSide(
          //                       width: 1.0,
          //                       color: Color(0xFF0A0F19),
          //                     ),
          //                     borderRadius: BorderRadius.circular(12.0),
          //                   ),
          //                   enabledBorder: OutlineInputBorder(
          //                     borderSide: const BorderSide(
          //                       width: 1.0,
          //                       color: Color(0xFF0A0F19),
          //                     ),
          //                     borderRadius: BorderRadius.circular(12.0),
          //                   ),
          //                   focusedBorder: OutlineInputBorder(
          //                     borderSide: const BorderSide(
          //                       width: 1.0,
          //                       color: Color(0xFF0A0F19),
          //                     ),
          //                     borderRadius: BorderRadius.circular(12.0),
          //                   ),
          //                   labelText: 'Write Profile Description',
          //                   labelStyle: GoogleFonts.jost(fontSize: 14.0, color: const Color(0x800A0F19)),
          //                   alignLabelWithHint: true,
          //                   contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          //                 ),
          //                 style: GoogleFonts.jost(fontSize: 14.0, color: const Color(0xFF0A0F19)),
          //                 cursorColor: const Color(0xFF0A0F19),
          //                 maxLength: 120,
          //                 maxLines: 4,
          //                 buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
          //                   return Text(
          //                     '$currentLength/$maxLength',
          //                     style: GoogleFonts.jost(
          //                       fontSize: 14.0,
          //                       fontWeight: FontWeight.w300,
          //                       color: const Color(0xFF0A0F19),
          //                     ),
          //                   );
          //                 },
          //               );
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
          //       child: Material(
          //         color: Colors.black,
          //         borderRadius: BorderRadius.circular(12.0),
          //         child: InkWell(
          //           borderRadius: BorderRadius.circular(12.0),
          //           onTap: Get.find<BecomeInfluencerController>().submitInfluencerRequest,
          //           child: Container(
          //             width: double.infinity,
          //             padding: const EdgeInsets.symmetric(vertical: 12.0),
          //             child: Text(
          //               'Continue',
          //               style: GoogleFonts.jost(
          //                   fontSize: 16.0, fontWeight: FontWeight.w500, color: const Color(0xFFF7ECDD)),
          //               textAlign: TextAlign.center,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     InkWell(
          //       onTap: Get.back,
          //       child: Text(
          //         'Go back',
          //         style: GoogleFonts.jost(
          //           fontSize: 16.0,
          //           decoration: TextDecoration.underline,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child: Image.asset(
                                    'assets/images/settings/influencer/1.png',
                                    fit: BoxFit.cover,
                                    color: Colors.grey,
                                    colorBlendMode: BlendMode.saturation,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child: Image.asset(
                                    'assets/images/settings/influencer/2.png',
                                    fit: BoxFit.cover,
                                    color: Colors.grey,
                                    colorBlendMode: BlendMode.saturation,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24.0),
                            child: Image.asset(
                              'assets/images/settings/influencer/3.png',
                              fit: BoxFit.cover,
                              color: Colors.grey,
                              colorBlendMode: BlendMode.saturation,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                'Become a Creator',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              Text(
                'To continue as a creator, please sign up via Instagram and continue posting with posts with products',
                style: GoogleFonts.jost(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32.0),
              GetBuilder<BecomeInfluencerController>(
                builder: (_) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(16.0),
                    onTap: _.continueWithInsta,
                    child: Ink(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          transform: GradientRotation(-0.87),
                          colors: [
                            Color(0xFFFEF780),
                            Color(0xFFF7772E),
                            Color(0xFFD42F7F),
                            Color(0xFFEF00FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/settings/influencer/insta.png',
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Continue with Instagram',
                            style: GoogleFonts.jost(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }
}
