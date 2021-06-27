import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:ta_sispem/model/transaksi.dart';
import 'package:ta_sispem/repository/auth_repository.dart';
import 'package:ta_sispem/services/servicestransaksi.dart';
import 'package:ta_sispem/url.dart';
import 'addtransaksi.dart';

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
  AuthRepository repo = AuthRepository();
  int roleId;

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
                                      Text(transaksi.id.toString()),
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
                                    transaksi.konfirmasiWRid == null ||
                                            transaksi.konfirmasiKBSDid == null
                                        ? DataCell(
                                            ElevatedButton(
                                                onPressed: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddTransaksi())),
                                                child: Text(
                                                  "Respon",
                                                )),
                                          )
                                        : DataCell(
                                            ElevatedButton(
                                              onPressed: null,
                                              child: Text(
                                                "Batalkan",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white70)),
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
