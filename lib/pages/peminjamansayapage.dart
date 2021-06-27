import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:ta_sispem/model/transaksi.dart';
import 'package:ta_sispem/pages/addkritik.dart';
import 'package:ta_sispem/repository/auth_repository.dart';
import 'package:ta_sispem/services/servicestransaksi.dart';
import 'package:ta_sispem/url.dart';
import 'addtransaksi.dart';

import 'package:http/http.dart' as http;

import '../blocs/navigation_bloc.dart';

class PeminjamanPage extends StatefulWidget with NavigationStates {
  final AuthBloc authBloc;

  const PeminjamanPage({Key key, this.authBloc}) : super(key: key);
  @override
  PeminjamanPageState createState() => PeminjamanPageState();
}

class PeminjamanPageState extends State<PeminjamanPage> {
  List<Transaksi> _transaksi;
  AuthRepository repo = AuthRepository();
  int peminjamId;

  @override
  void initState() {
    _transaksi = [];
    super.initState();
    Future token = repo.hasToken();
    token.then((value) => repo.getData(value).then((e) {
          setState(() {
            peminjamId = e.peminjamId;
            TransaksiService.myUrl = Url.url +
                '/api/peminjams/' +
                peminjamId.toString() +
                '/transaksis/' +
                peminjamId.toString();
            TransaksiService.getTransaksi(TransaksiService.myUrl)
                .then((transaksi) {
              setState(() {
                _transaksi = transaksi;
              });
            });
          });
        }));
  }

  Future hapusTransaksi(id) async {
    print(id);
    String deleteUrl = Url.url + '/api/transaksis/' + id;
    print(deleteUrl);
    final http.Response response = await http.delete(Uri.parse(deleteUrl));
    print(response.body);
    final hasil = json.decode(response.body);
    return hasil;
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
              "Transaksi",
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
                              label: Text("Ruangan"),
                            ),
                            DataColumn(
                              label: Text("Kontak"),
                            ),
                            DataColumn(
                              label: Text("WR II/KBUSD"),
                            ),
                            DataColumn(
                              label: Text("KBU"),
                            ),
                            DataColumn(
                              label: Text("KSBRT"),
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
                                      Text(transaksi.id.toString()),
                                    ),
                                    DataCell(
                                      Text(transaksi.namaRuangan),
                                    ),
                                    DataCell(
                                      Text(transaksi.kontak),
                                    ),
                                    DataCell(
                                      Text(transaksi.konfirmasiWRid.toString()),
                                    ),
                                    DataCell(
                                      Text(
                                          transaksi.konfirmasiKBUid.toString()),
                                    ),
                                    DataCell(
                                      Text(transaksi.konfirmasiKBSDid
                                          .toString()),
                                    ),
                                    transaksi.konfirmasiWRid != null
                                        ? DataCell(
                                            Container(
                                              width: 155,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddTransaksi())),
                                                    child: Text(
                                                      "Cetak",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white70)),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddKritik())),
                                                    child: Text("Selesai"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : DataCell(
                                            ElevatedButton(
                                              onPressed: () {
                                                hapusTransaksi(
                                                        transaksi.id.toString())
                                                    .then((value) {
                                                  TransaksiService.getTransaksi(
                                                          TransaksiService
                                                              .myUrl)
                                                      .then((transaksi) {
                                                    setState(() {
                                                      _transaksi = transaksi;
                                                    });
                                                  });
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Transaksi deleted successfully')));
                                                });
                                              },
                                              child: Text("Batalkan"),
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red)),
                                            ),
                                          ),
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
