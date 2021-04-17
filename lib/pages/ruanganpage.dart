import 'package:flutter/material.dart';
import 'package:ta_sispem/model/ruangan.dart';
import 'package:ta_sispem/services/servicesruangan.dart';

import '../bloc.navigation_bloc/navigation_bloc.dart';

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
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Text("Semua Ruangan"),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: DataTable(
                        columns: [
                          DataColumn(
                            label: Text("#",
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12)),
                          ),
                          DataColumn(
                            label: Text("Ruangan",
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12)),
                          ),
                          DataColumn(
                            label: Text("Kapasitas",
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12)),
                          ),
                          DataColumn(
                            label: Text("Penjaga",
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12)),
                          ),
                          DataColumn(
                            label: Text("Kontak",
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12)),
                          ),
                          DataColumn(
                            label: Text("Status",
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12)),
                          ),
                          DataColumn(
                            label: Text("Aksi",
                                style: TextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 12)),
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
                                          Text("Pinjam"),
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
    );
  }
}
