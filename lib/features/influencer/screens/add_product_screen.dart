import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/core/constants/currencies.dart';
import 'package:rubu/features/influencer/screens/widgets/textfield.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/constants/categories.dart';
import '../../../core/widgets/dropdown.dart';
import '../controllers/add_product_controller.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Add product',
            style: GoogleFonts.jost(
              fontSize: 16.0,
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
                onTap: Get.back,
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GetBuilder<AddProductController>(
              builder: (_) {
                return Flexible(
                  child: _.loading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2.0,
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'Fetching product data...',
                              style: GoogleFonts.jost(),
                            ),
                          ],
                        )
                      : ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          reverse: true,
                          children: [
                            const SizedBox(height: 16.0),
                            // InfluencerTextField(controller: _.productURL, hintText: 'Product URL'),
                            // const Divider(),
                            // const SizedBox(height: 20.0),

                            if (!_.loading)
                              Column(
                                children: [
                                  Center(
                                    child: SizedBox(
                                      width: 160.0,
                                      height: 166.0,
                                      child: Stack(
                                        children: [
                                          if (_.imageUrl != null)
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12.0),
                                              child: Image.file(
                                                _.productImage,
                                                width: 160.0,
                                                height: 160.0,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          else
                                            SizedBox(
                                              width: 160.0,
                                              height: 160.0,
                                              child: Material(
                                                color: const Color(0xFFD9D9D9),
                                                borderRadius: BorderRadius.circular(12.0),
                                                child: InkWell(
                                                  onTap: _.addProductImage,
                                                  borderRadius: BorderRadius.circular(12.0),
                                                ),
                                              ),
                                            ),
                                          Positioned(
                                            bottom: 0.0,
                                            right: 0.0,
                                            child: Material(
                                              borderRadius: BorderRadius.circular(12.0),
                                              color: const Color(0xFF0A0F19),
                                              child: InkWell(
                                                onTap: _.addProductImage,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SvgPicture.asset(
                                                    'assets/images/influencer/camera.svg',
                                                    colorFilter:
                                                        const ColorFilter.mode(Color(0xFFF7ECDD), BlendMode.srcIn),
                                                    width: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 36.0),
                                  InfluencerTextField(controller: _.productTitle, hintText: 'Product Title'),
                                  const SizedBox(height: 16.0),
                                  CustomDropdown<String>(
                                    onChange: (String value, int index) => _.setCategory(value),
                                    dropdownButtonStyle: DropdownButtonStyle(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(width: 1.0, color: Color(0xFF0A0F19)),
                                          borderRadius: BorderRadius.circular(12.0)),
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                                    ),
                                    dropdownStyle: DropdownStyle(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    ),
                                    items: ProductCategories.list
                                        .asMap()
                                        .entries
                                        .map(
                                          (item) => DropdownItem<String>(
                                            value: item.value,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                              child: Text(
                                                item.value,
                                                style: GoogleFonts.jost(fontSize: 14.0, color: const Color(0xFF0A0F19)),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    child: Text(
                                      'Category',
                                      style: GoogleFonts.jost(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomDropdown<String>(
                                          onChange: (String value, int index) => _.setCurrency(value.toUpperCase()),
                                          initialValue: _.priceCurrency,
                                          dropdownButtonStyle: DropdownButtonStyle(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(width: 1.0, color: Color(0xFF0A0F19)),
                                              borderRadius: BorderRadius.circular(
                                                12.0,
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                          ),
                                          dropdownStyle: DropdownStyle(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12.0),
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          ),
                                          items: Currencies.list
                                              .asMap()
                                              .entries
                                              .map(
                                                (item) => DropdownItem<String>(
                                                  value: item.value,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                                    child: Text(
                                                      item.value,
                                                      style: GoogleFonts.jost(
                                                          fontSize: 14.0, color: const Color(0xFF0A0F19)),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          child: Text(
                                            'SAR',
                                            style: GoogleFonts.jost(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF0A0F19),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        flex: 3,
                                        child: InfluencerTextField(
                                          controller: _.productPrice,
                                          hintText: 'Product Price',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ].reversed.toList(),
                        ),
                );
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
                  child: GetBuilder<AddProductController>(
                    builder: (_) {
                      return Material(
                        color: _.isComplete ? Colors.black : Colors.black54,
                        borderRadius: BorderRadius.circular(12.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.0),
                          onTap: _.isIncomplete ? null : _.addProductToPost,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              'Add',
                              style: GoogleFonts.jost(
                                  fontSize: 16.0, fontWeight: FontWeight.w500, color: const Color(0xFFF7ECDD)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height:
                      MediaQuery.of(context).viewInsets.bottom == 0 ? MediaQuery.of(context).viewPadding.bottom : 0.0,
                ),
              ],
            ),
          ],
        ),
        // floatingActionButton: Offstage(
        //   offstage: true,
        //   child: WebViewWidget(
        //     controller: Get.find<AddProductController>().webViewController,
        //   ),
        // ),
      ),
    );
  }
}
