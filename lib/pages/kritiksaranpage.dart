import 'package:flutter/material.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:ta_sispem/model/kritiksaran.dart';
import 'package:ta_sispem/services/serviceskritiksaran.dart';

import '../blocs/navigation_bloc.dart';

class KritikSaranPage extends StatefulWidget with NavigationStates {
  final AuthBloc authBloc;

  const KritikSaranPage({Key key, this.authBloc}) : super(key: key);

  @override
  KritikSaranPageState createState() => KritikSaranPageState();

  void initState() {}
}

class KritikSaranPageState extends State<KritikSaranPage> {
  AuthBloc get _authBloc => widget.authBloc;
  List<KritikSaran> _kritiksaran;

  @override
  void initState() {
    _kritiksaran = [];
    super.initState();
    KritikSaranService.getRuangan().then((kritiksaran) {
      setState(() {
        _kritiksaran = kritiksaran;
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
              "Kritik dan Saran",
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
                              label: Text("Ruangan"),
                            ),
                            DataColumn(
                              label: Text("Mulai"),
                            ),
                            DataColumn(
                              label: Text("Selesai"),
                            ),
                            DataColumn(
                              label: Text("Aksi"),
                            ),
                          ],
                          rows: _kritiksaran
                              .map(
                                (kritiksaran) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(kritiksaran.id.toString()),
                                    ),
                                    DataCell(
                                      Text(kritiksaran.namaPeminjam),
                                    ),
                                    DataCell(
                                      Text(kritiksaran.namaRuangan),
                                    ),
                                    DataCell(
                                      Text(kritiksaran.mulai),
                                    ),
                                    DataCell(
                                      Text(kritiksaran.selesai),
                                    ),
                                    DataCell(
                                      ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)),
                                                elevation: 16,
                                                child: Container(
                                                  height: 240.0,
                                                  width: 360.0,
                                                  child: ListView(
                                                    children: <Widget>[
                                                      SizedBox(height: 20),
                                                      Center(
                                                        child: Text(
                                                          "Detail",
                                                          style: TextStyle(
                                                              fontSize: 24,
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      _showDetail(
                                                          id: kritiksaran.id,
                                                          keluhan: kritiksaran
                                                              .keluhan,
                                                          saran:
                                                              kritiksaran.saran)
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          "Lihat",
                                          style: TextStyle(color: Colors.black),
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

Widget _showDetail({int id, String keluhan, String saran}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      children: <Widget>[
        ListTile(
          leading: Text("Kritik"),
          title: Text(": " + keluhan),
        ),
        ListTile(
          leading: Text("Saran"),
          title: Text(": " + saran),
        ),
      ],
    ),
  );
}
