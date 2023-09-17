import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_basic_display_api/instagram_basic_display_api.dart';
import 'package:rubu/core/controllers/auth_controller.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';
import 'package:rubu/features/settings/controllers/settings_controller.dart';
import 'package:rubu/features/settings/screens/widgets/listtile.dart';

class SettingsScreen extends StatelessWidget {
  final bool canPop;
  const SettingsScreen({super.key, required this.canPop});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final controller = Get.put(SettingsController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !homeController.isLoggedIn || !homeController.user.isInfluencer
          ? null
          : AppBar(
              title: Text(
                'Settings',
                style: GoogleFonts.jost(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: Colors.white,
              leading: canPop
                  ? Center(
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
                    )
                  : null,
              leadingWidth: canPop ? 72.0 : null,
            ),
      body: ListView(
        children: [
          const SizedBox(height: 12.0),
          if (!homeController.isLoggedIn || !homeController.user.isInfluencer)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFB4DADD),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Become a Creator',
                                style: GoogleFonts.dmSerifDisplay(fontSize: 32.0, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                'Sign up as a influencer to post, sell amd promote your product.',
                                style: GoogleFonts.jost(fontSize: 14.0, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32.0),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Image.asset('assets/images/settings/influencer/1.png'),
                                    const SizedBox(height: 8.0),
                                    Image.asset('assets/images/settings/influencer/2.png'),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Image.asset('assets/images/settings/influencer/3.png'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: GetBuilder<HomeController>(
                      builder: (_) {
                        return Material(
                          color: _.isLoggedIn && _.user.accountStatus == 'in_review' ? Colors.black54 : Colors.black,
                          borderRadius: BorderRadius.circular(12.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            // onTap: homeController.user.accountStatus == 'in_review'
                            //     ? null
                            //     : () => Get.toNamed("/successScreen"),
                            onTap: !_.isLoggedIn
                                ? () => Get.toNamed('/loginDialog', arguments: {'isDialog': true})
                                : _.isLoggedIn && _.user.accountStatus == 'in_review'
                                    ? null
                                    : () => Get.toNamed("/becomeInfluencer"),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                !_.isLoggedIn
                                    ? 'Log In'
                                    : _.isLoggedIn && _.user.accountStatus == 'in_review'
                                        ? 'Already submitted'
                                        : 'Become an Influencer',
                                style: GoogleFonts.jost(
                                    fontSize: 16.0, fontWeight: FontWeight.w500, color: const Color(0xFFF7ECDD)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          if (!homeController.isLoggedIn || !homeController.user.isInfluencer) const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0) + const EdgeInsets.only(bottom: 12.0),
            child: Material(
              borderRadius: BorderRadius.circular(12.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: controller.toPartnerBrands,
                child: Ink(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFDFEEF0),
                        Color(0xFFB4DADD),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Partner Brands',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 16.0,
                        ),
                      ),
                      Transform.rotate(
                        angle: -0.8,
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GetBuilder<HomeController>(
            builder: (_) {
              if (_.isLoggedIn) {
                return const SettingsListTile(label: 'Change Profile Settings');
              }
              return const SizedBox();
            },
          ),
          // const SettingsListTile(label: 'Change Email'),
          // const SettingsListTile(label: 'Change Password'),
          GetBuilder<SettingsController>(
            builder: (_) {
              return InkWell(
                onTap: _.toggleNotifications,
                child: Ink(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Push Notifications',
                        style: GoogleFonts.jost(fontSize: 16.0),
                      ),
                      FlutterSwitch(
                        value: _.areNotificationsEnabled,
                        onToggle: _.toggleNotifications,
                        width: 46.0,
                        height: 24.0,
                        padding: 2.0,
                        toggleSize: 20.0,
                        activeColor: const Color(0xFF30D568),
                        inactiveColor: const Color(0xFFBBBBBB),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // InkWell(
          //   onTap: () {
          //     InstagramBasicDisplayApi.askInstagramToken();
          //   },
          //   child: Ink(
          //     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           'Link Instagram',
          //           style: GoogleFonts.jost(fontSize: 16.0),
          //         ),
          //         Transform.rotate(
          //           angle: -0.8,
          //           child: const Icon(
          //             Icons.arrow_forward_rounded,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // InkWell(
          //   onTap: () {
          //     InstagramBasicDisplayApi.logout();
          //   },
          //   child: Ink(
          //     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           'Unlink Instagram',
          //           style: GoogleFonts.jost(fontSize: 16.0),
          //         ),
          //         Transform.rotate(
          //           angle: -0.8,
          //           child: const Icon(
          //             Icons.arrow_forward_rounded,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 24.0),
              width: MediaQuery.of(context).size.width / 1.6,
              height: 2.0,
              color: const Color(0x33000000),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Text(
                'Privacy Policy',
                style: GoogleFonts.jost(fontSize: 16.0),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Text(
                'Term & Conditions',
                style: GoogleFonts.jost(fontSize: 16.0),
              ),
            ),
          ),
          GetBuilder<HomeController>(
            builder: (_) {
              if (_.isLoggedIn) {
                return InkWell(
                  onTap: controller.signOut,
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/images/settings/logout_icon.svg'),
                        const SizedBox(width: 8.0),
                        Text(
                          'Logout',
                          style: GoogleFonts.jost(
                            fontSize: 16.0,
                            // fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          // const SizedBox(height: 24.0),
          // Center(
          //   child: InkWell(
          //     borderRadius: BorderRadius.circular(12.0),
          //     onTap: controller.signOut,
          //     child: Ink(
          //       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          //       decoration: BoxDecoration(
          //         color: const Color(0xFFFF4844),
          //         borderRadius: BorderRadius.circular(12.0),
          //       ),
          //       child: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           SvgPicture.asset('assets/images/settings/logout_icon.svg'),
          //           const SizedBox(width: 8.0),
          //           Text(
          //             'Logout',
          //             style: GoogleFonts.jost(
          //               fontSize: 16.0,
          //               fontWeight: FontWeight.w500,
          //               color: const Color(0xFFFFFFFF),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
