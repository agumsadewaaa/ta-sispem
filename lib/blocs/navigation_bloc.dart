import 'package:bloc/bloc.dart';
import 'package:ta_sispem/pages/kritiksaranpage.dart';
import 'package:ta_sispem/pages/listpeminjamanpage.dart';
import 'package:ta_sispem/pages/panduanpage.dart';

import '../pages/ruanganpage.dart';
import '../pages/peminjamansayapage.dart';
import '../pages/homepage.dart';
import '../pages/panduanpage.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  RuanganClickedEvent,
  PeminjamanClickedEvent,
  PanduanClickedEvent,
  ListPinjamClickedEvent,
  KritikSaranClickedEvent
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc() : super(HomePage());

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield HomePage();
        break;
      case NavigationEvents.RuanganClickedEvent:
        yield RuanganPage();
        break;
      case NavigationEvents.PeminjamanClickedEvent:
        yield PeminjamanPage();
        break;
      case NavigationEvents.PanduanClickedEvent:
        yield PanduanPage();
        break;
      case NavigationEvents.ListPinjamClickedEvent:
        yield ListPeminjamanPage();
        break;
      case NavigationEvents.KritikSaranClickedEvent:
        yield KritikSaranPage();
        break;
    }
  }

  void dispatch(NavigationEvents homePageClickedEvent) {}
}
