import 'package:flutter/material.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:ta_sispem/repository/auth_repository.dart';
import '../blocs/navigation_bloc.dart';

class HomePage extends StatefulWidget with NavigationStates {
  final AuthBloc authBloc;

  const HomePage({Key key, this.authBloc}) : super(key: key);

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
    return Container(
        padding: EdgeInsets.only(right: 5, left: 5),
        child: Center(
            child: Text(
          name ?? '',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
          textAlign: TextAlign.center,
        )));
  }
}
