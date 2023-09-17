import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:rubu/features/feed/screens/utils/product_bottomsheet.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';
import 'package:rubu/features/liked/controllers/liked_detail_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/models/post_model.dart';

class LikedPost extends StatelessWidget {
  final PostModel post;

  final bool isLiked, isFavorite;
  const LikedPost({
    super.key,
    required this.post,
    required this.isLiked,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              InkWell(
                onTap: () => Get.find<HomeController>().toInfluencerProfile(4, post.influencerID),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(64.0),
                      child: CachedNetworkImage(
                        imageUrl: post.influencerImgUrl,
                        height: 40.0,
                        width: 40.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      post.influencerName,
                      style: GoogleFonts.jost(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0A0F19),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                timeago.format(post.createdAt.toDate()),
                style: GoogleFonts.jost(
                  fontSize: 12.0,
                  color: const Color(0xFF0A0F19),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        CachedNetworkImage(
          imageUrl: post.imageURL,
          fit: BoxFit.cover,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 16.0),
          decoration: const BoxDecoration(
            color: Color(0x4DF7ECDD),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 124,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 16.0, left: 8.0),
                  itemCount: post.productModel.length,
                  itemBuilder: (child, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InkWell(
                        onTap: () => ProductBottomsheet.show(post.productModel[index], post.postID),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              imageUrl: post.productModel[index].imageUrl,
                              fit: BoxFit.cover,
                              // height: 48.0,
                              // width: 48.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24.0),
              GetBuilder<LikedDetailController>(
                init: LikedDetailController(),
                initState: (_) {},
                builder: (_) {
                  return Row(
                    children: [
                      const SizedBox(width: 16.0),
                      InkWell(
                        onTap: () => _.toggleLike(post.postID, isLiked),
                        child: isLiked
                            ? SvgPicture.asset(
                                'assets/images/feed/post/liked.svg',
                                width: 24.0,
                                colorFilter: const ColorFilter.mode(Color(0xFFFF4844), BlendMode.srcIn),
                              )
                            : SvgPicture.asset(
                                'assets/images/feed/post/not_liked.svg',
                                width: 24.0,
                              ),
                      ),
                      const SizedBox(width: 16.0),
                      InkWell(
                        onTap: () => _.toggleFavorite(post.postID, isFavorite),
                        child: isFavorite
                            ? SvgPicture.asset(
                                'assets/images/feed/post/favorited.svg',
                                width: 22.0,
                                colorFilter: const ColorFilter.mode(Color(0xFF292D32), BlendMode.srcIn),
                              )
                            : SvgPicture.asset(
                                'assets/images/feed/post/not_favorited.svg',
                                width: 22.0,
                              ),
                      ),
                      const SizedBox(width: 16.0),
                      InkWell(
                        onTap: () => Get.find<HomeController>().sharePost(post.postID),
                        child: SvgPicture.asset(
                          'assets/images/feed/post/send.svg',
                          width: 24.0,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ReadMoreText(
                  post.caption,
                  style: GoogleFonts.jost(fontSize: 14.0),
                  trimLines: 1,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'more',
                  trimExpandedText: ' less',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
