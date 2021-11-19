import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ta_sispem/model/data_model.dart';

import '../url.dart';

class AuthRepository {
  Future loginUser(String _nipnim, String _password, String device) async {
    String baseUrl = Url.url + '/api/auth/login';

    try {
      var response = await http.post(Uri.parse(baseUrl), body: {
        'nip_nim': _nipnim,
        'password': _password,
        'device_name': device
      });

      var jsonResponse = json.decode(response.body);
      return LoginAuth.fromJson(jsonResponse);
    } catch (e) {
      return e;
    }
  }

  Future userLogout(String token) async {
    String baseUrl = Url.url + '/api/auth/logout';
    print(baseUrl);

    try {
      var response = await http.post(Uri.parse(baseUrl), headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      });

      var resbody = json.decode(response.body);
      return Logout.fromJson(resbody);
    } catch (e) {
      return e;
    }
  }

  Future getData(String token) async {
    String baseUrl = Url.url + '/api/auth/me';

    try {
      var response = await http.get(Uri.parse(baseUrl), headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      });

      var body = json.decode(response.body);
      return User.fromJson(body);
    } catch (e) {
      return e;
    }
  }

  Future hasToken() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences local = await _prefs;
    final String token = local.getString("token_sanctum") ?? null;
    if (token != null) {
      return token;
    }
    return null;
  }

  Future setLocalToken(String token) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences local = await _prefs;
    local.setString("token_sanctum", token);
  }

  Future unsetLocalToken() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences local = await _prefs;
    local.remove("token_sanctum");
  }
}
