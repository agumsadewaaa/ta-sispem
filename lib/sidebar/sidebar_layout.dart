import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:ta_sispem/repository/auth_repository.dart';
import 'package:ta_sispem/state/auth_state.dart';

import '../blocs/navigation_bloc.dart';
import 'sidebar.dart';
import 'sidebar_ver.dart';

class SideBarLayout extends StatefulWidget {
  final AuthRepository authRepository;
  final AuthBloc authBloc;
  final AuthData data;

  const SideBarLayout({Key key, this.authBloc, this.data, this.authRepository})
      : super(key: key);

  @override
  _SideBarLayoutState createState() => _SideBarLayoutState();
}

class _SideBarLayoutState extends State<SideBarLayout> {
  AuthRepository repo = AuthRepository();
  AuthBloc get _authBloc => widget.authBloc;
  int roleId;

  @override
  void initState() {
    super.initState();
    Future token = repo.hasToken();
    token.then((value) => repo.getData(value).then((e) {
          setState(() {
            roleId = e.roleId;
          });
        }));
    print(_authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NavigationBloc>(
        create: (context) => NavigationBloc(),
        child: Stack(
          children: <Widget>[
            BlocBuilder<NavigationBloc, NavigationStates>(
              builder: (
                context,
                navigationState,
              ) {
                return navigationState as Widget;
              },
            ),
            roleId == 6 || roleId == 1
                ? SideBar(
                    authBloc: _authBloc,
                  )
                : SideBarVer(
                    authBloc: _authBloc,
                  ),
          ],
        ),
      ),
    );
  }
}
