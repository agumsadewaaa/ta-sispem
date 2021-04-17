import 'package:flutter/material.dart';

import '../bloc.navigation_bloc/navigation_bloc.dart';

class ListPeminjamanPage extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Center(
        child: DataTable(
          columns: [
            DataColumn(
              label: Text("#",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12)),
            ),
            DataColumn(
              label: Text("Peminjam",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12)),
            ),
            DataColumn(
              label: Text("Organisasi",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12)),
            ),
            DataColumn(
              label: Text("PJ",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12)),
            ),
            DataColumn(
              label: Text("Acara",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12)),
            ),
            DataColumn(
              label: Text("Tanggal Mulai",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12)),
            ),
            DataColumn(
              label: Text("Tanggal Selesai",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12)),
            ),
            DataColumn(
              label: Text("Aksi",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12)),
            ),
          ],
          rows: [],
        ),
      ),
    );
  }
}
