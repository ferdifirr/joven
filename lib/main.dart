import 'package:flutter/material.dart';
import 'package:joven/app.dart';
import 'package:joven/service/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const JovenApp());
}
