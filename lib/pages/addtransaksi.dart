import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ta_sispem/main.dart';
import 'package:ta_sispem/model/ruangan.dart';
import 'package:ta_sispem/repository/auth_repository.dart';
import 'package:ta_sispem/url.dart';

class AddTransaksi extends StatefulWidget {
  final AuthBloc authBloc;
  final Ruangan ruangan;

  const AddTransaksi({Key key, this.authBloc, this.ruangan}) : super(key: key);

  @override
  _AddTransaksiState createState() => _AddTransaksiState();
}

class _AddTransaksiState extends State<AddTransaksi> {
  final _formKey = GlobalKey<FormState>();
  DateTime _dateTime;
  TextEditingController _tanggalMulai = TextEditingController();
  TextEditingController _tanggalSelesai = TextEditingController();
  TextEditingController _namaAcara = TextEditingController();
  TextEditingController _penanggungJawab = TextEditingController();
  TextEditingController _kontak = TextEditingController();

  Ruangan get _ruangan => widget.ruangan;
  AuthRepository repo = AuthRepository();
  int peminjamId;
  String saveUrl;

  Future saveTransaksi() async {
    print(saveUrl);
    final http.Response response = await http.post(Uri.parse(saveUrl), body: {
      'peminjam_id': peminjamId.toString(),
      'tanggal_mulai': _tanggalMulai.text,
      'tanggal_selesai': _tanggalSelesai.text,
      'nama_acara': _namaAcara.text,
      'penanggung_jawab': _penanggungJawab.text,
      'kontak': _kontak.text,
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
        title: Text('Transaksi'),
        backgroundColor: Color(0xFF006600),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2010),
                      lastDate: DateTime(2030));

                  String date = DateFormat('dd-MM-yyyy').format(_dateTime);
                  _tanggalMulai.text = date;
                },
                controller: _tanggalMulai,
                decoration: InputDecoration(labelText: "Tanggal Mulai"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input this field !";
                  }
                  return null;
                },
              ),
              TextFormField(
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2010),
                      lastDate: DateTime(2030));

                  String date = DateFormat('dd-MM-yyyy').format(_dateTime);
                  _tanggalSelesai.text = date;
                },
                controller: _tanggalSelesai,
                decoration: InputDecoration(labelText: "Tanggal Selesai"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input this field !";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaAcara,
                decoration: InputDecoration(labelText: "Nama Acara"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input this field !";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _penanggungJawab,
                decoration: InputDecoration(labelText: "Penanggung Jawab"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input this field !";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _kontak,
                decoration: InputDecoration(labelText: "kontak"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input this field !";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Transaksi saved successfully')));
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
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white70,
                          onPrimary: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text("Cancel")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
