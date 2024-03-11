import 'package:apppagoplux/src/pages/login.dart';
import 'package:apppagoplux/src/pages/pay.dart';
import 'package:flutter/material.dart';
import 'package:apppagoplux/src/component/paybox.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App PagoPlux',
      home: appPagoPlux(),
    );
  }
}