import 'package:flutter/material.dart';
import 'package:bar_code/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color.fromARGB(255, 27, 68, 206),
      debugShowCheckedModeBanner: false,
      title: 'Leitor',
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), brightness: Brightness.light),
      darkTheme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark)),
      home: const HomePage(title: 'Leitor de códigos'),
    );
  }
}
