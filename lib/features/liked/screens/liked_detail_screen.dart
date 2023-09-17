import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/liked/controllers/liked_detail_controller.dart';

import 'widgets/liked_post.dart';

class LikedDetailScreen extends StatelessWidget {
  const LikedDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Favorite Posts',
          style: GoogleFonts.jost(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
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
      body: GetBuilder<LikedDetailController>(
        init: LikedDetailController(),
        builder: (_) {
          if (_.posts.isEmpty) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Oops!', style: GoogleFonts.jost(fontSize: 24.0)),
                  const SizedBox(height: 16.0),
                  Text(
                    'You haven\'t liked any post yet',
                    style: GoogleFonts.jost(),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: _.posts.length,
            itemBuilder: (context, index) {
              return LikedPost(
                post: _.posts[index],
                isLiked: _.likedPostsIDs.contains(_.posts[index].postID),
                isFavorite: true,
              );
            },
          );
        },
      ),
    );
  }
}
