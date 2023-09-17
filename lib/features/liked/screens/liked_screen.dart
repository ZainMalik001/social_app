import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../home/controllers/home_controller.dart';

class LikedScreen extends StatelessWidget {
  const LikedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Favorite Posts',
          style: GoogleFonts.jost(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: GetBuilder<HomeController>(
        init: HomeController(),
        initState: (_) {},
        builder: (_) {
          if (_.loadingFavoritePosts) {
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
                    'Loading favorite posts...',
                    style: GoogleFonts.jost(),
                  ),
                ],
              ),
            );
          }
          if (!_.isLoggedIn) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not logged in', style: GoogleFonts.jost(fontSize: 24.0)),
                  // const SizedBox(height: 8.0),
                  Text(
                    'Login to add your favorite posts here!',
                    style: GoogleFonts.jost(),
                  ),
                  const SizedBox(height: 24.0),
                  SizedBox(
                    width: Get.width - 48.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.black,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () => Get.toNamed('/loginDialog', arguments: {'isDialog': true}),
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
                  ),
                ],
              ),
            );
          }
          if (_.favoritePostsIDs.isEmpty) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Oops!', style: GoogleFonts.jost(fontSize: 24.0)),
                  const SizedBox(height: 16.0),
                  Text(
                    'You haven\'t added any post to favorites yet',
                    style: GoogleFonts.jost(),
                  ),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              const SizedBox(height: 12.0),
              StaggeredGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                children: [
                  for (var post in _.favoritePosts)
                    StaggeredGridTile.fit(
                      crossAxisCellCount: 1,
                      child: InkWell(
                        onTap: _.toLikedDetailScreen,
                        borderRadius: BorderRadius.circular(12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: AspectRatio(
                            aspectRatio: (Random().nextDouble() * 0.3) + 0.4,
                            child: CachedNetworkImage(
                              imageUrl: post.imageURL,
                              fit: BoxFit.cover,
                              fadeInDuration: Duration.zero,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24.0),
            ],
          );
        },
      ),
    );
  }
}
