import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/feed/screens/utils/product_bottomsheet.dart';

import '../controllers/discover_controller.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Center(
          child: Material(
            color: const Color(0xFF0A0F19),
            borderRadius: BorderRadius.circular(8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(8.0),
              onTap: () => Get.back(id: 2),
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
        title: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Discover - '),
              TextSpan(
                text: Get.put(DiscoverController()).args['category'],
                style: GoogleFonts.jost(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          style: GoogleFonts.jost(
            fontSize: 16.0,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: GetBuilder<DiscoverController>(
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
                    'Loading collection...',
                    style: GoogleFonts.jost(),
                  ),
                ],
              ),
            );
          }
          if (_.productList.isEmpty) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Oops!', style: GoogleFonts.jost(fontSize: 24.0)),
                  const SizedBox(height: 16.0),
                  Text(
                    'No product avaiable in this category.',
                    style: GoogleFonts.jost(),
                  ),
                ],
              ),
            );
          }
          return GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 12.0),
            // physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 24.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 0.84,
            ),
            itemCount: _.productList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => ProductBottomsheet.show(_.productList[index]),
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              imageUrl: _.productList[index].imageUrl,
                              fit: BoxFit.cover,
                              colorBlendMode: BlendMode.darken,
                              color: Colors.black26,
                              fadeInDuration: Duration.zero,
                              placeholderFadeInDuration: Duration.zero,
                              progressIndicatorBuilder: (context, url, progress) {
                                return Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey.shade200,
                                  child: SizedBox(
                                    width: 36.0,
                                    height: 36.0,
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
                            ),
                          ),
                        ),
                        Positioned.fill(
                          top: 8.0,
                          left: 8.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(48.0),
                                child: CachedNetworkImage(
                                  imageUrl: _.productList[index].influencerImgUrl,
                                  width: 24.0,
                                  height: 24.0,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  _.productList[index].influencerName,
                                  style: GoogleFonts.jost(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        _.productList[index].title,
                        style: GoogleFonts.jost(fontSize: 12.0, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
