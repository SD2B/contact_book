import 'package:contact_book/core/theme.dart';
import 'package:contact_book/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Contact Book',
      theme: MyTheme.getThemeData(ThemeMode.light),
      themeMode: ThemeMode.light,
      darkTheme: MyTheme.getThemeData(ThemeMode.dark),
      routerConfig: myRoute,
    );
  }
}
