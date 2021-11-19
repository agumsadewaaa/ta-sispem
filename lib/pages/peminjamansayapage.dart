import 'dart:convert';
import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:twinkle_button/twinkle_button.dart';
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
                                      Text(transaksi.pkbsd.toString()),
                                    ),
                                    transaksi.konfirmasiWRid != null
                                        ? transaksi.pkwr2 == 1
                                            ? DataCell(
                                                TwinkleButton(
                                                  buttonTitle: Text('Diterima'),
                                                  buttonColor: Colors.green,
                                                  buttonHeight: 40,
                                                  buttonWidth: 125,
                                                  onclickButtonFunction: () {},
                                                ),
                                              )
                                            : DataCell(
                                                TwinkleButton(
                                                  buttonTitle: Text('Ditolak'),
                                                  buttonColor: Colors.red,
                                                  buttonHeight: 40,
                                                  buttonWidth: 125,
                                                  onclickButtonFunction: () {},
                                                ),
                                              )
                                        : transaksi.konfirmasiKBSDid != null
                                            ? transaksi.pkbsd == 1
                                                ? DataCell(
                                                    TwinkleButton(
                                                      buttonTitle:
                                                          Text('Diterima'),
                                                      buttonColor: Colors.green,
                                                      buttonHeight: 40,
                                                      buttonWidth: 125,
                                                      onclickButtonFunction:
                                                          () {},
                                                    ),
                                                  )
                                                : DataCell(
                                                    TwinkleButton(
                                                      buttonTitle:
                                                          Text('Ditolak'),
                                                      buttonColor: Colors.red,
                                                      buttonHeight: 40,
                                                      buttonWidth: 125,
                                                      onclickButtonFunction:
                                                          () {},
                                                    ),
                                                  )
                                            : DataCell(TwinkleButton(
                                                buttonTitle:
                                                    Text('Belum Direspon'),
                                                buttonColor: Colors.orange,
                                                buttonHeight: 40,
                                                buttonWidth: 125,
                                                onclickButtonFunction: () {},
                                              )),
                                    transaksi.konfirmasiWRid != null ||
                                            transaksi.konfirmasiKBSDid != null
                                        ? transaksi.pkwr2 == 1 ||
                                                transaksi.pkbsd == 1
                                            ? transaksi.konfirmasiKBUid != null
                                                ? transaksi.pkbu == 1
                                                    ? DataCell(
                                                        TwinkleButton(
                                                          buttonTitle:
                                                              Text('Diterima'),
                                                          buttonColor:
                                                              Colors.green,
                                                          buttonHeight: 40,
                                                          buttonWidth: 125,
                                                          onclickButtonFunction:
                                                              () {},
                                                        ),
                                                      )
                                                    : DataCell(
                                                        TwinkleButton(
                                                          buttonTitle:
                                                              Text('Ditolak'),
                                                          buttonColor:
                                                              Colors.red,
                                                          buttonHeight: 40,
                                                          buttonWidth: 125,
                                                          onclickButtonFunction:
                                                              () {},
                                                        ),
                                                      )
                                                : DataCell(
                                                    TwinkleButton(
                                                      buttonTitle:
                                                          Text('Ditolak'),
                                                      buttonColor: Colors.green,
                                                      buttonHeight: 40,
                                                      buttonWidth: 125,
                                                      onclickButtonFunction:
                                                          () {},
                                                    ),
                                                  )
                                            : DataCell(
                                                TwinkleButton(
                                                  buttonTitle: Text('Ditolak'),
                                                  buttonColor: Colors.red,
                                                  buttonHeight: 40,
                                                  buttonWidth: 125,
                                                  onclickButtonFunction: () {},
                                                ),
                                              )
                                        : DataCell(TwinkleButton(
                                            buttonTitle: Text('Belum Direspon'),
                                            buttonColor: Colors.orange,
                                            buttonHeight: 40,
                                            buttonWidth: 125,
                                            onclickButtonFunction: () {},
                                          )),
                                    transaksi.konfirmasiWRid != null ||
                                            transaksi.konfirmasiKBSDid !=
                                                null ||
                                            transaksi.konfirmasiKBUid != null
                                        ? transaksi.pkwr2 == 1 ||
                                                transaksi.pkbsd == 1 ||
                                                transaksi.pkbu == 1
                                            ? transaksi.konfirmasiKSBRTid !=
                                                    null
                                                ? transaksi.pksbrt == 1
                                                    ? DataCell(
                                                        TwinkleButton(
                                                          buttonTitle:
                                                              Text('Diterima'),
                                                          buttonColor:
                                                              Colors.green,
                                                          buttonHeight: 40,
                                                          buttonWidth: 125,
                                                          onclickButtonFunction:
                                                              () {},
                                                        ),
                                                      )
                                                    : DataCell(
                                                        TwinkleButton(
                                                          buttonTitle:
                                                              Text('Ditolak'),
                                                          buttonColor:
                                                              Colors.red,
                                                          buttonHeight: 40,
                                                          buttonWidth: 125,
                                                          onclickButtonFunction:
                                                              () {},
                                                        ),
                                                      )
                                                : DataCell(
                                                    TwinkleButton(
                                                      buttonTitle:
                                                          Text('Ditolak'),
                                                      buttonColor: Colors.red,
                                                      buttonHeight: 40,
                                                      buttonWidth: 125,
                                                      onclickButtonFunction:
                                                          () {},
                                                    ),
                                                  )
                                            : DataCell(TwinkleButton(
                                                buttonTitle:
                                                    Text('Belum Direspon'),
                                                buttonColor: Colors.orange,
                                                buttonHeight: 40,
                                                buttonWidth: 125,
                                                onclickButtonFunction: () {},
                                              ))
                                        : DataCell(TwinkleButton(
                                            buttonTitle: Text('Belum Direspon'),
                                            buttonColor: Colors.orange,
                                            buttonHeight: 40,
                                            buttonWidth: 125,
                                            onclickButtonFunction: () {},
                                          )),
                                    transaksi.konfirmasiWRid != null ||
                                            transaksi.konfirmasiKBSDid !=
                                                    null &&
                                                transaksi.konfirmasiKBUid !=
                                                    null &&
                                                transaksi.konfirmasiKSBRTid !=
                                                    null
                                        ? DataCell(
                                            Container(
                                              width: 155,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      String path = await ExtStorage
                                                          .getExternalStoragePublicDirectory(
                                                              ExtStorage
                                                                  .DIRECTORY_DOWNLOADS);
                                                      String fullPath =
                                                          "$path/cetak.pdf";
                                                      cetakTransaksi(transaksi
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

                                                      new Future.delayed(
                                                          const Duration(
                                                              seconds: 10));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "Download Successfully")));
                                                    },
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
