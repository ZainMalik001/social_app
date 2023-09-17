import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/feed/screens/utils/product_bottomsheet.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';
import 'package:rubu/features/search/controllers/search_controller.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static const discover = [
    {
      'image': 'assets/images/search/discover/1.png',
      'name': 'Fashion',
    },
    {
      'image': 'assets/images/search/discover/2.png',
      'name': 'Beauty',
    },
    {
      'image': 'assets/images/search/discover/3.png',
      'name': 'Home',
    },
    {
      'image': 'assets/images/search/discover/4.png',
      'name': 'Stores',
    },
    {
      'image': 'assets/images/search/discover/5.png',
      'name': 'Luxury',
    },
    {
      'image': 'assets/images/search/discover/6.png',
      'name': 'Baby',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Get.put(SearchController()).searchFocus.unfocus,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              const SizedBox(height: 12.0),
              GetBuilder<SearchController>(
                builder: (_) {
                  return TextField(
                    focusNode: _.searchFocus,
                    controller: _.controller,
                    decoration: InputDecoration(
                      // isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0x800A0F19)),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF0A0F19)),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0x800A0F19)),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      // fillColor: const Color(0xFFF7ECDD),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          'assets/images/search/search_icon.svg',
                          colorFilter: _.searchFocus.hasFocus
                              ? null
                              : const ColorFilter.mode(Color(0x800A0F19), BlendMode.srcIn),
                        ),
                      ),
                      suffixIcon: _.showClearIcon
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Material(
                                color: const Color(0xFF0A0F19),
                                borderRadius: BorderRadius.circular(8.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8.0),
                                  onTap: _.clearCurrentSearch,
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 16.0,
                                      color: Color(0xFFF7ECDD),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : null,
                      hintText: 'Search',
                      hintStyle: GoogleFonts.jost(fontSize: 14.0, color: const Color(0x800A0F19)),
                    ),
                    cursorColor: Colors.black,
                    style: GoogleFonts.jost(fontSize: 14.0, height: 1.5),
                    onSubmitted: _.searchProducts,
                    onTap: _.update,
                  );
                },
              ),
              const SizedBox(height: 32.0),
              GetBuilder<SearchController>(
                builder: (_) {
                  if (_.loadingSearch) {
                    return SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 48.0),
                          const CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2.0,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Searching products...',
                            style: GoogleFonts.jost(),
                          ),
                        ],
                      ),
                    );
                  }
                  if (_.toggleSearch) {
                    if (_.searchedProducts.isEmpty && _.searchedInfluencers.isEmpty) {
                      return SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 48.0),
                            Text('Oops!', style: GoogleFonts.jost(fontSize: 24.0)),
                            const SizedBox(height: 16.0),
                            Text(
                              'No matches found.',
                              style: GoogleFonts.jost(),
                            ),
                          ],
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_.searchedInfluencers.isNotEmpty)
                          Text(
                            'Influencers',
                            style: GoogleFonts.jost(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        for (var influencer in _.searchedInfluencers)
                          InkWell(
                            onTap: () => Get.find<HomeController>().toInfluencerProfile(2, influencer.influencerID),
                            splashFactory: NoSplash.splashFactory,
                            highlightColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: influencer.influencerProfileURL,
                                      width: 32.0,
                                      height: 32.0,
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    child: Text(
                                      influencer.influencerName,
                                      style: GoogleFonts.jost(fontSize: 16.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (_.searchedProducts.isNotEmpty)
                          Text(
                            'Products',
                            style: GoogleFonts.jost(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 24.0,
                            crossAxisSpacing: 8.0,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: _.searchedProducts.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => ProductBottomsheet.show(
                                _.searchedProducts[index],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(14.0),
                                          child: CachedNetworkImage(
                                            imageUrl: _.searchedProducts[index].imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        top: 8.0,
                                        left: 8.0,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 24.0,
                                              height: 24.0,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(24.0),
                                                child: AspectRatio(
                                                  aspectRatio: 1,
                                                  child: CachedNetworkImage(
                                                    imageUrl: _.searchedProducts[index].influencerImgUrl,
                                                    width: 24.0,
                                                    height: 24.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8.0),
                                            Expanded(
                                              child: Text(
                                                _.searchedProducts[index].influencerName,
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
                                      _.searchedProducts[index].title,
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
                        ),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_.recentSearches.isNotEmpty && _.searchFocus.hasFocus)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Recent Searches',
                              style: GoogleFonts.jost(fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                // final recent = ['Winter Clothing', 'Floral Dresses', 'Leather Boots'];
                                return InkWell(
                                  onTap: () {
                                    _.controller.text = _.recentSearches[index];
                                    _.searchProducts(_.recentSearches[index]);
                                  },
                                  splashFactory: NoSplash.splashFactory,
                                  highlightColor: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_.recentSearches[index], style: GoogleFonts.jost(fontSize: 16.0)),
                                      InkWell(
                                        onTap: () => _.removeRecentSearch(_.recentSearches[index]),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: Color(0xFF0A0F19),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(color: Colors.black);
                              },
                              itemCount: _.recentSearches.length,
                            ),
                            const SizedBox(height: 36.0),
                          ],
                        ),
                      if (!_.searchFocus.hasFocus)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Discover',
                              style: GoogleFonts.jost(fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),
                            GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              mainAxisSpacing: 12.0,
                              crossAxisSpacing: 10.0,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                for (int i = 0; i < 6; i++)
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12.0),
                                    onTap: () => _.toDiscoveryScreen(discover[i]['name']!),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12.0),
                                          child: Image.asset(discover[i]["image"]!),
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              discover[i]['name']!,
                                              style: GoogleFonts.jost(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFFFFFFFF),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 32.0),
                            GetBuilder<HomeController>(
                              builder: (_) {
                                if (_.isLoggedIn) {
                                  return Text(
                                    'Based on your interest',
                                    style: GoogleFonts.jost(fontSize: 16.0, fontWeight: FontWeight.w600),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                            GetBuilder<HomeController>(
                              builder: (_) {
                                if (_.loadingInterestProducts) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 48.0),
                                        const CircularProgressIndicator(
                                          color: Colors.black,
                                          strokeWidth: 2.0,
                                        ),
                                        const SizedBox(height: 16.0),
                                        Text(
                                          'Loading recommended products...',
                                          style: GoogleFonts.jost(),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return GridView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 24.0,
                                    crossAxisSpacing: 8.0,
                                    childAspectRatio: 0.8,
                                  ),
                                  itemCount: _.interestProducts.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () => ProductBottomsheet.show(_.interestProducts[index]),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Stack(
                                            children: [
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
                                                  child: AspectRatio(
                                                    aspectRatio: 1,
                                                    child: CachedNetworkImage(
                                                      imageUrl: _.interestProducts[index].imageUrl,
                                                      fit: BoxFit.cover,
                                                      color: Colors.black26,
                                                      colorBlendMode: BlendMode.darken,
                                                    ),
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
                                                        imageUrl: _.interestProducts[index].influencerImgUrl,
                                                        width: 24.0,
                                                        height: 24.0,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8.0),
                                                    Expanded(
                                                      child: Text(
                                                        _.interestProducts[index].influencerName,
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
                                              _.interestProducts[index].title,
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
                          ],
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
