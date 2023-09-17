import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/account_feed_controller.dart';
import 'widgets/influencer_feed_post.dart';

class InfluencerAccountFeedScreen extends StatelessWidget {
  const InfluencerAccountFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(InfluencerAccountFeedController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: GetBuilder<InfluencerAccountFeedController>(
          builder: (_) {
            return Text(
              _.influencerName,
              style: GoogleFonts.jost(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            );
          },
        ),
        centerTitle: true,
        leading: Center(
          child: Material(
            color: const Color(0xFF0A0F19),
            borderRadius: BorderRadius.circular(8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(8.0),
              onTap: () => Get.back(id: 4),
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
      ),
      body: GetBuilder<InfluencerAccountFeedController>(
        builder: (_) {
          return ListView.builder(
            itemCount: _.posts.length,
            itemBuilder: (context, index) {
              return InfluencerFeedPost(
                post: _.posts[index],
                isLiked: _.likedPosts.contains(_.posts[index].postID),
              );
              // return const InfluencerFeedPost();
            },
          );
        },
      ),
    );
  }
}
