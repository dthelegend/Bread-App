import 'package:flutter/cupertino.dart';

abstract class BreadMainViewTab implements Widget {
  Widget? get floatingActionButton;
  Icon get icon;
  String get label;
}
