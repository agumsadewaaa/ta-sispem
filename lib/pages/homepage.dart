import 'package:flutter/material.dart';
import 'package:ta_sispem/repository/auth_repository.dart';
import '../blocs/navigation_bloc.dart';

class HomePage extends StatefulWidget with NavigationStates {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthRepository repo = AuthRepository();
  String name;

  @override
  void initState() {
    super.initState();
    Future token = repo.hasToken();
    token.then((value) => repo.getData(value).then((e) {
          setState(() {
            name = "Selamat Datang " + e.name;
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      name ?? '',
      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      textAlign: TextAlign.center,
    ));
  }
}
