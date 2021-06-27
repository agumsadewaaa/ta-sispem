import 'package:flutter/material.dart';
import '../blocs/navigation_bloc.dart';

class PanduanPage extends StatefulWidget with NavigationStates {
  @override
  _PanduanPageState createState() => _PanduanPageState();
}

class _PanduanPageState extends State<PanduanPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Panduan Peminjaman",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
            ),
            Divider(
              height: 32,
              thickness: 0.5,
              color: Colors.white.withOpacity(0.3),
              indent: 32,
              endIndent: 32,
            ),
            Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Text("1."),
                    title: Text(
                      "Peminjam mencari ruangan yang akan dipinjam berdasarkan tanggal (jika sudah dipinjam pada tanggal tersebut bisa melihat siapa yang meminjam)",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 12),
                    ),
                    minLeadingWidth: 10,
                  ),
                  Column(
                    children: [
                      ListTile(
                        leading: Text(""),
                        title: ListTile(
                          leading: MyBullet(),
                          title: Text(
                            "Jika melihat ketersediaan ruangan pada speifik tanggal tertentu, hanya isi tanggal rentang awal saja",
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 12),
                          ),
                          minLeadingWidth: 10,
                        ),
                        minLeadingWidth: 10,
                      ),
                      ListTile(
                        leading: Text(""),
                        title: ListTile(
                          leading: MyBullet(),
                          title: Text(
                            "Jika melihat ketersediaan ruangan pada rentang tanggal tertentu, isi tanggal rentang awal dan akhir",
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 12),
                          ),
                          minLeadingWidth: 10,
                        ),
                        minLeadingWidth: 10,
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Text("2."),
                    title: Text(
                      "Peminjam hanya bisa meminjam ruangan setidaknya 3 hari sebelum tanggal pemakaian ruangan dimulai",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 12),
                    ),
                    minLeadingWidth: 10,
                  ),
                  ListTile(
                    leading: Text("3."),
                    title: Text(
                      "Silahkan tunggu konfirmasi dari WR II, KBSD, dan KSBU",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 12),
                    ),
                    minLeadingWidth: 10,
                  ),
                  ListTile(
                    leading: Text("4."),
                    title: Text(
                      "Jika WR II, KBSD, dan KSBU sudah menyetujui peminjaman, maka bisa mencetak surat peminjaman",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 12),
                    ),
                    minLeadingWidth: 10,
                  ),
                  ListTile(
                    leading: Text("5."),
                    title: Text(
                      "Bawa print out surat peminjaman ke KSBU untuk ditandatangani",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 12),
                    ),
                    minLeadingWidth: 10,
                  ),
                  ListTile(
                    leading: Text("6."),
                    title: Text(
                      "Setelah selesai pemakaian ruangan, WAJIB mengkonfirmasi selesai pemakaian, dengan menekan tombol selesai. Kritik dan saran harap di isi",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 12),
                    ),
                    minLeadingWidth: 10,
                  ),
                  ListTile(
                    leading: Text("7."),
                    title: Text(
                      "Jika tidak mengkonfirmasi selesai pemakaian ruangan setelah jatuh tempo tanggal selesai yang disimpan dalam sistem, maka sistem otomatis blokir akun peminjam",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                    minLeadingWidth: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 5.0,
      width: 5.0,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}
