import 'package:flutter/material.dart';

abstract class DebugServicesDashboardMenuBuilder {
  Iterable<Widget> createMenu(BuildContext context);
}

class DebugServicesDashboardBuilder {
  final _menuBuilders = <DebugServicesDashboardMenuBuilder>[];

  void registerMenuBuilder(DebugServicesDashboardMenuBuilder builder) {
    _menuBuilders.add(builder);
  }

  Iterable<Widget> createMenuSection(BuildContext context) {
    return _menuBuilders.expand((it) => it.createMenu(context));
  }
}
