import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';
import 'package:rubu/features/influencer/controllers/create_post_controller.dart';
import 'package:rubu/features/influencer/controllers/edit_post_controller.dart';
import 'package:rubu/features/influencer/screens/utils/unavailable.dart';
import 'package:web_scraper/web_scraper.dart';

class AddProductController extends GetxController {
  final _args = Get.arguments;

  final _imagePicker = ImagePicker();
  final _imageCropper = ImageCropper();

  final _productURL = TextEditingController();
  final _productTitle = TextEditingController();
  final _productPrice = TextEditingController();
  // final _productPrice = TextEditingController();
  // final _productDescription = TextEditingController();
  final List<String> _hosts = Get.find<HomeController>()
      .partnerBrands
      .map((e) => Uri.parse(e.website).host.replaceAll(RegExp(r'www.'), ''))
      .toList();

  // late final WebViewController _webViewController;

  // final _productURLString = ''.obs;
  bool _loading = true;
  String? _imageUrl, _category;
  String _priceCurrency = 'SAR';
  File? _productImage;

  File get productImage => _productImage!;
  bool get loading => _loading;
  bool get isComplete =>
      _imageUrl != null &&
      _productTitle.text.trim().isNotEmpty &&
      _category != null &&
      _productPrice.text.trim().isNotEmpty &&
      _productPrice.text.trim().isNum &&
      _priceCurrency.length == 3;
  bool get isIncomplete => !isComplete;
  String? get imageUrl => _imageUrl;
  String? get priceCurrency => _priceCurrency;
  TextEditingController get productURL => _productURL;
  TextEditingController get productTitle => _productTitle;
  TextEditingController get productPrice => _productPrice;
  // TextEditingController get productDescription => _productDescription;
  // WebViewController get webViewController => _webViewController;

  @override
  void onInit() {
    // _webViewController = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setNavigationDelegate(NavigationDelegate(
    //     onPageFinished: (url) async {
    //       final html =
    //           await _webViewController.runJavaScriptReturningResult('new XMLSerializer().serializeToString(document)');

    //       debugPrint('Got URL Webpage Data');

    //       // _getWebsiteData(html as String);
    //     },
    //   ));
    // _addTextEditingListeners();
    // _fetchProductURL();
    _getWebsiteData();
    super.onInit();
  }

  @override
  void onReady() {
    // _webViewController.loadRequest(Uri.parse(_args['url']));
    super.onReady();
  }

  // void _addTextEditingListeners() {
  //   _productURL.addListener(() {
  //     _productURLString.value = _productURL.text;
  //   });
  // }

  void setCategory(String value) {
    _category = value;
    update();
  }

  void setCurrency(String value) {
    _priceCurrency = value;
    update();
  }

  // void _fetchProductURL() {
  //   debounce<String>(
  //     _productURLString,
  //     (_) async {
  //       final s = _.trim();
  //       if (s.length >= 10 && GetUtils.isURL(s)) {
  //         _loading = true;
  //         update();

  //         _webViewController.loadRequest(Uri.parse(s));
  //       }
  //     },
  //   );
  // }

  void _getWebsiteData() async {
    // final response = await get(Uri.parse(_args['url']));

    // Document html = Document.html(response.body);
    // Document html = parse(rawHtml);

    // print(Uri.parse(_args['url']).host);
    // print(Uri.parse(_args['url']).path);

    // return;

    // Document html = Document.html('<html></html>');

    List<Map<String, dynamic>> allMetaTags = [];

    final WebScraper webScraper = WebScraper('${Uri.parse(_args['url']).scheme}://${Uri.parse(_args['url']).host}');

    if (await webScraper.loadWebPage(Uri.parse(_args['url']).path)) {
      allMetaTags = [
        ...webScraper.getElement('meta', ['name', 'property', 'content'])
      ];

      // print(webScraper.getElement('meta[property="og:title"]', ['name', 'property', 'content']));
    }

    debugPrint('HTML parsed successfully');

    // final head = html.head!;
    // log(head.outerHtml);

    // debugPrint(head.querySelectorAll('script').map((e) => e.attributes).length.toString());

    // final ogTitle = head.querySelector('meta[property="og:title"]')?.attributes['content'] ??
    //     head.querySelector('meta[name="og:title"]')?.attributes['content'];
    // final ogImage = head.querySelector('meta[property="og:image"]')?.attributes['content'] ??
    //     head.querySelector('meta[name="og:image"]')?.attributes['content'];
    final ogTitle = allMetaTags
            .where((e) => e['attributes']['name'] == 'og:title' || e['attributes']['property'] == 'og:title')
            .isNotEmpty
        ? allMetaTags
            .where((e) => e['attributes']['name'] == 'og:title' || e['attributes']['property'] == 'og:title')
            .first['attributes']['content']
        : '';

    final ogImage = allMetaTags
            .where((e) => e['attributes']['name'] == 'og:image' || e['attributes']['property'] == 'og:image')
            .isNotEmpty
        ? allMetaTags
            .where((e) => e['attributes']['name'] == 'og:image' || e['attributes']['property'] == 'og:image')
            .first['attributes']['content']
        : '';

    final productPrice = allMetaTags
            .where((e) =>
                (e['attributes']['name']?.contains('price:amount') ?? false) ||
                (e['attributes']['property']?.contains('price:amount') ?? false))
            .isNotEmpty
        ? allMetaTags
            .where((e) =>
                (e['attributes']['name']?.contains('price:amount') ?? false) ||
                (e['attributes']['property']?.contains('price:amount') ?? false))
            .first['attributes']['content']
        : '';

    final priceCurrency = allMetaTags
            .where((e) =>
                (e['attributes']['name']?.contains('price:currency') ?? false) ||
                (e['attributes']['property']?.contains('price:currency') ?? false))
            .isNotEmpty
        ? allMetaTags
            .where((e) =>
                (e['attributes']['name']?.contains('price:currency') ?? false) ||
                (e['attributes']['property']?.contains('price:currency') ?? false))
            .first['attributes']['content']
        : '';

    _productTitle.text = ogTitle;
    _productPrice.text = double.tryParse(productPrice)?.toInt().toString() ?? productPrice;

    if (_hosts.any((e) => _args['url'].contains(e))) {
      _category = Get.find<HomeController>()
          .partnerBrands
          .where((e) => e.website.contains(_hosts.where((e) => _args['url'].contains(e)).first))
          .first
          .category;
    }

    if (priceCurrency.length == 3) _priceCurrency = priceCurrency;

    if (ogImage.isNotEmpty) {
      if (ogImage.startsWith('http://') || ogImage.startsWith('https://')) {
        _imageUrl = ogImage;
      } else if (ogImage.startsWith('//')) {
        _imageUrl = 'https:$ogImage';
      } else {
        _imageUrl = 'https://$ogImage';
      }
    }

    // return;

    if (_imageUrl != null) await _cacheImageLocally();

    _loading = false;
    update();
  }

  Future<void> _cacheImageLocally() async {
    final response = await get(Uri.parse(_imageUrl!));

    // Get temporary directory
    final dir = await getTemporaryDirectory();

    // Create an image name
    var filename =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}${_imageUrl!.contains(".png") ? ".png" : _imageUrl!.contains(".webp") ? ".webp" : ".jpg"}';

    // Save to filesystem
    _productImage = File(filename);
    await _productImage!.writeAsBytes(response.bodyBytes);

    // final imageDownload = await ImageDownloader.downloadImage(_imageUrl!);

    // if (imageDownload == null) return;

    // final imagePath = await ImageDownloader.findPath(imageDownload);

    // if (imagePath == null) return;

    // _productImage = File(imagePath);
  }

  void addProductImage() async {
    final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    final croppedImage = await _imageCropper.cropImage(
      sourcePath: pickedImage.path,
      cropStyle: CropStyle.rectangle,
      compressQuality: 80,
      maxWidth: 720,
      maxHeight: 720,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [
        IOSUiSettings(
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
        ),
        AndroidUiSettings(
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
      ],
    );

    if (croppedImage == null) return;

    _productImage = File(croppedImage.path);

    update();
  }

  void toCreatePost() {
    if (_productURL.text.trim().isEmpty) return;
    if (_productTitle.text.trim().isEmpty) return;
    if (_productImage == null) return;
    if (_category == null) return;

    Get.toNamed(
      '/createPost',
      arguments: {
        'product_url': _productURL.text.trim(),
        'product_title': _productTitle.text.trim(),
        'product_img': _productImage,
        'product_category': _category,
      },
    );
  }

  void addProductToPost() async {
    if (Get.isRegistered<CreatePostController>()) {
      Get.find<CreatePostController>()
        ..productData[_args['index']] = {
          'url': _args['url'],
          'title': _productTitle.text.trim(),
          'category': _category!,
          'image': _productImage,
          'price': {
            'currency': _priceCurrency,
            'symbol': NumberFormat.simpleCurrency().simpleCurrencySymbol(_priceCurrency),
            'amount': _productPrice.text.trim().split(' ').first.replaceAll(r',', '').isNum
                ? num.parse(_productPrice.text.trim().split(' ').first.replaceAll(r',', '')).toInt()
                : _productPrice.text.trim().split(' ').last.replaceAll(r',', '').isNum
                    ? num.parse(_productPrice.text.trim().split(' ').last.replaceAll(r',', '')).toInt()
                    : num.parse(_productPrice.text.trim().replaceAll(r',', '')).toInt(),
          }
        }
        ..update();
    } else {
      Get.find<EditPostController>()
        ..productData[_args['index']] = {
          'url': _args['url'],
          'title': _productTitle.text.trim(),
          'category': _category!,
          'image': _productImage,
          'price': {
            'currency': _priceCurrency,
            'symbol': NumberFormat.simpleCurrency().simpleCurrencySymbol(_priceCurrency),
            'amount': _productPrice.text.trim().split(' ').first.replaceAll(r',', '').isNum
                ? num.parse(_productPrice.text.trim().split(' ').first.replaceAll(r',', '')).toInt()
                : _productPrice.text.trim().split(' ').last.replaceAll(r',', '').isNum
                    ? num.parse(_productPrice.text.trim().split(' ').last.replaceAll(r',', '')).toInt()
                    : num.parse(_productPrice.text.trim().replaceAll(r',', '')).toInt(),
          }
        }
        ..update();
    }

    Get.back();

    if (!_hosts.any((e) => _args['url'].contains(e))) {
      await Future.delayed(const Duration(milliseconds: 300));
      UnavailableDialog.show();
    }
  }
}
