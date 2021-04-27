import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:ta_sispem/repository/auth_repository.dart';

import '../blocs/navigation_bloc.dart';
import 'sidebar.dart';
import 'sidebar_ver.dart';

class SideBarLayout extends StatelessWidget {
  final AuthBloc authBloc;
  final AuthRepository data;

  const SideBarLayout({Key key, this.authBloc, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NavigationBloc>(
        create: (context) => NavigationBloc(),
        child: Stack(
          children: <Widget>[
            BlocBuilder<NavigationBloc, NavigationStates>(
              builder: (context, navigationState) {
                return navigationState as Widget;
              },
            ),
            SideBar(
              authBloc: authBloc,
            ),
            // SideBarVer(),
          ],
        ),
      ),
    );
  }
}
