import 'package:flutter/material.dart';
import 'package:ta_sispem/model/ruangan.dart';
import 'package:ta_sispem/services/servicesruangan.dart';
import 'addtransaksi.dart';

import '../blocs/navigation_bloc.dart';

class RuanganPage extends StatefulWidget with NavigationStates {
  @override
  RuanganPageState createState() => RuanganPageState();
}

class RuanganPageState extends State<RuanganPage> {
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
                                                          AddTransaksi())),
                                              child: Text("Pinjam"),
                                            ),
                                          )
                                        : DataCell(
                                            Text("Lihat"),
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
