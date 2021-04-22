import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:ta_sispem/event/auth_event.dart';
import 'package:ta_sispem/login.dart';
import 'package:ta_sispem/repository/auth_repository.dart';
import 'package:ta_sispem/state/auth_state.dart';
import 'sidebar/sidebar_layout.dart';

class Home extends StatefulWidget {
  final AuthBloc authBloc;

  const Home({Key key, this.authBloc}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthRepository authRepository = AuthRepository();
  AuthBloc get _authBloc => widget.authBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _authBloc,
      builder: (context, state) {
        if (state is AuthHasToken) {
          _authBloc.add(GetDataWithToken(state.token));
          return Container();
        }
        if (state is AuthData) {
          return Container(
            color: Colors.white,
            child: SideBarLayout(
              authBloc: _authBloc,
            ),
          );
        }
        return LoginPage(
          authBloc: _authBloc,
        );
      },
    );
  }
}
