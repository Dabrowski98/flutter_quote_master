import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_quote_master/quotes/data/quote_database.dart';
import 'package:flutter_quote_master/quotes/models/quote.dart';
import 'package:flutter_quote_master/core/utils/internet_connection.dart';
import 'package:flutter_quote_master/app_scaffold.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(QuoteAdapter());
  // ignore: unused_local_variable
  Box box = await Hive.openBox<Quote>('mybox');
  if (await InternetCheck().connected) await QuoteDatabase().initData();
  runApp(const MyApp());
}

// var myTheme = ThemeData(
//   colorScheme: ColorScheme(
//       brightness: brightness,
//       primary: primary,
//       onPrimary: onPrimary,
//       secondary: secondary,
//       onSecondary: onSecondary,
//       error: error,
//       onError: onError,
//       background: background,
//       onBackground: onBackground,
//       surface: surface,
//       onSurface: onSurface),
// );

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffe6e6e6),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xffe6e6e6), surfaceTintColor: Colors.white),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xffe6e6e6),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color(0xffe6e6e6),
        ),
      ),
      title: "QuoteMaster",
      themeMode: _themeMode,
      darkTheme: ThemeData.dark(),
      home: const AppScaffold(),
    );
  }
}
