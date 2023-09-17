import 'package:cached_network_image/cached_network_image.dart';
import 'package:country/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/core/widgets/appbar.dart';
import 'package:rubu/features/settings/screens/widgets/textfield.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/change_controller.dart';

class ChangeScreen extends StatelessWidget {
  const ChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = Get.put(ChangeController());
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: const RubuAppbar(
          title: 'Profile Settings',
          canPop: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      GetBuilder<HomeController>(
                        builder: (_) {
                          if (!_.user.isInfluencer) {
                            return const SizedBox();
                          }
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 96.0,
                                      child: GetBuilder<ChangeController>(builder: (controller) {
                                        return InkWell(
                                          splashFactory: NoSplash.splashFactory,
                                          highlightColor: Colors.transparent,
                                          onTap: controller.getProfileFromGallery,
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(16.0),
                                                    child: GetBuilder<ChangeController>(
                                                      builder: (controller) {
                                                        if (controller.profileImage != null) {
                                                          return Image.file(
                                                            controller.profileImage!,
                                                            fit: BoxFit.cover,
                                                            height: 96.0,
                                                          );
                                                        }
                                                        return CachedNetworkImage(
                                                          imageUrl: _.user.profileImageURL!,
                                                          width: 96.0,
                                                          height: 96.0,
                                                          fadeInDuration: Duration.zero,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Positioned.fill(
                                                    child: Opacity(
                                                      opacity: 0.6,
                                                      child: Center(
                                                        child: Container(
                                                          padding: const EdgeInsets.all(4.8),
                                                          decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                          child: SvgPicture.asset(
                                                            'assets/images/influencer/camera.svg',
                                                            colorFilter: const ColorFilter.mode(
                                                                Color(0xFFF7ECDD), BlendMode.srcIn),
                                                            width: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                'Profile',
                                                style: GoogleFonts.jost(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Flexible(
                                      child: GetBuilder<ChangeController>(
                                        builder: (controller) {
                                          return InkWell(
                                            splashFactory: NoSplash.splashFactory,
                                            highlightColor: Colors.transparent,
                                            onTap: controller.getCoverFromGallery,
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(16.0),
                                                      child: controller.coverImage != null
                                                          ? Image.file(
                                                              controller.coverImage!,
                                                              fit: BoxFit.cover,
                                                              height: 96.0,
                                                            )
                                                          : CachedNetworkImage(
                                                              imageUrl: _.user.coverImageURL!,
                                                              fit: BoxFit.cover,
                                                              height: 96.0,
                                                              fadeInDuration: Duration.zero,
                                                              placeholder: (context, url) {
                                                                return const SizedBox();
                                                              },
                                                            ),
                                                    ),
                                                    Positioned.fill(
                                                      child: Opacity(
                                                        opacity: 0.6,
                                                        child: Center(
                                                          child: Container(
                                                            padding: const EdgeInsets.all(4.8),
                                                            decoration: BoxDecoration(
                                                              color: Colors.black,
                                                              borderRadius: BorderRadius.circular(8.0),
                                                            ),
                                                            child: SvgPicture.asset(
                                                              'assets/images/influencer/camera.svg',
                                                              colorFilter: const ColorFilter.mode(
                                                                  Color(0xFFF7ECDD), BlendMode.srcIn),
                                                              width: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  'Cover',
                                                  style: GoogleFonts.jost(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16.0),
                            ],
                          );
                        },
                      ),
                      const Divider(
                        height: 1.0,
                        thickness: 1.0,
                        color: Colors.black,
                      ),
                      Table(
                        columnWidths: const {
                          0: IntrinsicColumnWidth(),
                          1: FlexColumnWidth(),
                          2: FixedColumnWidth(24.0),
                        },
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0, left: 24.0),
                                child: Text(
                                  'Name',
                                  style: GoogleFonts.jost(fontSize: 14.0),
                                ),
                              ),
                              GetBuilder<HomeController>(
                                builder: (controller) {
                                  return SettingsTextField(
                                    controller: _.nameController,
                                    shouldObscure: false,
                                    obscured: false,
                                    hintText: controller.user.fullname!,
                                    showBorderTop: false,
                                    capitalization: TextCapitalization.words,
                                    inputType: TextInputType.name,
                                  );
                                },
                              ),
                              const SizedBox(),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0, left: 24.0),
                                child: Text(
                                  'Email',
                                  style: GoogleFonts.jost(fontSize: 14.0),
                                ),
                              ),
                              GetBuilder<HomeController>(
                                builder: (controller) {
                                  return SettingsTextField(
                                    controller: _.emailController,
                                    shouldObscure: false,
                                    obscured: false,
                                    hintText: controller.user.email!,
                                    inputType: TextInputType.emailAddress,
                                  );
                                },
                              ),
                              const SizedBox(),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0, left: 24.0),
                                child: Text(
                                  'Password',
                                  style: GoogleFonts.jost(fontSize: 14.0),
                                ),
                              ),
                              SettingsTextField(
                                controller: _.newPassController,
                                shouldObscure: true,
                                obscured: true,
                                hintText: 'Enter New Password',
                              ),
                              const SizedBox(),
                            ],
                          ),
                          TableRow(
                            children: [
                              const SizedBox(),
                              SettingsTextField(
                                controller: _.confirmPassController,
                                shouldObscure: true,
                                obscured: true,
                                hintText: 'Confirm New Password',
                              ),
                              const SizedBox(),
                            ],
                          ),
                          if (Get.find<HomeController>().isLoggedIn && Get.find<HomeController>().user.isInfluencer)
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0, left: 24.0),
                                  child: Text(
                                    'Description',
                                    style: GoogleFonts.jost(fontSize: 14.0),
                                  ),
                                ),
                                GetBuilder<HomeController>(
                                  builder: (controller) {
                                    return SettingsTextField(
                                      controller: _.descriptionController,
                                      shouldObscure: false,
                                      obscured: false,
                                      hintText: controller.user.profileDescription!,
                                    );
                                  },
                                ),
                                const SizedBox(),
                              ],
                            ),
                          TableRow(
                            children: [
                              Container(
                                height: 1.0,
                                color: Colors.black,
                              ),
                              Container(
                                height: 1.0,
                                color: Colors.black,
                              ),
                              Container(
                                height: 1.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0, left: 24.0),
                                child: Text(
                                  'Country',
                                  style: GoogleFonts.jost(fontSize: 14.0),
                                ),
                              ),
                              InkWell(
                                onTap: () => Get.toNamed('/userCountry'),
                                borderRadius: BorderRadius.circular(12.0),
                                child: Ink(
                                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 1.0, color: Colors.black),
                                    ),
                                  ),
                                  child: GetBuilder<ChangeController>(
                                    builder: (controller) {
                                      return GetBuilder<HomeController>(
                                        builder: (_) {
                                          late Country? country;
                                          if (controller.selectedCountry.isNotEmpty) {
                                            country = Countries.values
                                                .where((e) => e.alpha3 == controller.selectedCountry)
                                                .first;
                                          } else if (_.user.country != null) {
                                            country = Countries.values.where((e) => e.alpha3 == _.user.country).first;
                                          } else {
                                            country = null;
                                          }
                                          return Row(
                                            children: [
                                              if (country != null)
                                                Text(
                                                  country.flagEmoji,
                                                  style: const TextStyle(fontSize: 28.0),
                                                )
                                              else
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 6.0),
                                                  child: Icon(
                                                    Icons.flag,
                                                    color: Color(0x800A0F19),
                                                  ),
                                                ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  country != null ? country.isoShortName : 'Country',
                                                  style: GoogleFonts.jost(
                                                      fontSize: 16.0,
                                                      color: country != null ? Colors.black : const Color(0x800A0F19)),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 20,
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(),
                            ],
                          ),
                          // TableRow(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(right: 16.0, left: 24.0),
                          //       child: Text(
                          //         'Currency',
                          //         style: GoogleFonts.jost(fontSize: 14.0),
                          //       ),
                          //     ),
                          //     InkWell(
                          //       onTap: () => Get.toNamed('/userCurrency'),
                          //       borderRadius: BorderRadius.circular(12.0),
                          //       child: Ink(
                          //         padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                          //         decoration: const BoxDecoration(
                          //           border: Border(
                          //             bottom: BorderSide(width: 1.0, color: Colors.black),
                          //           ),
                          //         ),
                          //         child: GetBuilder<ChangeController>(
                          //           builder: (controller) {
                          //             return GetBuilder<HomeController>(
                          //               builder: (_) {
                          //                 late Country? country;
                          //                 if (controller.selectedCountry.isNotEmpty) {
                          //                   country = Countries.values
                          //                       .where((e) => e.alpha3 == controller.selectedCountry)
                          //                       .first;
                          //                 } else if (_.user.country != null) {
                          //                   country = Countries.values.where((e) => e.alpha3 == _.user.country).first;
                          //                 } else {
                          //                   country = null;
                          //                 }
                          //                 return Row(
                          //                   children: [
                          //                     if (country != null)
                          //                       Text(
                          //                         country.flagEmoji,
                          //                         style: const TextStyle(fontSize: 28.0),
                          //                       )
                          //                     else
                          //                       const Padding(
                          //                         padding: EdgeInsets.symmetric(vertical: 6.0),
                          //                         child: Icon(
                          //                           Icons.attach_money_rounded,
                          //                           color: Color(0x800A0F19),
                          //                         ),
                          //                       ),
                          //                     const SizedBox(
                          //                       width: 8.0,
                          //                     ),
                          //                     Expanded(
                          //                       child: Text(
                          //                         country != null ? country.isoShortName : 'Currency',
                          //                         style: GoogleFonts.jost(
                          //                             fontSize: 16.0,
                          //                             color: country != null ? Colors.black : const Color(0x800A0F19)),
                          //                         maxLines: 1,
                          //                         overflow: TextOverflow.ellipsis,
                          //                       ),
                          //                     ),
                          //                     const Icon(
                          //                       Icons.arrow_forward_ios_rounded,
                          //                       size: 20,
                          //                     ),
                          //                   ],
                          //                 );
                          //               },
                          //             );
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                // if (_.property == 'Password') const SizedBox(height: 24.0),
                GetBuilder<ChangeController>(
                  builder: (_) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: _.updateData,
                        child: Ink(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A0F19),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: _.loading
                              ? const Center(
                                  child: SizedBox(
                                    width: 22.0,
                                    height: 22.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: Color(0xFFF7ECDD),
                                    ),
                                  ),
                                )
                              : Text(
                                  'Update',
                                  style: GoogleFonts.jost(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFF7ECDD),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom != 0 ? 16.0 : 0.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
