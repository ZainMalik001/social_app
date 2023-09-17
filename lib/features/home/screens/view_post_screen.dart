import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/core/widgets/appbar.dart';
import 'package:rubu/features/feed/screens/widgets/feed_post.dart';
import 'package:rubu/features/home/controllers/view_post_controller.dart';

import '../controllers/home_controller.dart';

class ViewPostScreen extends StatelessWidget {
  const ViewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = Get.put(ViewPostController());
    return Scaffold(
      appBar: RubuAppbar(title: 'Post', canPop: true, id: _.id, boldTitle: true),
      body: GetBuilder<ViewPostController>(
        builder: (_) {
          if (_.loading) {
            return SizedBox(
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
                    'Loading post...',
                    style: GoogleFonts.jost(),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: GetBuilder<HomeController>(
              builder: (cntr) {
                return FeedPost(
                  index: 0,
                  post: _.post,
                  isLiked: _.isLiked,
                  isFavorite: _.isFavorite,
                  showMenu: cntr.user.id == _.post.influencerID,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
