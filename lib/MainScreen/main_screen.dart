import 'package:flutter/material.dart';
import 'package:binance_task/MainScreen/main_content.dart';

class MainScreen extends StatelessWidget {
  static String routeName = "/mainScreen";

  const MainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MainContent()
      );
  }
}