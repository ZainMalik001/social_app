import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/feed/controllers/influencer_profile_controller.dart';

import '../../home/controllers/home_controller.dart';

class InfluencerProfileScreen extends StatelessWidget {
  const InfluencerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.create(() => InfluencerProfileController(), permanent: false);
    return Scaffold(
      body: GetBuilder<InfluencerProfileController>(
        builder: (_) {
          if (_.loading) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top, left: 24.0),
                  child: Material(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () {
                        Get.back(id: _.id);
                      },
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
                SizedBox(
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
                        'Loading profile...',
                        style: GoogleFonts.jost(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return SingleChildScrollView(
            child: Stack(
              children: [
                // Image.asset('assets/images/feed/influencer_profile/cover.png'),
                CachedNetworkImage(
                  imageUrl: _.profile.coverImageURL,
                  fadeInDuration: Duration.zero,
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top, left: 24.0),
                  child: Material(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () => Get.back(id: _.id),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 124.0),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: CachedNetworkImage(
                          imageUrl: _.profile.profileImageURL,
                          width: 80.0,
                          fadeInDuration: Duration.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Stack(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                _.profile.fullName,
                                style: GoogleFonts.jost(fontSize: 20.0, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '@${_.profile.username}',
                                style: GoogleFonts.jost(fontSize: 16.0, fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 24.0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () => Get.find<HomeController>().shareInfluencer(_.profile.id),
                                child: SvgPicture.asset('assets/images/influencer/profile/send.svg'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
                      child: Text(
                        _.profile.description,
                        style: GoogleFonts.jost(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 32.0),
                        width: MediaQuery.of(context).size.width / 1.8,
                        height: 2,
                        color: const Color(0xFFF7ECDD),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, bottom: 16.0),
                      child: Text(
                        'Collections',
                        style: GoogleFonts.jost(fontSize: 14.0, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (_.influencerLatestUniqueProducts.isEmpty) ...[
                      Column(
                        children: [
                          const SizedBox(height: 12.0),
                          Text('No Collections', style: GoogleFonts.jost(fontSize: 24.0)),
                          Text(
                            'There are no collections to view yet',
                            style: GoogleFonts.jost(),
                          ),
                          const SizedBox(height: 12.0),
                        ],
                      ),
                    ] else ...[
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 14.0, right: 24.0),
                          itemCount: _.influencerLatestUniqueProducts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12.0),
                                onTap: () =>
                                    _.toCollectionScreen(_.id, _.influencerLatestUniqueProducts[index].category),
                                child: Stack(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        // child: Image.asset(
                                        //     'assets/images/feed/influencer_profile/collections/${_.profile.influencerCollection[index].collectionCategory.toLowerCase()}.png'),
                                        child: CachedNetworkImage(
                                          imageUrl: _.influencerLatestUniqueProducts[index].imageUrl,
                                          fit: BoxFit.cover,
                                          colorBlendMode: BlendMode.darken,
                                          color: Colors.black38,
                                          fadeInDuration: Duration.zero,
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          _.influencerLatestUniqueProducts[index].category,
                                          style: GoogleFonts.jost(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 36.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Recent Posts',
                            style: GoogleFonts.jost(fontSize: 14.0, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    if (_.profile.recentPosts.isEmpty) ...[
                      Column(
                        children: [
                          const SizedBox(height: 12.0),
                          Text('No Recent Posts', style: GoogleFonts.jost(fontSize: 24.0)),
                          Text(
                            'There are no recent posts to view',
                            style: GoogleFonts.jost(),
                          ),
                          const SizedBox(height: 12.0),
                        ],
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: StaggeredGrid.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          children: [
                            for (int i = 0; i < _.profile.recentPosts.length; i++)
                              StaggeredGridTile.fit(
                                crossAxisCellCount: 1,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12.0),
                                  onTap: () => Get.toNamed(
                                    '/viewPost',
                                    id: _.id,
                                    arguments: {
                                      'id': _.id,
                                      'postID': _.profile.recentPosts[i].postID,
                                    },
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: AspectRatio(
                                      aspectRatio: (Random().nextDouble() * 0.3) + 0.4,
                                      child: CachedNetworkImage(
                                        imageUrl: _.profile.recentPosts[i].imageURL,
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
                    SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 16.0),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
