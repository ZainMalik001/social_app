import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';
import 'package:rubu/features/settings/controllers/settings_controller.dart';

class InfluencerAccountScreen extends StatelessWidget {
  const InfluencerAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (_) {
          if (_.isLoading) {
            return Scaffold(
              body: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2.0,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Loading feed...',
                      style: GoogleFonts.jost(),
                    ),
                  ],
                ),
              ),
            );
          }
          return Stack(
            children: [
              // Image.asset('assets/images/influencer/profile/cover.png'),
              CachedNetworkImage(
                imageUrl: _.user.coverImageURL!,
                fadeInDuration: Duration.zero,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 124.0),
                  Center(
                    // child: Image.asset(
                    //   'assets/images/influencer/profile/dp.png',
                    //   width: 88.0,
                    // ),
                    child: GetBuilder<SettingsController>(
                      init: SettingsController(),
                      builder: (controller) {
                        return InkWell(
                          onTap: controller.getProfileFromGallery,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: CachedNetworkImage(
                                  imageUrl: _.user.profileImageURL!,
                                  width: 88.0,
                                  height: 88.0,
                                  fadeInDuration: Duration.zero,
                                  fadeOutDuration: Duration.zero,
                                  placeholder: (context, url) {
                                    return Container(
                                      width: 88.0,
                                      height: 88.0,
                                      color: Colors.grey.shade200,
                                    );
                                  },
                                ),
                              ),
                              if (controller.profilePicLoading)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Stack(
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _.user.fullname!,
                              style: GoogleFonts.jost(fontSize: 20.0, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '@${_.user.username}',
                              style: GoogleFonts.jost(fontSize: 16.0, fontWeight: FontWeight.w300),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      // Positioned(
                      //   right: 24.0,
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       InkWell(
                      //         onTap: () => _.shareInfluencer(_.user.id!),
                      //         child: SvgPicture.asset('assets/images/influencer/profile/send.svg'),
                      //       ),
                      //       const SizedBox(width: 16.0),
                      //       InkWell(
                      //         onTap: () => Get.toNamed('/settings'),
                      //         child: SvgPicture.asset('assets/images/influencer/profile/settings.svg'),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _.user.profileDescription!,
                          style: GoogleFonts.jost(
                            fontSize: 16.0,
                            color: const Color(0xFF0A0F19),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24.0),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10.0),
                              onTap: () => Get.toNamed('/settings'),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Edit',
                                  style: GoogleFonts.jost(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Material(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10.0),
                              onTap: () => _.shareInfluencer(_.user.id!),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Share',
                                  style: GoogleFonts.jost(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      width: MediaQuery.of(context).size.width / 1.8,
                      height: 2,
                      color: const Color(0xFFF7ECDD),
                    ),
                  ),
                  if (_.userInfluencerPosts.isEmpty) ...[
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24.0),
                          Text('No posts', style: GoogleFonts.jost(fontSize: 24.0)),
                          Text(
                            'You haven\'t created any posts yet',
                            style: GoogleFonts.jost(),
                          ),
                          const SizedBox(height: 24.0),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16.0),
                              onTap: () => Get.toNamed('/addProduct'),
                              child: Ink(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A0F19),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text(
                                  'Create post',
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFF7ECDD),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        children: [
                          for (int i = 0; i < _.userInfluencerPosts.length; i++)
                            StaggeredGridTile.fit(
                              crossAxisCellCount: 1,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12.0),
                                onTap: () => Get.toNamed(
                                  '/viewPost',
                                  id: 5,
                                  arguments: {
                                    'id': 5,
                                    'postID': _.userInfluencerPosts[i].postID,
                                  },
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: AspectRatio(
                                    aspectRatio: (Random().nextDouble() * 0.3) + 0.4,
                                    child: CachedNetworkImage(
                                      imageUrl: _.userInfluencerPosts[i].imageURL,
                                      fit: BoxFit.cover,
                                      fadeInDuration: Duration.zero,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
