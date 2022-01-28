import 'dart:convert';
import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:ta_sispem/model/transaksi.dart';
import 'package:ta_sispem/pages/addkritik.dart';
import 'package:ta_sispem/repository/auth_repository.dart';
import 'package:ta_sispem/services/servicestransaksi.dart';
import 'package:ta_sispem/url.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

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

  final imgUrl = "";

  var dio = Dio();

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
    getPermission();
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

  Future cetakTransaksi(id) async {
    print(id);
    String cetakUrl = Url.url + '/api/transaksi/' + id + '/cetak';
    print(cetakUrl);
    final http.Response response = await http.get(Uri.parse(cetakUrl));
    final hasil = json.decode(response.body);
    print(hasil);
    return hasil;
  }

  void getPermission() async {
    print("getPermission");
    await Permission.storage.request();
  }

  Future download2(Dio dio, String url, String savePath) async {
    //get pdf from link
    Response response = await dio.get(
      url,
      onReceiveProgress: showDownloadProgress,
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );

    //write in download folder
    File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
  }

  void showDownloadProgress(int received, int total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
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
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  height: 625,
                  child: ListView.builder(
                      itemCount: _transaksi.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: Colors.black12,
                          ),
                          width: double.infinity,
                          height: 155,
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Text(
                                          _transaksi[index].namaRuangan,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        // SizedBox(width: 5),
                                        // Text(
                                        //     'tanggal: ' +
                                        //         _transaksi[index]
                                        //             .tanggalMulai
                                        //             .toString(),
                                        //     style: TextStyle(
                                        //         fontWeight: FontWeight.bold,
                                        //         fontSize: 10)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
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
                                        Text(_transaksi[index].hp,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: .3)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "WR II/KBUSD",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 8,
                                              letterSpacing: .3),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        _transaksi[index].konfirmasiWRid != null
                                            ? _transaksi[index].pkwr2 == 1
                                                ? Row(
                                                    children: [
                                                      Text(
                                                        "Diterima",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 8,
                                                          letterSpacing: .3,
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "tanggal: " +
                                                            _transaksi[index]
                                                                .pkwr2Tgl
                                                                .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 8,
                                                          letterSpacing: .3,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    "Ditolak",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 8,
                                                      letterSpacing: .3,
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  )
                                            : _transaksi[index]
                                                        .konfirmasiKBSDid !=
                                                    null
                                                ? _transaksi[index].pkbsd == 1
                                                    ? Row(
                                                        children: [
                                                          Text(
                                                            "Diterima",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 8,
                                                              letterSpacing: .3,
                                                              backgroundColor:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            "tanggal: " +
                                                                _transaksi[
                                                                        index]
                                                                    .pkbsdTgl
                                                                    .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 8,
                                                              letterSpacing: .3,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Text(
                                                        "Ditolak",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 8,
                                                          letterSpacing: .3,
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      )
                                                : Text(
                                                    "Belum Direspon",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 8,
                                                      letterSpacing: .3,
                                                      backgroundColor:
                                                          Colors.orange,
                                                    ),
                                                  ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "KBU",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 8,
                                              letterSpacing: .3),
                                        ),
                                        SizedBox(
                                          width: 47,
                                        ),
                                        _transaksi[index].konfirmasiWRid !=
                                                    null ||
                                                _transaksi[index]
                                                        .konfirmasiKBSDid !=
                                                    null
                                            ? _transaksi[index].pkwr2 == 1 ||
                                                    _transaksi[index].pkbsd == 1
                                                ? _transaksi[index]
                                                            .konfirmasiKBUid !=
                                                        null
                                                    ? _transaksi[index].pkbu ==
                                                            1
                                                        ? Row(
                                                            children: [
                                                              Text(
                                                                "Diterima",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 8,
                                                                  letterSpacing:
                                                                      .3,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "tanggal: " +
                                                                    _transaksi[
                                                                            index]
                                                                        .pkbuTgl
                                                                        .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 8,
                                                                  letterSpacing:
                                                                      .3,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : _transaksi[index]
                                                                    .pkbu ==
                                                                0
                                                            ? Text(
                                                                "Ditolak",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 8,
                                                                  letterSpacing:
                                                                      .3,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              )
                                                            : Text(
                                                                "Belum Direspon",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 8,
                                                                  letterSpacing:
                                                                      .3,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .orange,
                                                                ),
                                                              )
                                                    : Text(
                                                        "Belum Direspon",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 8,
                                                          letterSpacing: .3,
                                                          backgroundColor:
                                                              Colors.orange,
                                                        ),
                                                      )
                                                : Text(
                                                    "Ditolak",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 8,
                                                      letterSpacing: .3,
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  )
                                            : Text(
                                                "Belum Direspon",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 8,
                                                  letterSpacing: .3,
                                                  backgroundColor:
                                                      Colors.orange,
                                                ),
                                              )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Row(children: <Widget>[
                                      Text(
                                        "KSBRT",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 8,
                                            letterSpacing: .3),
                                      ),
                                      SizedBox(
                                        width: 37,
                                      ),
                                      _transaksi[index].konfirmasiWRid != null ||
                                              _transaksi[index]
                                                      .konfirmasiKBSDid !=
                                                  null ||
                                              _transaksi[index]
                                                      .konfirmasiKBUid !=
                                                  null
                                          ? _transaksi[index].pkwr2 == 1 ||
                                                  _transaksi[index].pkbsd ==
                                                      1 ||
                                                  _transaksi[index].pkbu == 1
                                              ? _transaksi[index]
                                                          .konfirmasiKSBRTid !=
                                                      null
                                                  ? _transaksi[index].pksbrt ==
                                                          1
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              "Diterima",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 8,
                                                                letterSpacing:
                                                                    .3,
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "tanggal: " +
                                                                  _transaksi[
                                                                          index]
                                                                      .pksbrtTgl
                                                                      .toString(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 8,
                                                                letterSpacing:
                                                                    .3,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Text(
                                                          "Ditolak",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 8,
                                                            letterSpacing: .3,
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                        )
                                                  : _transaksi[index].pkbu == 0
                                                      ? Text(
                                                          "Ditolak",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 8,
                                                            letterSpacing: .3,
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                        )
                                                      : _transaksi[index]
                                                                      .pksbrt ==
                                                                  0 ||
                                                              _transaksi[index]
                                                                      .pkwr2 ==
                                                                  0
                                                          ? Text(
                                                              "Ditolak",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 8,
                                                                letterSpacing:
                                                                    .3,
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                            )
                                                          : Text(
                                                              "Belum Direspon",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 8,
                                                                letterSpacing:
                                                                    .3,
                                                                backgroundColor:
                                                                    Colors
                                                                        .orange,
                                                              ),
                                                            )
                                              : Text(
                                                  "Ditolak",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 8,
                                                    letterSpacing: .3,
                                                    backgroundColor: Colors.red,
                                                  ),
                                                )
                                          : Text(
                                              "Belum Direspon",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 8,
                                                letterSpacing: .3,
                                                backgroundColor: Colors.orange,
                                              ),
                                            )
                                    ]),
                                    _transaksi[index].status == 1
                                        ? Text("")
                                        : _transaksi[index].status == 2
                                            ? Container(
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: ElevatedButton(
                                                    onPressed: () => {},
                                                    child: Text(
                                                      "Ditolak",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white70)),
                                                  ),
                                                ),
                                              )
                                            : _transaksi[index]
                                                            .konfirmasiWRid !=
                                                        null ||
                                                    _transaksi[index]
                                                                .konfirmasiKBSDid !=
                                                            null &&
                                                        _transaksi[index]
                                                                .konfirmasiKBUid !=
                                                            null &&
                                                        _transaksi[index]
                                                                .konfirmasiKSBRTid !=
                                                            null
                                                ? Container(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                        width: 155,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                String path = await ExtStorage
                                                                    .getExternalStoragePublicDirectory(
                                                                        ExtStorage
                                                                            .DIRECTORY_DOWNLOADS);
                                                                String
                                                                    fullPath =
                                                                    "$path/cetak" +
                                                                        _transaksi[index]
                                                                            .id
                                                                            .toString() +
                                                                        ".pdf";
                                                                cetakTransaksi(_transaksi[
                                                                            index]
                                                                        .id
                                                                        .toString())
                                                                    .then((value) =>
                                                                        download2(
                                                                            dio,
                                                                            value,
                                                                            fullPath));
                                                                // showDialog(
                                                                //     context: context,
                                                                //     builder: (BuildContext
                                                                //         context) {
                                                                //       return Container(
                                                                //           child:
                                                                //               CircularProgressIndicator(),
                                                                //           width: 32,
                                                                //           height: 32);
                                                                //     });
                                                                // Future.delayed(
                                                                //     const Duration(
                                                                //         seconds: 1));

                                                                new Future
                                                                        .delayed(
                                                                    const Duration(
                                                                        seconds:
                                                                            10));
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(SnackBar(
                                                                        content:
                                                                            Text("Download Successfully")));
                                                              },
                                                              child: Text(
                                                                "Cetak",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .white70)),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () =>
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => AddKritik(
                                                                                transaksi: _transaksi[index],
                                                                              ))),
                                                              child: Text(
                                                                  "Selesai"),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      "Warning!"),
                                                                  content: Text(
                                                                      "Yakin untuk membatalkan?"),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () => Navigator.pop(context, 'Cancel'),
                                                                        child: Text(
                                                                            'Cancel')),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          hapusTransaksi(_transaksi[index].id.toString())
                                                                              .then((value) {
                                                                            TransaksiService.getTransaksi(TransaksiService.myUrl).then((transaksi) {
                                                                              setState(() {
                                                                                _transaksi = transaksi;
                                                                              });
                                                                            });
                                                                            Navigator.pop(context, 'Continue');
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transaksi deleted successfully')));
                                                                          });
                                                                        },
                                                                        child: Text(
                                                                            'Continue')),
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: Text("Batalkan"),
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .red)),
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
      ),
    );
  }
}
