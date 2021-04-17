import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/ruangan.dart';
import '../url.dart';

class RuanganService {
  static const myUrl = Url.url + '/api/peminjams/1/transaksis';

  static Future<List<Ruangan>> getRuangan() async {
    http.Response response = await http.get(Uri.parse(myUrl));
    List<Ruangan> list = parseResponse(response.body);
    return list;
  }

  static List<Ruangan> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Ruangan>((json) => Ruangan.fromJson(json)).toList();
  }
}
