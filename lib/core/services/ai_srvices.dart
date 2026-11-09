
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class PeopleDetectionService {
  static const String _endpoint =
      'https://serverless.roboflow.com/counting-people-xz9w2/3';

  // ضع مفتاحك هنا للتجربة الشخصية فقط.
  static const String _apiKey = 'YOUR_API_KEY';

  Future<Map<String, dynamic>> detectPeople(File image) async {
    final imageBytes = await image.readAsBytes();

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: base64Encode(imageBytes),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Roboflow Error: ${response.statusCode} - ${response.body}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
