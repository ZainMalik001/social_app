import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rubu/features/feed/screens/collection_screen.dart';
import 'package:rubu/features/feed/screens/influencer_profile_screen.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';
import 'package:rubu/features/home/screens/view_post_screen.dart';
import 'package:rubu/features/influencer/screens/account_feed_screen.dart';
import 'package:rubu/features/influencer/screens/account_screen.dart';
import 'package:rubu/features/liked/screens/liked_detail_screen.dart';
import 'package:rubu/features/search/screens/discover_screen.dart';
import 'package:rubu/features/search/screens/search_screen.dart';
import 'package:rubu/features/settings/screens/settings_screen.dart';

import '../../feed/screens/feed_screen.dart';
import '../../liked/screens/liked_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController(), permanent: true);
    return GetBuilder<HomeController>(
      builder: (_) {
        if (_.isLoading) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: Scaffold(
              backgroundColor: const Color(0xFFF7F7F7),
              // body: SizedBox(
              //   width: double.infinity,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const CircularProgressIndicator(
              //         color: Colors.black,
              //         strokeWidth: 2.0,
              //       ),
              //       const SizedBox(height: 16.0),
              //       Text(
              //         'Loading feed...',
              //         style: GoogleFonts.jost(),
              //       ),
              //     ],
              //   ),
              // ),
              body: Column(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Image.asset('assets/images/evershop_logo_splash.jpeg'),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 16.0),
                        Text(
                          'Loading data...',
                          style: GoogleFonts.jost(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            // color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: IndexedStack(
              index: _.index,
              children: [
                Navigator(
                  key: Get.nestedKey(1),
                  onGenerateRoute: (settings) {
                    // if (context.mounted) _.update();
                    Get.routing.args = settings.arguments;
                    return GetPageRoute(
                      page: () {
                        switch (settings.name) {
                          case '/viewPost':
                            return const ViewPostScreen();
                          case '/influencerProfile':
                            return const InfluencerProfileScreen();
                          case '/collection':
                            return const CollectionScreen(id: 1);
                          case '/':
                          default:
                            return const FeedScreen();
                        }
                      },
                    );
                  },
                ),
                // InfluencerFeedScreen(),
                Navigator(
                  key: Get.nestedKey(2),
                  onGenerateRoute: (settings) {
                    // if (context.mounted) _.update();
                    Get.routing.args = settings.arguments;
                    return GetPageRoute(
                      page: () {
                        switch (settings.name) {
                          case '/influencerProfile':
                            return const InfluencerProfileScreen();
                          case '/viewPost':
                            return const ViewPostScreen();
                          case '/discover':
                            return const DiscoverScreen();
                          case '/':
                          default:
                            return const SearchScreen();
                        }
                      },
                    );
                  },
                ),
                if (_.isLoggedIn && _.user.isInfluencer) const SizedBox(),
                Navigator(
                  key: Get.nestedKey(4),
                  onGenerateRoute: (settings) {
                    // if (context.mounted) _.update();
                    Get.routing.args = settings.arguments;
                    return GetPageRoute(
                      page: () {
                        switch (settings.name) {
                          case '/viewPost':
                            return const ViewPostScreen();
                          case '/influencerProfile':
                            return const InfluencerProfileScreen();
                          case '/likedDetail':
                            return const LikedDetailScreen();
                          case '/collection':
                            return const CollectionScreen(id: 4);
                          case '/':
                          default:
                            return const LikedScreen();
                        }
                      },
                    );
                  },
                ),
                if (_.isLoggedIn && _.user.isInfluencer) ...[
                  Navigator(
                    key: Get.nestedKey(5),
                    onGenerateRoute: (settings) {
                      // if () _.update();
                      Get.routing.args = settings.arguments;
                      return GetPageRoute(
                        page: () {
                          switch (settings.name) {
                            case '/influencerProfile':
                              return const InfluencerProfileScreen();
                            case '/viewPost':
                              return const ViewPostScreen();
                            case '/influencerAccountFeed':
                              return const InfluencerAccountFeedScreen();
                            case '/':
                            default:
                              return const InfluencerAccountScreen();
                          }
                        },
                      );
                    },
                  ),
                ] else ...[
                  const SettingsScreen(canPop: false),
                ]
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black,
              onTap: _.onTap,
              currentIndex: _.index,
              elevation: 24.0,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/home/bottom_navigation_bar/home_unselected.svg',
                    width: 24.0,
                  ),
                  activeIcon: (Get.nestedKey(1)?.currentState?.canPop() ?? false)
                      ? SvgPicture.asset(
                          'assets/images/home/bottom_navigation_bar/home_unselected.svg',
                          width: 24.0,
                        )
                      : SvgPicture.asset(
                          'assets/images/home/bottom_navigation_bar/home_selected.svg',
                          width: 24.0,
                        ),
                  label: 'Feed',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/home/bottom_navigation_bar/search_unselected.svg',
                    width: 24.0,
                  ),
                  activeIcon: (Get.nestedKey(2)?.currentState?.canPop() ?? false)
                      ? SvgPicture.asset(
                          'assets/images/home/bottom_navigation_bar/search_unselected.svg',
                          width: 24.0,
                        )
                      : SvgPicture.asset(
                          'assets/images/home/bottom_navigation_bar/search_selected.svg',
                          width: 24.0,
                        ),
                  label: 'Search',
                ),
                if (_.isLoggedIn && _.user.isInfluencer)
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/images/home/bottom_navigation_bar/add_product.svg',
                      width: 32.0,
                    ),
                    label: 'Add Product',
                  ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/home/bottom_navigation_bar/favorite_unselected.svg',
                    width: 24.0,
                  ),
                  activeIcon: (Get.nestedKey(4)?.currentState?.canPop() ?? false)
                      ? SvgPicture.asset(
                          'assets/images/home/bottom_navigation_bar/favorite_unselected.svg',
                          width: 24.0,
                        )
                      : SvgPicture.asset(
                          'assets/images/home/bottom_navigation_bar/favorite_selected.svg',
                          width: 24.0,
                        ),
                  label: 'Saved',
                ),
                if (_.isLoggedIn && _.user.isInfluencer) ...[
                  BottomNavigationBarItem(
                    icon: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.2),
                        child: CachedNetworkImage(
                          imageUrl: _.user.profileImageURL!,
                          width: 22.0,
                          height: 22.0,
                          fadeInDuration: Duration.zero,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => AspectRatio(
                            aspectRatio: 1,
                            child: Container(color: Colors.grey.shade200),
                          ),
                        ),
                      ),
                    ),
                    activeIcon: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.black),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.2),
                        child: CachedNetworkImage(
                          imageUrl: _.user.profileImageURL!,
                          width: 22.0,
                          height: 22.0,
                          fadeInDuration: Duration.zero,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => AspectRatio(
                            aspectRatio: 1,
                            child: Container(color: Colors.grey.shade200),
                          ),
                        ),
                      ),
                    ),
                    label: 'Profile',
                  ),
                ] else ...[
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/images/home/bottom_navigation_bar/category_unselected.svg',
                      width: 24.0,
                    ),
                    activeIcon: SvgPicture.asset(
                      'assets/images/home/bottom_navigation_bar/category_selected.svg',
                      width: 24.0,
                    ),
                    label: 'Settings',
                  ),
                ],
              ],
            ),
          ),
        );

        // return Scaffold(
        //   backgroundColor: Colors.white,
        //   body: PersistentTabView(
        //     context,
        //     controller: controller.persistentTabController,
        //     resizeToAvoidBottomInset: true,
        //     backgroundColor: const Color(0xFFF7ECDD),
        //     navBarStyle: NavBarStyle.simple,
        //     screens: const [
        //       FeedScreen(),
        //       // InfluencerFeedScreen(),
        //       SearchScreen(),
        //       // SizedBox(),
        //       LikedScreen(),
        //       SettingsScreen(),
        //     ],
        //     items: [
        //       PersistentBottomNavBarItem(
        //         icon: SvgPicture.asset(
        //           'assets/images/home/bottom_navigation_bar/home_selected.svg',
        //           width: 28.0,
        //         ),
        //         inactiveIcon: SvgPicture.asset(
        //           'assets/images/home/bottom_navigation_bar/home_unselected.svg',
        //           width: 28.0,
        //         ),
        //         // title: 'Feed',
        //       ),
        //       PersistentBottomNavBarItem(
        //         icon: SvgPicture.asset(
        //           'assets/images/home/bottom_navigation_bar/search_selected.svg',
        //           width: 28.0,
        //         ),
        //         inactiveIcon: SvgPicture.asset(
        //           'assets/images/home/bottom_navigation_bar/search_unselected.svg',
        //           width: 28.0,
        //         ),
        //         // activeIcon: SvgPicture.asset(
        //         //   'assets/images/home/bottom_navigation_bar/search_selected.svg',
        //         //   width: 28.0,
        //         // ),
        //         // title: 'Search',
        //       ),
        //       // BottomNavigationBarItem(
        //       //   icon: SvgPicture.asset(
        //       //     'assets/images/home/bottom_navigation_bar/add_product.svg',
        //       //     width: 36.0,
        //       //   ),
        //       //   label: 'Saved',
        //       // ),
        //       PersistentBottomNavBarItem(
        //         icon: SvgPicture.asset(
        //           'assets/images/home/bottom_navigation_bar/heart_selected.svg',
        //           width: 28.0,
        //         ),
        //         inactiveIcon: SvgPicture.asset(
        //           'assets/images/home/bottom_navigation_bar/heart_unselected.svg',
        //           width: 28.0,
        //         ),
        //         // title: 'Saved',
        //       ),
        //       PersistentBottomNavBarItem(
        //         icon: SvgPicture.asset(
        //           'assets/images/home/bottom_navigation_bar/category_selected.svg',
        //           width: 28.0,
        //         ),
        //         inactiveIcon: SvgPicture.asset(
        //           'assets/images/home/bottom_navigation_bar/category_unselected.svg',
        //           width: 28.0,
        //         ),
        //         // title: 'Settings',
        //       ),
        //       // BottomNavigationBarItem(
        //       //   icon: Container(
        //       //     decoration: BoxDecoration(
        //       //       border: Border.all(width: 1.0, color: Colors.grey),
        //       //       borderRadius: BorderRadius.circular(6.0),
        //       //     ),
        //       //     child: ClipRRect(
        //       //       borderRadius: BorderRadius.circular(5.2),
        //       //       child: Image.asset(
        //       //         'assets/images/home/bottom_navigation_bar/dp.png',
        //       //         width: 26.0,
        //       //       ),
        //       //     ),
        //       //   ),
        //       //   activeIcon: Container(
        //       //     decoration: BoxDecoration(
        //       //       border: Border.all(width: 1.0, color: Colors.black),
        //       //       borderRadius: BorderRadius.circular(6.0),
        //       //     ),
        //       //     child: ClipRRect(
        //       //       borderRadius: BorderRadius.circular(5.2),
        //       //       child: Image.asset(
        //       //         'assets/images/home/bottom_navigation_bar/dp.png',
        //       //         width: 26.0,
        //       //       ),
        //       //     ),
        //       //   ),
        //       //   label: 'Profile',
        //       // ),
        //     ],
        //   ),
        // );
      },
    );
  }
}
