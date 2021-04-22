import 'package:flutter/material.dart';
import '../blocs/navigation_bloc.dart';

class PanduanPage extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Panduan Peminjaman",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}
