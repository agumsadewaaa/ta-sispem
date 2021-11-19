import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ta_sispem/model/ruangan.dart';
import 'package:ta_sispem/repository/auth_repository.dart';
import 'package:ta_sispem/url.dart';

class AddKritik extends StatefulWidget {
  final AuthBloc authBloc;
  final Ruangan ruangan;

  const AddKritik({Key key, this.authBloc, this.ruangan}) : super(key: key);

  @override
  _AddKritikState createState() => _AddKritikState();
}

class _AddKritikState extends State<AddKritik> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _kritik = TextEditingController();
  TextEditingController _saran = TextEditingController();

  Ruangan get _ruangan => widget.ruangan;
  AuthRepository repo = AuthRepository();
  int peminjamId;
  String saveUrl;

  Future saveTransaksi() async {
    print(saveUrl);
    final http.Response response = await http.post(Uri.parse(saveUrl), body: {
      'peminjam_id': peminjamId.toString(),
      'tanggal_mulai': _kritik.text,
      'tanggal_selesai': _saran.text,
      'ruangan_id': _ruangan.id.toString(),
      'status': '0',
      'periode': DateFormat('Y').format(DateTime.now()).toString()
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
                '/transaksis';
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
                              saveTransaksi().then((value) {
                                Navigator.pop(context, true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Transaksi saved successfully')));
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
