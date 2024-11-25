import 'package:flutter/material.dart';
import 'package:joven/routes.dart';

class JovenApp extends StatelessWidget {
  const JovenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joven',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
        ),
        useMaterial3: true,
      ),
      initialRoute: Routes.initial,
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
