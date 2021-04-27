import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/transaksi.dart';
import '../url.dart';

class TransaksiService {
  static const myUrl = Url.url + '/api/peminjams/1/transaksis/1';

  static Future<List<Transaksi>> getTransaksi() async {
    http.Response response = await http.get(Uri.parse(myUrl));
    List<Transaksi> list = parseResponse(response.body);
    return list;
  }

  static List<Transaksi> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Transaksi>((json) => Transaksi.fromJson(json)).toList();
  }
}
