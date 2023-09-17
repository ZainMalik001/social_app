import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_basic_display_api/instagram_basic_display_api.dart';
import 'package:rubu/features/influencer/controllers/add_post_controller.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Importing from',
                style: GoogleFonts.jost(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8.0),
              Image.asset('assets/images/settings/influencer/insta_color.png'),
            ],
          ),
          centerTitle: true,
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
          leadingWidth: 56.0,
          // actions: [
          //   InkWell(
          //     splashFactory: NoSplash.splashFactory,
          //     highlightColor: Colors.transparent,
          //     onTap: () => Get.toNamed('/createPost'),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text(
          //           'From Phone',
          //           style: GoogleFonts.jost(
          //             fontSize: 12.0,
          //             fontWeight: FontWeight.w500,
          //             color: Colors.black,
          //           ),
          //         ),
          //         const SizedBox(width: 6.0),
          //         Container(
          //           decoration: BoxDecoration(
          //             color: Colors.black,
          //             borderRadius: BorderRadius.circular(4.0),
          //           ),
          //           child: const Icon(
          //             Icons.add_rounded,
          //             color: Colors.white,
          //             size: 16.0,
          //           ),
          //         ),
          //         const SizedBox(width: 16.0),
          //       ],
          //     ),
          //   ),
          // ],
        ),
        body: Column(
          children: [
            Expanded(
              child: GetBuilder<AddPostController>(
                builder: (_) {
                  if (_.instaPostsLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Loading Instagram posts...',
                            style: GoogleFonts.jost(),
                          ),
                        ],
                      ),
                    );
                  }
                  if (_.instagramPosts == null) {
                    return ListView(
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
                          'Session Expired',
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 40.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'To continue as a creator, please sign in via Instagram and continue posting posts with products',
                          style: GoogleFonts.jost(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        Material(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            onTap: _.loginToInstagram,
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
                                borderRadius: BorderRadius.circular(12.0),
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
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.0,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Text(
                              'OR',
                              style: GoogleFonts.jost(
                                fontSize: 12.0,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                              child: Container(
                                height: 1.0,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          color: Colors.black,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            onTap: () => Get.toNamed('/createPost'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon(
                                  //   Platform.isIOS ? Icons.phone_iphone_rounded : Icons.phone_android_rounded,
                                  //   color: Colors.white,
                                  // ),
                                  // const SizedBox(width: 8.0),
                                  Text(
                                    'Add post from phone',
                                    style: GoogleFonts.jost(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  if (_.instagramPosts!.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Oops!', style: GoogleFonts.jost(fontSize: 16.0)),
                        const SizedBox(height: 16.0),
                        Text(
                          'There\'s no post to import',
                          style: GoogleFonts.jost(),
                        ),
                      ],
                    );
                  }
                  return GridView.builder(
                    // shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: _.instagramPosts!.length,
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (child, index) {
                      if (_.instagramPosts![index].id == _.selectedPost?.id) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2.0,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: CachedNetworkImage(
                                    imageUrl: _.instagramPosts![index].mediaUrl,
                                    colorBlendMode: BlendMode.darken,
                                    color: Colors.black12,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 8.0,
                              top: 8.0,
                              child: Container(
                                padding: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 12.0,
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      return Opacity(
                        opacity: _.selectedPost != null ? 0.6 : 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2.0,
                              color: Get.theme.scaffoldBackgroundColor,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8.0),
                            onTap: () => _.setSelectedPost(_.instagramPosts![index]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: CachedNetworkImage(
                                  imageUrl: _.instagramPosts![index].mediaUrl,
                                  fadeInDuration: Duration.zero,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            GetBuilder<AddPostController>(
              builder: (_) {
                if (_.selectedPost != null) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
                    child: Material(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.0),
                        onTap: _.toCreatePost,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Add Selected Post',
                            style: GoogleFonts.jost(
                                fontSize: 16.0, fontWeight: FontWeight.w500, color: const Color(0xFFF7ECDD)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
          ],
        ),
      ),
    );
  }
}
