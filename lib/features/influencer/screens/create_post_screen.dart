import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/influencer/screens/widgets/add_product_textfield.dart';

import '../controllers/create_post_controller.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

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
            'Add a post',
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
              child: GetBuilder<CreatePostController>(
                builder: (_) {
                  if (_.loading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Loading post...',
                            style: GoogleFonts.jost(),
                          ),
                        ],
                      ),
                    );
                  }
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
                                  Material(
                                    color: const Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12.0),
                                      onTap: _.addPostImage,
                                    ),
                                  )
                                ],
                                _.postImage == null
                                    ? Positioned.fill(
                                        child: Center(
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
                                                  colorFilter:
                                                      const ColorFilter.mode(Color(0xFFF7ECDD), BlendMode.srcIn),
                                                  width: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
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
                        maxLength: 200,
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
                                        child: Image.file(
                                          _.productData[i]['image'],
                                          width: 48.0,
                                          height: 48.0,
                                          fit: BoxFit.cover,
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
                                        '${_.productData[i]["price"]["currency"]} ${_.productData[i]["price"]["amount"]}',
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
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: Colors.transparent,
                        onTap: _.productData.isNotEmpty && _.productData.last is TextEditingController
                            ? null
                            : _.tagAnotherProduct,
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/images/influencer/add_product/tag.svg'),
                            const SizedBox(width: 8.0),
                            Text(
                              _.productData.isEmpty ? 'Tag a product' : 'Tag another product',
                              style: GoogleFonts.jost(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // const SizedBox(height: 16.0),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Container(
                      //         height: 1.0,
                      //         color: Colors.black54,
                      //       ),
                      //     ),
                      //     const SizedBox(width: 20.0),
                      //     Text(
                      //       'OR',
                      //       style: GoogleFonts.jost(
                      //         fontSize: 12.0,
                      //         color: Colors.black54,
                      //       ),
                      //     ),
                      //     const SizedBox(width: 20.0),
                      //     Expanded(
                      //       child: Container(
                      //         height: 1.0,
                      //         color: Colors.black54,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 24.0),
                      // Text(
                      //   'Import Instagram Post',
                      //   style: GoogleFonts.jost(
                      //     fontSize: 16.0,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      // const SizedBox(height: 16.0),
                      // GetBuilder<CreatePostController>(
                      //   builder: (_) {
                      //     if (_.instaPostsLoading) {
                      //       return Column(
                      //         children: [
                      //           const CircularProgressIndicator(
                      //             strokeWidth: 2.0,
                      //             color: Colors.black,
                      //           ),
                      //           const SizedBox(height: 16.0),
                      //           Text(
                      //             'Loading Instagram posts...',
                      //             style: GoogleFonts.jost(),
                      //           ),
                      //         ],
                      //       );
                      //     }
                      //     if (_.instagramPosts == null) {
                      //       return SizedBox(
                      //         width: double.infinity,
                      //         child: Material(
                      //           borderRadius: BorderRadius.circular(16.0),
                      //           color: Colors.black,
                      //           child: InkWell(
                      //             borderRadius: BorderRadius.circular(16.0),
                      //             onTap: _.loginInsta,
                      //             // onTap: () => Get.toNamed('/home'),
                      //             child: Padding(
                      //               padding: const EdgeInsets.symmetric(vertical: 16.0),
                      //               child: Text(
                      //                 'Login to Instagram',
                      //                 style: GoogleFonts.dmSerifDisplay(
                      //                   fontSize: 20.0,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: Colors.white,
                      //                 ),
                      //                 textAlign: TextAlign.center,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     }
                      //     if (_.instagramPosts!.isEmpty) {
                      //       return Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Text('Oops!', style: GoogleFonts.jost(fontSize: 24.0)),
                      //           const SizedBox(height: 16.0),
                      //           Text(
                      //             'There\'s no post to import',
                      //             style: GoogleFonts.jost(),
                      //           ),
                      //         ],
                      //       );
                      //     }
                      //     return GridView.builder(
                      //       shrinkWrap: true,
                      //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //           crossAxisCount: 3, crossAxisSpacing: 12.0, mainAxisSpacing: 12.0),
                      //       itemCount: _.instagramPosts!.length,
                      //       itemBuilder: (child, index) {
                      //         return ClipRRect(
                      //           borderRadius: BorderRadius.circular(8.0),
                      //           child: AspectRatio(
                      //             aspectRatio: 1,
                      //             child: CachedNetworkImage(
                      //               imageUrl: _.instagramPosts![index].mediaUrl,
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),
                      // const SizedBox(height: 16.0),
                    ].reversed.toList(),
                  );
                },
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 12.0),
            //   padding: const EdgeInsets.all(16.0),
            //   decoration: BoxDecoration(
            //     color: const Color(0xFFF8ECDD),
            //     borderRadius: BorderRadius.circular(12.0),
            //   ),
            //   child: GetBuilder<CreatePostController>(
            //     builder: (_) {
            //       return Row(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           // Image.asset('assets/images/influencer/add_product/product.png', width: 120.0),
            //           ClipRRect(
            //             borderRadius: BorderRadius.circular(12.0),
            //             child: Image.file(_.productImage, width: 120.0),
            //           ),
            //           const SizedBox(width: 16.0),
            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.stretch,
            //               children: [
            //                 Text(
            //                   _.productTitle,
            //                   style: GoogleFonts.jost(
            //                     fontSize: 16.0,
            //                     fontWeight: FontWeight.w600,
            //                   ),
            //                   maxLines: 3,
            //                   overflow: TextOverflow.ellipsis,
            //                 ),
            //                 const SizedBox(height: 4.0),
            //                 Text(
            //                   '\$120',
            //                   style: GoogleFonts.jost(
            //                     fontSize: 14.0,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           const SizedBox(width: 8.0),
            //           InkWell(
            //             onTap: Get.back,
            //             child: SvgPicture.asset('assets/images/influencer/add_product/edit.svg', width: 20),
            //           ),
            //         ],
            //       );
            //     },
            //   ),
            // ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GetBuilder<CreatePostController>(
                  builder: (_) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
                      child: Material(
                        color: _.isComplete ? Colors.black : Colors.black54,
                        borderRadius: BorderRadius.circular(12.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.0),
                          onTap: _.isComplete ? _.submitPost : null,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              'Make post',
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
