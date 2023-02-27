import 'package:binance_task/MainScreen/main_screen.dart';
import 'package:flutter/widgets.dart';

// We use named routes.
// All our routes will be available here.
final Map<String, WidgetBuilder> routes = {
  MainScreen.routeName: (context) => const MainScreen()
};