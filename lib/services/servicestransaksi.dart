import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/transaksi.dart';

class TransaksiService {
  static String myUrl = '';

  static Future<List<Transaksi>> getTransaksi(myUrl) async {
    print(myUrl);
    http.Response response = await http.get(Uri.parse(myUrl));
    List<Transaksi> list = parseResponse(response.body);
    return list;
  }

  static Future<List<Transaksi>> getPeminjaman(myUrl) async {
    print(myUrl);
    http.Response response = await http.get(Uri.parse(myUrl));
    List<Transaksi> list = parseResponse(response.body);
    print(list);
    return list;
  }

  static List<Transaksi> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Transaksi>((json) => Transaksi.fromJson(json)).toList();
  }
}
