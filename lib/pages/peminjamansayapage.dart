import 'package:flutter/material.dart';

import '../blocs/navigation_bloc.dart';

class PeminjamanPage extends StatelessWidget with NavigationStates {
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
              label: Text("Ruangan",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12)),
            ),
            DataColumn(
              label: Text("Kontak",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12)),
            ),
            DataColumn(
              label: Text("WR II/KBUSD",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12)),
            ),
            DataColumn(
              label: Text("KBU",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12)),
            ),
            DataColumn(
              label: Text("KSBRT",
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
