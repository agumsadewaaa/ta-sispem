import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:ta_sispem/model/transaksi.dart';
import 'package:ta_sispem/repository/auth_repository.dart';
import 'package:ta_sispem/services/servicestransaksi.dart';
import 'package:ta_sispem/url.dart';

import 'package:http/http.dart' as http;

import '../blocs/navigation_bloc.dart';

class ListPeminjamanPage extends StatefulWidget with NavigationStates {
  final AuthBloc authBloc;

  const ListPeminjamanPage({Key key, this.authBloc}) : super(key: key);
  @override
  ListPeminjamanPageState createState() => ListPeminjamanPageState();
}

class ListPeminjamanPageState extends State<ListPeminjamanPage> {
  List<Transaksi> _transaksi;
  TextEditingController _pesanController = TextEditingController();
  bool _validate;
  AuthRepository repo = AuthRepository();
  int roleId;
  int status;

  @override
  void initState() {
    _transaksi = [];
    super.initState();
    Future token = repo.hasToken();
    token.then((value) => repo.getData(value).then((e) {
          setState(() {
            roleId = e.roleId;
            TransaksiService.myUrl =
                Url.url + '/api/transaksis/listSemua/' + roleId.toString();
            TransaksiService.getPeminjaman(TransaksiService.myUrl)
                .then((transaksi) {
              setState(() {
                _transaksi = transaksi;
              });
            });
          });
        }));
  }

  @override
  void dispose() {
    _pesanController.dispose();
    super.dispose();
  }

  Future savePesan(int idTransaksi, int s) async {
    print(idTransaksi + s);
    String savePesanUrl = Url.url + '/api/pesanKonfirmasis';

    if (s == 0) {
      final http.Response response =
          await http.post(Uri.parse(savePesanUrl), body: {
        'transaksi_id': idTransaksi.toString(),
        'pesan': _pesanController.text,
        'target': roleId.toString(),
        'tolak': '1'
      });

      print(response.body);
      final hasil = json.decode(response.body);
      return hasil;
    } else {
      final http.Response response =
          await http.post(Uri.parse(savePesanUrl), body: {
        'transaksi_id': idTransaksi.toString(),
        'pesan': _pesanController.text,
        'target': roleId.toString(),
        'terima': '1'
      });

      print(response.body);
      final hasil = json.decode(response.body);
      return hasil;
    }
  }

  createAlertDialog(BuildContext context, int idTransaksi) {
    _pesanController.text = '';
    _validate = false;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Konfirmasi Peminjaman"),
            content: TextField(
              decoration: InputDecoration(
                  labelText: 'Pesan Konfirmasi',
                  errorText: _validate ? 'Please input this field!' : null),
              minLines: 1,
              maxLines: 5,
              controller: _pesanController,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _pesanController.text.isEmpty
                        ? _validate = true
                        : _validate = false;
                  });
                  savePesan(idTransaksi, 0).then((value) {
                    TransaksiService.getPeminjaman(TransaksiService.myUrl)
                        .then((transaksi) {
                      setState(() {
                        _transaksi = transaksi;
                      });
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Pesan Konfirmasi saved successfully')));
                    Navigator.of(context).pop();
                  });
                },
                child: Text("Tolak"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _pesanController.text.isEmpty
                          ? _validate = true
                          : _validate = false;
                    });
                    savePesan(idTransaksi, 1).then((value) {
                      TransaksiService.getPeminjaman(TransaksiService.myUrl)
                          .then((transaksi) {
                        setState(() {
                          _transaksi = transaksi;
                        });
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Pesan Konfirmasi saved successfully')));
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text("Terima")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Text(
              "Daftar Peminjaman",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Color(0xFF006600)),
                          headingTextStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                          columns: [
                            DataColumn(
                              label: Text("#"),
                            ),
                            DataColumn(
                              label: Text("Peminjam"),
                            ),
                            DataColumn(
                              label: Text("Organisasi"),
                            ),
                            DataColumn(
                              label: Text("Ruangan"),
                            ),
                            DataColumn(
                              label: Text("PJ"),
                            ),
                            DataColumn(
                              label: Text("Acara"),
                            ),
                            DataColumn(
                              label: Text("Aksi"),
                            ),
                          ],
                          rows: _transaksi
                              .map(
                                (transaksi) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text((_transaksi.indexOf(transaksi) + 1)
                                          .toString()),
                                    ),
                                    DataCell(
                                      Text(transaksi.namaPeminjam),
                                    ),
                                    DataCell(
                                      Text(transaksi.namaOrganisasi),
                                    ),
                                    DataCell(
                                      Text(transaksi.namaRuangan),
                                    ),
                                    DataCell(
                                      Text(transaksi.pj),
                                    ),
                                    DataCell(
                                      Text(transaksi.namaAcara),
                                    ),
                                    transaksi.status == 3
                                        ? DataCell(
                                            ElevatedButton(
                                              onPressed: () {},
                                              child: Text("Ditolak"),
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red)),
                                            ),
                                          )
                                        : transaksi.status == 4
                                            ? DataCell(
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text("Ditolak Sistem"),
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors.red)),
                                                ),
                                              )
                                            : roleId == 2 || roleId == 3
                                                ? transaksi.konfirmasiWRid !=
                                                            null ||
                                                        transaksi
                                                                .konfirmasiKBSDid !=
                                                            null
                                                    ? transaksi.pkwr2 == 1 ||
                                                            transaksi.pkbsd == 1
                                                        ? DataCell(
                                                            ElevatedButton(
                                                              onPressed: () {},
                                                              child: Text(
                                                                  "Diterima"),
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .green)),
                                                            ),
                                                          )
                                                        : DataCell(
                                                            ElevatedButton(
                                                              onPressed: () {},
                                                              child: Text(
                                                                  "Ditolak"),
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .red)),
                                                            ),
                                                          )
                                                    : DataCell(
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              createAlertDialog(
                                                                  context,
                                                                  transaksi.id);
                                                            },
                                                            child: Text(
                                                              "Respon",
                                                            )),
                                                      )
                                                : roleId == 4
                                                    ? transaksi.konfirmasiWRid !=
                                                                null ||
                                                            transaksi
                                                                    .konfirmasiKBSDid !=
                                                                null
                                                        ? transaksi.pkwr2 ==
                                                                    0 ||
                                                                transaksi
                                                                        .pkbsd ==
                                                                    0
                                                            ? DataCell(
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  child: Text(
                                                                      "Ditolak WR II/KBSD"),
                                                                  style: ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all(
                                                                              Colors.red)),
                                                                ),
                                                              )
                                                            : transaksi.konfirmasiKBUid !=
                                                                    null
                                                                ? transaksi.pkbu ==
                                                                        1
                                                                    ? DataCell(
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () {},
                                                                          child:
                                                                              Text("Diterima"),
                                                                          style:
                                                                              ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                                                                        ),
                                                                      )
                                                                    : DataCell(
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () {},
                                                                          child:
                                                                              Text("Ditolak"),
                                                                          style:
                                                                              ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                                                        ),
                                                                      )
                                                                : DataCell(
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          createAlertDialog(
                                                                              context,
                                                                              transaksi.id);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Respon",
                                                                        )),
                                                                  )
                                                        : DataCell(
                                                            ElevatedButton(
                                                              onPressed: () {},
                                                              child: Text(
                                                                  "Belum Dikonfirmasi WR II/KBSD"),
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .red)),
                                                            ),
                                                          )
                                                    : roleId == 5
                                                        ? transaksi.konfirmasiWRid !=
                                                                    null ||
                                                                transaksi
                                                                        .konfirmasiKBSDid !=
                                                                    null
                                                            ? transaksi.pkwr2 ==
                                                                        0 ||
                                                                    transaksi
                                                                            .pkbsd ==
                                                                        0
                                                                ? DataCell(
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {},
                                                                      child: Text(
                                                                          "Ditolak WR II/KBSD"),
                                                                      style: ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(Colors.red)),
                                                                    ),
                                                                  )
                                                                : transaksi.konfirmasiKBUid !=
                                                                        null
                                                                    ? transaksi.pkbu ==
                                                                            1
                                                                        ? transaksi.konfirmasiKSBRTid !=
                                                                                null
                                                                            ? transaksi.pksbrt == 1
                                                                                ? DataCell(
                                                                                    ElevatedButton(
                                                                                      onPressed: () {},
                                                                                      child: Text("Diterima"),
                                                                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                                                                                    ),
                                                                                  )
                                                                                : DataCell(
                                                                                    ElevatedButton(
                                                                                      onPressed: () {},
                                                                                      child: Text("Ditolak"),
                                                                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                                                                    ),
                                                                                  )
                                                                            : DataCell(
                                                                                ElevatedButton(
                                                                                    onPressed: () {
                                                                                      createAlertDialog(context, transaksi.id);
                                                                                    },
                                                                                    child: Text(
                                                                                      "Respon",
                                                                                    )),
                                                                              )
                                                                        : DataCell(
                                                                            ElevatedButton(
                                                                              onPressed: () {},
                                                                              child: Text("Ditolak KBU"),
                                                                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                                                            ),
                                                                          )
                                                                    : DataCell(
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () {},
                                                                          child:
                                                                              Text("Belum Dikonfirmasi KBU"),
                                                                          style:
                                                                              ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                                                        ),
                                                                      )
                                                            : DataCell(
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  child: Text(
                                                                      "Belum Dikonfirmasi WR II/KBSD"),
                                                                  style: ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all(
                                                                              Colors.red)),
                                                                ),
                                                              )
                                                        : DataCell(Text('')),
                                  ],
                                ),
                              )
                              .toList(),
                        )))),
          ],
        ),
      ),
    );
  }
}
