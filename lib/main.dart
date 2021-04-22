import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ta_sispem/blocs/auth_bloc.dart';
import 'package:ta_sispem/event/auth_event.dart';
import 'package:ta_sispem/home.dart';
import 'package:ta_sispem/login.dart';
import 'package:ta_sispem/repository/auth_repository.dart';
import 'package:ta_sispem/state/auth_state.dart';

void main() {
  final AuthRepository authRepository = AuthRepository();
  runApp(BlocProvider(
    create: (context) {
      return AuthBloc(authRepository: authRepository);
    },
    child: App(
      authRepository: authRepository,
      authBloc: AuthBloc(authRepository: authRepository),
    ),
  ));
}

class App extends StatelessWidget {
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  const App({Key key, this.authRepository, this.authBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Nunito"),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: BlocBuilder(
          cubit: authBloc,
          builder: (context, AuthState state) {
            print(state);
            if (state is AuthInit) {
              authBloc.add(AuthCheck());
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state is AuthFailed ||
                state is LoginFailed ||
                state is LogoutSuccess)
              return Container(
                  child: LoginPage(
                authBloc: authBloc,
              ));
            if (state is AuthHasToken || state is AuthData)
              return Container(
                  child: Home(
                authBloc: authBloc,
              ));
            if (state is AuthLoading)
              return Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            return Container();
          },
        ),
      ),
    );
  }
}
