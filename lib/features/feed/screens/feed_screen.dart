import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';
// import 'package:scroll_snap_list/scroll_snap_list.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import 'package:snappy_list_view/snappy_list_view.dart';
import 'widgets/feed_post.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (_) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Image.asset("assets/images/evershop_logo_splash.jpeg", height: 24.0),
              elevation: 0.0,
              backgroundColor: Colors.white,
              centerTitle: false,
              titleSpacing: 16.0,
            ),
            body: CustomRefreshIndicator(
              offsetToArmed: 72.0,
              onRefresh: _.pullToRefresh,
              builder: (context, child, controller) {
                return Stack(
                  children: [
                    // if (controller.state.isLoading)
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24.0),
                          CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 1.8,
                            value: controller.isDragging || controller.isArmed
                                ? controller.value.clamp(0.0, 1.0)
                                : controller.isIdle
                                    ? 0.0
                                    : null,
                          ),
                        ],
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0.0, controller.value * 72.0),
                      child: child,
                    ),
                  ],
                );
              },
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                controller: _.feedScrollController,
                children: [
                  // if (!_.user.isInfluencer)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 16.0),
                    child: Text(
                      'Trending 🔥',
                      style: GoogleFonts.jost(fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  // if (!_.user.isInfluencer)
                  SizedBox(
                    height: 84.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(right: 16.0),
                      itemCount: _.discoverInfluencers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 56.0,
                          margin: const EdgeInsets.only(left: 16.0),
                          child: GestureDetector(
                            onTap: () => _.toInfluencerProfile(1, _.discoverInfluencers[index].influencerID),
                            child: Column(
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: _.discoverInfluencers[index].influencerProfileURL,
                                    width: 56.0,
                                    height: 56.0,
                                    fadeInDuration: Duration.zero,
                                    placeholderFadeInDuration: Duration.zero,
                                    // placeholder: (context, url) {
                                    //   return Container(
                                    //     width: 56.0,
                                    //     height: 56.0,
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.grey.shade200,
                                    //       shape: BoxShape.circle,
                                    //     ),
                                    //   );
                                    // },

                                    progressIndicatorBuilder: (context, url, progress) {
                                      if (progress.progress == null) {
                                        return Container(
                                          width: 56.0,
                                          height: 56.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey.shade200,
                                          ),
                                        );
                                      }
                                      return Container(
                                        width: 56.0,
                                        height: 56.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade200,
                                        ),
                                        child: SizedBox(
                                          width: 40.0,
                                          height: 40.0,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                              strokeWidth: 1.2,
                                              value: progress.progress,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  _.discoverInfluencers[index].influencerName,
                                  style: GoogleFonts.jost(fontSize: 12.0),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                    color: const Color(0x80000000),
                    height: 0.2,
                    width: double.infinity,
                  ),
                  GetBuilder<HomeController>(
                    builder: (_) {
                      if (_.noPosts) {
                        return Column(
                          children: [
                            const SizedBox(height: 48.0),
                            Text('Oops!', style: GoogleFonts.jost(fontSize: 24.0)),
                            const SizedBox(height: 16.0),
                            Text('There are no posts to view', style: GoogleFonts.jost()),
                          ],
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _.posts.length,
                        itemBuilder: (child, index) {
                          if (index + 1 == _.posts.length && _.endOfPosts) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FeedPost(
                                  index: index,
                                  isFavorite: _.favoritePostsIDs.contains(_.posts[index].postID),
                                  post: _.posts[index],
                                  isLiked: _.likedPostsIDs.contains(_.posts[index].postID),
                                  showMenu: false,
                                ),
                                const SizedBox(height: 12.0),
                                Text(
                                  'End of posts',
                                  style: GoogleFonts.jost(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24.0),
                              ],
                            );
                          }
                          return FeedPost(
                            index: index,
                            isFavorite: _.favoritePostsIDs.contains(_.posts[index].postID),
                            post: _.posts[index],
                            isLiked: _.likedPostsIDs.contains(_.posts[index].postID),
                            showMenu: false,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  //         body: GetBuilder<HomeController>(
  //           builder: (_) {
  //             return ScrollablePositionedList.builder(
  //               // scrollDirection: Axis.vertical,
  //               shrinkWrap: true,
  //               itemScrollController: _.feedScrollController,
  //               scrollOffsetListener: _.feedScrollListener,
  //               itemCount: _.posts.length + 1,
  //               itemBuilder: (context, index) {
  //                 if (index == 0) {
  //                   return Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     crossAxisAlignment: CrossAxisAlignment.stretch,
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 16.0),
  //                         child: Text(
  //                           'Trending 🔥',
  //                           style: GoogleFonts.jost(fontSize: 16.0, fontWeight: FontWeight.w500),
  //                         ),
  //                       ),
  //                       // if (!_.user.isInfluencer)
  //                       SizedBox(
  //                         height: 84.0,
  //                         child: ListView.builder(
  //                           shrinkWrap: true,
  //                           scrollDirection: Axis.horizontal,
  //                           padding: const EdgeInsets.only(right: 16.0),
  //                           itemCount: _.discoverInfluencers.length,
  //                           itemBuilder: (context, index) {
  //                             return Container(
  //                               width: 56.0,
  //                               margin: const EdgeInsets.only(left: 16.0),
  //                               child: GestureDetector(
  //                                 onTap: () => _.toInfluencerProfile(1, _.discoverInfluencers[index].influencerID),
  //                                 child: Column(
  //                                   children: [
  //                                     ClipOval(
  //                                       child: CachedNetworkImage(
  //                                         imageUrl: _.discoverInfluencers[index].influencerProfileURL,
  //                                         width: 56.0,
  //                                         height: 56.0,
  //                                       ),
  //                                     ),
  //                                     const SizedBox(height: 4.0),
  //                                     Text(
  //                                       _.discoverInfluencers[index].influencerName,
  //                                       style: GoogleFonts.jost(fontSize: 12.0),
  //                                       overflow: TextOverflow.fade,
  //                                       maxLines: 1,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                       ),
  //                       Container(
  //                         margin: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
  //                         color: const Color(0x80000000),
  //                         height: 0.2,
  //                         width: double.infinity,
  //                       ),
  //                     ],
  //                   );
  //                 }
  //                 if (_.noPosts) {
  //                   return Column(
  //                     children: [
  //                       const SizedBox(height: 48.0),
  //                       Text('Oops!', style: GoogleFonts.jost(fontSize: 24.0)),
  //                       const SizedBox(height: 16.0),
  //                       Text('There are no posts to view', style: GoogleFonts.jost()),
  //                     ],
  //                   );
  //                 }
  //                 return FeedPost(
  //                   index: index - 1,
  //                   post: _.posts[index - 1],
  //                   isLiked: _.likedPostsIDs.contains(_.posts[index - 1].postID),
  //                   isFavorite: _.favoritePostsIDs.contains(_.posts[index - 1].postID),
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //     );
  //   },
  // );
}
