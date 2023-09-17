import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:rubu/core/models/post_model.dart';
import 'package:rubu/features/feed/screens/utils/delete_dialog.dart';
import 'package:rubu/features/feed/screens/utils/product_bottomsheet.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedPost extends GetView<HomeController> {
  final int index;
  final PostModel post;
  final bool isLiked, isFavorite, showMenu;
  const FeedPost({
    super.key,
    required this.index,
    required this.post,
    required this.isLiked,
    required this.isFavorite,
    required this.showMenu,
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
              Expanded(
                child: InkWell(
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  onTap: () => controller.toInfluencerProfile(1, post.influencerID),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 1.0, color: Colors.grey.shade300),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: post.influencerImgUrl,
                            height: 40.0,
                            width: 40.0,
                            fadeInDuration: Duration.zero,
                            placeholder: (context, url) => AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          post.influencerName,
                          style: GoogleFonts.jost(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0A0F19),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                timeago.format(post.createdAt.toDate()),
                style: GoogleFonts.jost(
                  fontSize: 12.0,
                  color: const Color(0xFF0A0F19),
                ),
              ),
              if (showMenu) const SizedBox(width: 8.0),
              // InkWell(
              //   onTap: () {},
              //   child: const Icon(Icons.more_vert),
              // ),
              if (showMenu)
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Get.toNamed('/editPost', arguments: post);
                    }
                    if (value == 'delete') {
                      DeletePostDialog.show(post.postID);
                    }
                  },
                  splashRadius: 0.1,
                  enabled:
                      Get.find<HomeController>().isLoggedIn && Get.find<HomeController>().user.id == post.influencerID,
                  offset: const Offset(0.0, 32.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  itemBuilder: (BuildContext bc) {
                    return [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              "Edit Post",
                              style: GoogleFonts.jost(),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              "Delete Post",
                              style: GoogleFonts.jost(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  child: const Icon(Icons.more_vert),
                )
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        AspectRatio(
          aspectRatio: 1,
          child: CachedNetworkImage(
            imageUrl: post.imageURL,
            fit: BoxFit.cover,
            fadeInDuration: Duration.zero,
            // placeholder: (context, url) => Container(color: Colors.grey.shade200),
            progressIndicatorBuilder: (context, url, progress) {
              if (progress.progress == null) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.grey.shade200,
                );
              }
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey.shade200,
                child: SizedBox(
                  width: 72.0,
                  height: 72.0,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2.0,
                      value: progress.progress,
                    ),
                  ),
                ),
              );
            },
            errorWidget: (context, url, error) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 48.0,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
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
            mainAxisSize: MainAxisSize.min,
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
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: CachedNetworkImage(
                                imageUrl: post.productModel[index].imageUrl,
                                // height: 48.0,
                                // width: 48.0,
                                fadeInDuration: Duration.zero,
                                placeholder: (context, url) => Container(color: Colors.grey.shade200),
                                errorWidget: (context, url, _) => Container(color: Colors.grey.shade200),
                                fit: BoxFit.cover,
                              ),
                            ),
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
                  const SizedBox(width: 16.0),
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
                    onTap: () => controller.togglePostFavorite(post.postID, isFavorite),
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
                    onTap: () => controller.sharePost(post.postID),
                    child: SvgPicture.asset(
                      'assets/images/feed/post/send.svg',
                      width: 24.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
        // const SizedBox(height: 16.0),
      ],
    );
  }
}
