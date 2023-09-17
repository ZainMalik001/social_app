import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rubu/core/models/post_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../home/controllers/home_controller.dart';

class ProductBottomsheet {
  static Future<void> show(ProductModel product, [String? postID]) {
    return Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 24.0 + MediaQuery.of(Get.overlayContext!).padding.bottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                // Image.asset('assets/images/feed/post/secondary.png', width: 160.0, height: 160.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      width: 160.0,
                      height: 160.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: SizedBox(
                    height: 160.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: GoogleFonts.jost(fontSize: 16.0, fontWeight: FontWeight.w600),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          product.priceCurrency != null
                              ? '${product.priceCurrency!} ${product.productPrice}'
                              : 'Price unavailable',
                          style: GoogleFonts.jost(
                              fontSize: 20.0, color: product.priceCurrency != null ? Colors.black : Colors.grey),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            GetBuilder<HomeController>(
                              builder: (_) {
                                return InkWell(
                                  onTap: () => _.togglePostLike(product.id, _.likedPostsIDs.contains(product.id)),
                                  child: _.likedPostsIDs.contains(product.id)
                                      ? SvgPicture.asset(
                                          'assets/images/feed/post/liked.svg',
                                          width: 24.0,
                                          colorFilter: const ColorFilter.mode(Color(0xFFFF4844), BlendMode.srcIn),
                                        )
                                      : SvgPicture.asset(
                                          'assets/images/feed/post/not_liked.svg',
                                          width: 24.0,
                                        ),
                                );
                              },
                            ),
                            const SizedBox(width: 20.0),
                            if (postID != null)
                              InkWell(
                                onTap: () => Get.find<HomeController>().sharePost(postID),
                                child: SvgPicture.asset(
                                  'assets/images/feed/post/send.svg',
                                  width: 24.0,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 28.0),
            Material(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: () => launchUrlString(product.rubuLink, mode: LaunchMode.externalApplication),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Buy Now',
                    style:
                        GoogleFonts.jost(fontSize: 16.0, fontWeight: FontWeight.w500, color: const Color(0xFFF7ECDD)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
