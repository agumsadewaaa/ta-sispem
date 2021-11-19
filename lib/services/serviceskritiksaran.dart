import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/kritiksaran.dart';
import '../url.dart';

class KritikSaranService {
  static const myUrl = Url.url + '/api/kritikSaran';

  static Future<List<KritikSaran>> getRuangan() async {
    http.Response response = await http.get(Uri.parse(myUrl));
    List<KritikSaran> list = parseResponse(response.body);
    return list;
  }

  static List<KritikSaran> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<KritikSaran>((json) => KritikSaran.fromJson(json))
        .toList();
  }
}
