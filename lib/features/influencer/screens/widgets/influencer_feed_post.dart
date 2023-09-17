import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:rubu/core/models/post_model.dart';
import 'package:rubu/features/feed/screens/utils/product_bottomsheet.dart';
import 'package:rubu/features/influencer/controllers/account_feed_controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:share_plus/share_plus.dart';

class InfluencerFeedPost extends GetView<InfluencerAccountFeedController> {
  final PostModel post;
  final bool isLiked;
  const InfluencerFeedPost({
    super.key,
    required this.post,
    required this.isLiked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 36.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Row(
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
              const Spacer(),
              Text(
                timeago.format(post.createdAt.toDate()),
                style: GoogleFonts.jost(
                  fontSize: 12.0,
                  color: const Color(0xFF0A0F19),
                ),
              ),
              // const SizedBox(width: 8.0),
              // const Icon(
              //   Icons.more_vert_rounded,
              //   color: Color(0xFF0A0F19),
              // ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        // Image.asset(
        //   'assets/images/feed/post/primary.png',
        //   fit: BoxFit.cover,
        // ),
        CachedNetworkImage(
          imageUrl: post.imageURL,
          fit: BoxFit.cover,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 32.0),
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
                  padding: const EdgeInsets.only(right: 8.0),
                  itemCount: post.productModel.length,
                  itemBuilder: (child, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InkWell(
                        onTap: () => ProductBottomsheet.show(post.productModel[index]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: CachedNetworkImage(
                            imageUrl: post.productModel[index].imageUrl,
                            // height: 48.0,
                            // width: 48.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  const SizedBox(width: 24.0),
                  InkWell(
                    onTap: () => controller.togglePostLike(post.postID, isLiked),
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
                    onTap: () => Share.share(post.caption, subject: post.productModel[0].title),
                    child: SvgPicture.asset(
                      'assets/images/feed/post/send.svg',
                      width: 24.0,
                    ),
                  ),
                ],
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
