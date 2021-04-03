import 'package:flutter/material.dart';
import 'sidebar/sidebar_layout.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SideBarLayout(),
    );
  }
}
