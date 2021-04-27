class LoginAuth {
  String message;
  TokenAuth data;

  LoginAuth({this.message, this.data});

  LoginAuth.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = TokenAuth.fromJson(json['data']);
  }
}

class TokenAuth {
  String token;
  TokenAuth({this.token});

  TokenAuth.fromJson(Map<String, dynamic> data) {
    token = data['token'];
  }
}

class User {
  int id;
  String name;
  String email;
  int peminjamId;

  User({this.id, this.name, this.email, this.peminjamId});

  User.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      id = json['data']['id'];
      name = json['data']['name'];
      email = json['data']['email'];
      peminjamId = json['data']['peminjam_id'];
    } else {
      id = null;
      name = "";
      email = "";
      peminjamId = null;
    }
  }
}

class Logout {
  String message;

  Logout({this.message});

  Logout.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}
