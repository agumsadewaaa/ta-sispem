import 'package:flutter/material.dart';
import 'package:ta_sispem/model/transaksi.dart';
import 'package:ta_sispem/services/servicestransaksi.dart';
import 'addtransaksi.dart';

import '../blocs/navigation_bloc.dart';

class PeminjamanPage extends StatefulWidget with NavigationStates {
  @override
  PeminjamanPageState createState() => PeminjamanPageState();
}

class PeminjamanPageState extends State<PeminjamanPage> {
  List<Transaksi> _transaksi;

  @override
  void initState() {
    _transaksi = [];
    super.initState();
    TransaksiService.getTransaksi().then((transaksi) {
      setState(() {
        _transaksi = transaksi;
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
                                            ElevatedButton(
                                              onPressed: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddTransaksi())),
                                              child: Text("Cetak"),
                                            ),
                                          )
                                        : DataCell(
                                            Text("Batalkan"),
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
