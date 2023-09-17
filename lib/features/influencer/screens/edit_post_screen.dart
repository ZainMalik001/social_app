import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/influencer/controllers/edit_post_controller.dart';
import 'package:rubu/features/influencer/screens/widgets/add_product_textfield.dart';

class EditPostScreen extends StatelessWidget {
  const EditPostScreen({super.key});

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
            'Edit post',
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
            Flexible(
              child: GetBuilder<EditPostController>(
                builder: (_) {
                  return ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    reverse: true,
                    children: [
                      const SizedBox(height: 16.0),
                      Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                if (_.postImage != null) ...[
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12.0),
                                    onTap: _.addPostImage,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.file(_.postImage!.absolute),
                                    ),
                                  ),
                                ] else ...[
                                  InkWell(
                                    borderRadius: BorderRadius.circular(12.0),
                                    onTap: _.addPostImage,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: CachedNetworkImage(
                                        imageUrl: _.postImageURL,
                                        fadeInDuration: Duration.zero,
                                        colorBlendMode: BlendMode.lighten,
                                        color: Colors.white12,
                                      ),
                                    ),
                                  )
                                ],
                                Positioned.fill(
                                  child: Center(
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: Material(
                                        borderRadius: BorderRadius.circular(12.0),
                                        color: const Color(0xFF0A0F19),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(12.0),
                                          onTap: _.addPostImage,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SvgPicture.asset(
                                              'assets/images/influencer/camera.svg',
                                              colorFilter: const ColorFilter.mode(Color(0xFFF7ECDD), BlendMode.srcIn),
                                              width: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _.descriptionController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Color(0xFF0A0F19),
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Color(0xFF0A0F19),
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Color(0xFF0A0F19),
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          labelText: 'Write Post Description',
                          labelStyle: GoogleFonts.jost(fontSize: 14.0, color: const Color(0x800A0F19)),
                          alignLabelWithHint: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          counter: const SizedBox(),
                        ),
                        style: GoogleFonts.jost(fontSize: 14.0, color: const Color(0xFF0A0F19)),
                        cursorColor: const Color(0xFF0A0F19),
                        maxLength: 120,
                        maxLines: 4,
                        // buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                        // return Text(
                        //   '$currentLength/$maxLength',
                        //   style: GoogleFonts.jost(
                        //     fontSize: 14.0,
                        //     fontWeight: FontWeight.w300,
                        //     color: const Color(0xFF0A0F19),
                        //   ),
                        // );
                        // },
                      ),
                      if (_.productData.isNotEmpty)
                        Column(
                          children: [
                            for (int i = 0; i < _.productData.length; i++)
                              if (_.productData[i] is TextEditingController)
                                AddProductTextField(
                                  index: i,
                                  controller: _.productData[i],
                                  addProduct: _.addProduct,
                                  removeController: () => _.removeController(i),
                                  hintText: 'Product URL',
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${i + 1}'.padLeft(2, '0'),
                                        style: GoogleFonts.jost(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0x800A0F19),
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: _.productData[i]['image'] is File
                                            ? Image.file(
                                                _.productData[i]['image'],
                                                width: 48.0,
                                                height: 48.0,
                                                fit: BoxFit.cover,
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: _.productData[i]['image'],
                                                width: 48.0,
                                                height: 48.0,
                                                fadeInDuration: Duration.zero,
                                              ),
                                      ),
                                      const SizedBox(width: 12.0),
                                      Expanded(
                                        child: Text(
                                          _.productData[i]['title'],
                                          style: GoogleFonts.jost(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 12.0),
                                      Text(
                                        '${_.productData[i]["price"]["currency"]}${_.productData[i]["price"]["amount"]}',
                                        style: GoogleFonts.jost(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                      ),
                                      const SizedBox(width: 16.0),
                                      InkWell(
                                        onTap: () {
                                          _.productData.removeAt(i);
                                          _.update();
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/influencer/add_product/trash.svg',
                                          width: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ],
                        )
                      else
                        const SizedBox(),
                      const SizedBox(height: 16.0),
                      InkWell(
                        onTap: _.productData.last is TextEditingController ? null : _.tagAnotherProduct,
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/images/influencer/add_product/tag.svg'),
                            const SizedBox(width: 8.0),
                            Text(
                              _.productData.isEmpty ? 'Tag a product' : 'Tag another product',
                              style: GoogleFonts.jost(
                                  fontSize: 16.0,
                                  color: _.productData.last is TextEditingController
                                      ? Colors.grey.shade800
                                      : Colors.black),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ].reversed.toList(),
                  );
                },
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GetBuilder<EditPostController>(
                  builder: (_) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
                      child: Material(
                        color: _.isComplete ? Colors.black : Colors.black54,
                        borderRadius: BorderRadius.circular(12.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.0),
                          onTap: _.isComplete ? _.updatePost : null,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              'Update post',
                              style: GoogleFonts.jost(
                                  fontSize: 16.0, fontWeight: FontWeight.w500, color: const Color(0xFFF7ECDD)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height:
                      MediaQuery.of(context).viewInsets.bottom == 0 ? MediaQuery.of(context).viewPadding.bottom : 0.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
