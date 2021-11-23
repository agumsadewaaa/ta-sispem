import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ta_sispem/main.dart';
import 'package:ta_sispem/model/transaksi.dart';
import 'package:ta_sispem/repository/auth_repository.dart';
import 'package:ta_sispem/url.dart';

class AddKritik extends StatefulWidget {
  final AuthBloc authBloc;
  final Transaksi transaksi;

  const AddKritik({Key key, this.authBloc, this.transaksi}) : super(key: key);

  @override
  _AddKritikState createState() => _AddKritikState();
}

class _AddKritikState extends State<AddKritik> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _kritik = TextEditingController();
  TextEditingController _saran = TextEditingController();

  Transaksi get _transaksi => widget.transaksi;
  AuthRepository repo = AuthRepository();
  int peminjamId;
  String saveUrl;

  Future saveKritik() async {
    print(saveUrl);
    final http.Response response = await http.post(Uri.parse(saveUrl), body: {
      'transaksi_id': _transaksi.id.toString(),
      'keluhan': _kritik.text,
      'saran': _saran.text
    });
    print(response.body);
    final hasil = json.decode(response.body);
    return hasil;
  }

  @override
  void initState() {
    super.initState();
    Future token = repo.hasToken();
    token.then((value) => repo.getData(value).then((e) {
          setState(() {
            peminjamId = e.peminjamId;
            saveUrl = Url.url +
                '/api/peminjams/' +
                peminjamId.toString() +
                '/transaksis/' +
                _transaksi.id.toString() +
                '/pengaduans';
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kritik dan Saran'),
        backgroundColor: Color(0xFF006600),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(left: 7, right: 7),
            child: Column(
              children: [
                TextFormField(
                  controller: _kritik,
                  decoration: InputDecoration(labelText: "Keluhan"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please input this field !";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _saran,
                  decoration: InputDecoration(labelText: "Saran"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please input this field !";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: 160,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              saveKritik().then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Data saved successfully')));
                                new Future.delayed(const Duration(seconds: 1),
                                    () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => App(
                                              authBloc: AuthBloc(
                                                  authRepository: repo))));
                                });
                              });
                            }
                          },
                          child: Text("Save")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
