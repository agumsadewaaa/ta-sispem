import 'package:flutter/material.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:ta_sispem/model/ruangan.dart';
import 'package:ta_sispem/services/servicesruangan.dart';
import 'addtransaksi.dart';

import '../blocs/navigation_bloc.dart';

class RuanganPage extends StatefulWidget with NavigationStates {
  final AuthBloc authBloc;

  const RuanganPage({Key key, this.authBloc}) : super(key: key);

  @override
  RuanganPageState createState() => RuanganPageState();

  void initState() {}
}

class RuanganPageState extends State<RuanganPage> {
  AuthBloc get _authBloc => widget.authBloc;
  List<Ruangan> _ruangan;

  @override
  void initState() {
    _ruangan = [];
    super.initState();
    RuanganService.getRuangan().then((ruangan) {
      setState(() {
        _ruangan = ruangan;
      });
    });
    print(_authBloc.toString());
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
              "Semua Ruangan",
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
                              label: Text("Kapasitas"),
                            ),
                            DataColumn(
                              label: Text("Penjaga"),
                            ),
                            DataColumn(
                              label: Text("Kontak"),
                            ),
                            DataColumn(
                              label: Text("Status"),
                            ),
                            DataColumn(
                              label: Text("Aksi"),
                            ),
                          ],
                          rows: _ruangan
                              .map(
                                (ruangan) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(ruangan.id.toString()),
                                    ),
                                    DataCell(
                                      Text(ruangan.namaRuangan),
                                    ),
                                    DataCell(
                                      Text(ruangan.kapasitas.toString()),
                                    ),
                                    DataCell(
                                      Text(ruangan.namaPenjaga),
                                    ),
                                    DataCell(
                                      Text(ruangan.kontak),
                                    ),
                                    DataCell(
                                      Text(ruangan.status.toString()),
                                    ),
                                    ruangan.status.toString() == 'Tersedia'
                                        ? DataCell(
                                            ElevatedButton(
                                              onPressed: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddTransaksi(
                                                            authBloc: _authBloc,
                                                            ruangan: ruangan,
                                                          ))),
                                              child: Text("Pinjam"),
                                            ),
                                          )
                                        : DataCell(
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40)),
                                                      elevation: 16,
                                                      child: Container(
                                                        height: 300.0,
                                                        width: 360.0,
                                                        child: ListView(
                                                          children: <Widget>[
                                                            SizedBox(
                                                                height: 20),
                                                            Center(
                                                              child: Text(
                                                                "Detail",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    color: Colors
                                                                        .blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 20),
                                                            _showDetail(
                                                                id: ruangan.id,
                                                                nama: ruangan
                                                                    .namaRuangan,
                                                                status: ruangan
                                                                    .status)
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text(
                                                "Lihat",
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

Widget _showDetail({int id, String nama, String status}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      children: <Widget>[
        ListTile(
          leading: Text("id"),
          title: Text(": " + id.toString()),
        ),
        ListTile(
          leading: Text("Nama"),
          title: Text(": " + nama),
        ),
        ListTile(
          leading: Text("Status"),
          title: Text(": " + status.toString()),
        )
      ],
    ),
  );
}
