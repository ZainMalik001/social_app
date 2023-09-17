import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:rubu/core/controllers/auth_controller.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';

class DeepLinkService {
  const DeepLinkService._();

  static Future<void> handleDynamicLinks() async {
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeepLink(data);

    FirebaseDynamicLinks.instance.onLink.listen((event) {
      _handleDeepLink(event);
    }, onError: (e) {
      print("Deep Link Failed: ${e.message}");
    });
  }

  static void _handleDeepLink(PendingDynamicLinkData? data) {
    final homeController = Get.find<HomeController>();
    final Uri? deepLink = data?.link;

    int? id;

    if (Get.find<AuthController>().isLoggedIn && homeController.user.isInfluencer) {
      if (homeController.index != 2) {
        id = isInfluencer[homeController.index];
      } else {
        id = null;
      }
    } else {
      if (homeController.index == 3) {
        id = null;
      } else {
        id = homeController.index + 1;
      }
    }

    if (deepLink != null) {
      final segments = deepLink.pathSegments;

      if (segments.first == 'p') {
        Get.toNamed(
          '/viewPost',
          id: id,
          arguments: {
            'id': id,
            'postID': segments.last,
          },
        );
      } else if (segments.first == 'u') {
        homeController.toInfluencerProfile(id, segments.last);
      }
    }
  }

  static Map<int, int> isInfluencer = {0: 1, 1: 2, 3: 3, 4: 4};
}
