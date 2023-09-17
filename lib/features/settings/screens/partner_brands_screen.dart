import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/core/widgets/appbar.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../controllers/partner_brands_controller.dart';

class PartnerBrandsScreen extends StatelessWidget {
  const PartnerBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RubuAppbar(title: 'Partner Brands', canPop: true),
      body: Column(
        children: [
          const SizedBox(height: 12.0),
          GetBuilder<PartnerBrandsController>(
            init: PartnerBrandsController(),
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
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
                        colorFilter:
                            _.searchFocus.hasFocus ? null : const ColorFilter.mode(Color(0x800A0F19), BlendMode.srcIn),
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
                  onChanged: _.searchProducts,
                ),
              );
            },
          ),
          const SizedBox(height: 32.0),
          GetBuilder<PartnerBrandsController>(
            builder: (_) {
              return Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0) +
                      EdgeInsets.only(bottom: Get.mediaQuery.viewPadding.bottom),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 24.0,
                    mainAxisSpacing: 24.0,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _.partnerBrands.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => launchUrlString(_.partnerBrands[index].website),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              imageUrl: _.partnerBrands[index].photoUrl,
                              fit: BoxFit.cover,
                              fadeInDuration: Duration.zero,
                              placeholderFadeInDuration: Duration.zero,
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
                                    width: 64.0,
                                    height: 64.0,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 1.6,
                                        value: progress.progress,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                _.partnerBrands[index].name,
                                style: GoogleFonts.jost(fontSize: 12.0, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // SvgPicture.asset(
                              //   'assets/images/settings/link.svg',
                              //   color: const Color(0xFF3485FF),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
