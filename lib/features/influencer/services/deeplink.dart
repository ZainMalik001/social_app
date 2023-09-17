import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

// class InfluencerDeepLinkService {
//   final FirebaseDynamicLinks _dynamicLinks = FirebaseDynamicLinks.instance;

//   Future<String> generatePostLink(String postID) async {
//     final link = await _dynamicLinks.buildShortLink(
//       DynamicLinkParameters(
//         link: Uri.parse('https://rubu.page.link/post/$postID'),
//         uriPrefix: 'https://rubu.page.link',
//         androidParameters: const AndroidParameters(packageName: 'app.rubu'),
//         iosParameters: const IOSParameters(bundleId: 'app.rubu'),
//       ),
//     );

//     return link.shortUrl.toString();
//   }
// }
