import 'dart:convert';

import 'package:http/http.dart' as http;

const Map<String, dynamic> temp = {};

getData(String url, {Map<String, dynamic> params = temp, post = true}) async {
  final result;
  if (post)
    result = await http.post(Uri.parse("$url"),
        body: params); //https://url.com/login
  else
    result = await http.get(Uri.parse("$url"));

  if (result.statusCode == 200) {
    final data = result.body;
    return jsonDecode(data);
  }
}
