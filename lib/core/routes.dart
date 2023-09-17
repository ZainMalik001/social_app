import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/instance_manager.dart';
import 'package:rubu/features/auth/screens/forgot_screen.dart';
import 'package:rubu/features/influencer/screens/add_post_screen.dart';
import 'package:rubu/features/influencer/screens/create_post_screen.dart';
import 'package:rubu/features/settings/screens/change_screen.dart';
import 'package:rubu/features/settings/screens/settings_screen.dart';
import 'package:rubu/features/settings/screens/success_screen.dart';
import 'package:rubu/welcome.dart';

import '../features/auth/bindings/forgot_binding.dart';
import '../features/auth/bindings/verify_email_binding.dart';
import '../features/auth/screens/verify_email_screen.dart';
import '../features/home/screens/congrats_screen.dart';
import '../features/home/screens/sad_screen.dart';
import '../features/influencer/bindings/add_post_binding.dart';
import '../features/influencer/bindings/create_post_binding.dart';
import '../features/influencer/bindings/edit_post_binding.dart';
import '../features/influencer/screens/account_feed_screen.dart';
import '../features/influencer/screens/add_product_screen.dart';
import '../features/influencer/screens/add_socials_screen.dart';
import '../features/influencer/screens/edit_post_screen.dart';
import '../features/liked/screens/liked_detail_screen.dart';
import '../features/search/bindings/discover_binding.dart';
import '../features/search/screens/discover_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/bindings/login_binding.dart';
import '../features/auth/bindings/register_binding.dart';
import '../features/home/bindings/home_binding.dart';
import '../features/influencer/bindings/account_binding.dart';
import '../features/influencer/bindings/account_feed_binding.dart';
import '../features/influencer/bindings/add_product_binding.dart';
import '../features/influencer/bindings/become_influencer_binding.dart';
import '../features/influencer/screens/account_screen.dart';
import '../features/influencer/screens/become_influencer_screen.dart';
import '../features/liked/bindings/liked_detail_binding.dart';
import '../features/settings/screens/change_country.dart';
import '../features/settings/screens/change_currency.dart';
import '../features/settings/screens/partner_brands_screen.dart';

final getPages = [
  GetPage(
    name: '/welcome',
    page: () => const WelcomeScreen(),
  ),
  GetPage(
    name: '/login',
    page: () => const LoginScreen(),
    binding: LoginBinding(),
  ),
  GetPage(
    name: '/loginDialog',
    page: () => const LoginScreen(),
    binding: LoginBinding(),
    fullscreenDialog: true,
  ),
  GetPage(
    name: '/register',
    page: () => const RegisterScreen(),
    binding: RegisterBinding(),
  ),
  GetPage(
    name: '/registerDialog',
    page: () => const RegisterScreen(),
    binding: RegisterBinding(),
    fullscreenDialog: true,
  ),
  GetPage(
    name: '/forgot',
    page: () => const ForgotPasswordScreen(),
    binding: ForgotPasswordBinding(),
    fullscreenDialog: true,
  ),
  GetPage(
    name: '/verifyEmail',
    page: () => const VerifyEmailScreen(),
    binding: VerifyEmailBinding(),
    fullscreenDialog: true,
  ),
  GetPage(
    name: '/home',
    page: () => const HomeScreen(),
    binding: HomeBinding(),
  ),
  // GetPage(
  //   name: '/influencerProfile',
  //   page: () => const InfluencerProfileScreen(),
  //   binding: InfluencerProfileBinding(),
  // ),
  // GetPage(
  //   name: '/collection',
  //   page: () => const CollectionScreen(),
  //   binding: CollectionBinding(),
  // ),
  GetPage(
    name: '/discover',
    page: () => const DiscoverScreen(),
    binding: DiscoverBinding(),
  ),
  GetPage(
    name: '/likedDetail',
    page: () => const LikedDetailScreen(),
    binding: LikedDetailBinding(),
  ),
  GetPage(
    name: '/becomeInfluencer',
    page: () => const BecomeInfluencerScreen(),
    binding: BecomeInfluencerBinding(),
  ),
  GetPage(
    name: '/addSocials',
    page: () => const AddSocialsScreen(),
  ),
  GetPage(
    name: '/influencerAccount',
    page: () => const InfluencerAccountScreen(),
    binding: InfluencerAccountBinding(),
  ),
  GetPage(
    name: '/influencerAccountFeed',
    page: () => const InfluencerAccountFeedScreen(),
    binding: InfluencerAccountFeedBinding(),
  ),
  GetPage(
    name: '/addProduct',
    page: () => const AddProductScreen(),
    binding: AddProductBinding(),
  ),
  GetPage(
    name: '/createPost',
    page: () => const CreatePostScreen(),
    binding: CreatePostBinding(),
  ),
  GetPage(
    name: '/addPost',
    page: () => const AddPostScreen(),
    binding: AddPostBinding(),
  ),
  GetPage(
    name: '/editPost',
    page: () => const EditPostScreen(),
    binding: EditPostBinding(),
  ),
  GetPage(
    name: '/settings',
    page: () => const SettingsScreen(canPop: true),
  ),
  GetPage(
    name: '/changeScreen',
    page: () => const ChangeScreen(),
  ),
  GetPage(
    name: '/partnerBrands',
    page: () => const PartnerBrandsScreen(),
  ),
  GetPage(
    name: '/successScreen',
    page: () => const SuccessScreen(),
  ),
  GetPage(
    name: '/congratsScreen',
    page: () => const CongratsScreen(),
    fullscreenDialog: true,
  ),
  GetPage(
    name: '/sadScreen',
    page: () => const SadScreen(),
    fullscreenDialog: true,
  ),
  GetPage(
    name: '/userCountry',
    page: () => const ChangeCountryScreen(),
    fullscreenDialog: true,
  ),
  GetPage(
    name: '/userCurrency',
    page: () => const ChangeCurrencyScreen(),
    fullscreenDialog: true,
  ),
];

final authPages = [
  GetPage(
    name: '/login',
    page: () => const LoginScreen(),
    binding: LoginBinding(),
  ),
  GetPage(
    name: '/register',
    page: () => const RegisterScreen(),
    binding: RegisterBinding(),
  ),
  GetPage(
    name: '/home',
    page: () => const HomeScreen(),
    binding: HomeBinding(),
  ),
];
