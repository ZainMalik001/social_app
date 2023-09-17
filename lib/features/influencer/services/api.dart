import 'dart:convert';

import 'package:http/http.dart';

class InfluencerApiService {
  Future<String> createRubuUrl(String uri) async {
    try {
      final response = await post(
        Uri.parse("https://europe-west3-winter-surf-390516.cloudfunctions.net/generate-attributed-url"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'partner_id': 2,
          'url': uri,
        }),
      );

      if (response.statusCode != 200) return '';

      final data = jsonDecode(response.body);

      if (data['result'] != 'success') return '';

      return data['url'];
    } catch (e) {
      return '';
    }
  }
}
