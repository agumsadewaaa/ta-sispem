import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:ta_sispem/model/ruangan.dart';
import 'package:ta_sispem/repository/auth_repository.dart';
import 'package:ta_sispem/services/servicesruangan.dart';
import 'package:ta_sispem/url.dart';
import 'addtransaksi.dart';
import 'package:intl/intl.dart';

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
  AuthRepository repo = AuthRepository();
  int peminjamId;
  List<Ruangan> _ruangan;
  DateTime _dateTime;
  TextEditingController _tanggalMulai = TextEditingController();

  @override
  void initState() {
    _ruangan = [];
    super.initState();
    Future token = repo.hasToken();
    token.then((value) => repo.getData(value).then((e) {
          setState(() {
            peminjamId = e.peminjamId;
            RuanganService.myUrl = Url.url +
                '/api/peminjams/' +
                peminjamId.toString() +
                '/transaksis/';
            RuanganService.getRuangan(RuanganService.myUrl).then((ruangan) {
              setState(() {
                _ruangan = ruangan;
              });
            });
          });
        }));
    print(_authBloc.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.fromLTRB(20, 50, 10, 0),
      child: Column(
        children: [
          Text(
            "Semua Ruangan",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25, right: 20, bottom: 10),
            child: TextFormField(
              onTap: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                _dateTime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(Duration(days: -3)),
                    firstDate: DateTime.now().subtract(Duration(days: -3)),
                    lastDate: DateTime(2030));

                String date = DateFormat('yyyy-MM-dd').format(_dateTime);
                _tanggalMulai.text = date;
              },
              controller: _tanggalMulai,
              decoration: InputDecoration(labelText: "Tanggal"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please input this field !";
                }
                return null;
              },
            ),
          ),
          ElevatedButton(
              onPressed: () => {
                    setState(() {
                      RuanganService.myUrl = Url.url +
                          '/api/peminjams/' +
                          peminjamId.toString() +
                          '/transaksis?jenis=semua&mulai=' +
                          _tanggalMulai.text.toString() +
                          '&akhir=';
                      print(RuanganService.myUrl);
                      RuanganService.getRuangan(RuanganService.myUrl)
                          .then((ruangan) => {
                                setState(() {
                                  _ruangan = ruangan;
                                })
                              });
                    })
                  },
              child: Text('Tampilkan')),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                height: 500,
                child: ListView.builder(
                    itemCount: _ruangan.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          color: Colors.black12,
                        ),
                        width: double.infinity,
                        height: 150,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Text(
                                        _ruangan[index].namaRuangan + '  | ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                          'kapasitas: ' +
                                              _ruangan[index]
                                                  .kapasitas
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.lightBlue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        color: Color(0xFF006600),
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(_ruangan[index].status,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              letterSpacing: .3)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.call,
                                        color: Color(0xFF006600),
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        children: [
                                          Text(_ruangan[index].namaPenjaga,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  letterSpacing: .3)),
                                          Text(_ruangan[index].kontak,
                                              style: TextStyle(
                                                  color: Colors.lightBlue,
                                                  fontSize: 10,
                                                  letterSpacing: .3)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  _ruangan[index].status.toString() ==
                                          'Tersedia'
                                      ? Container(
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: ElevatedButton(
                                              onPressed: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddTransaksi(
                                                            authBloc: _authBloc,
                                                            ruangan:
                                                                _ruangan[index],
                                                          ))),
                                              child: Text("Pinjam"),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: ElevatedButton(
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
                                                                id: _ruangan[
                                                                        index]
                                                                    .id,
                                                                nama: _ruangan[
                                                                        index]
                                                                    .namaRuangan,
                                                                status: _ruangan[
                                                                        index]
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
                                                          Colors.white)),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
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
