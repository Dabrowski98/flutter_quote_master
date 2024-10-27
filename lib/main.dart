import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quote_master/api/firebase_api.dart';
import 'package:flutter_quote_master/firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_quote_master/quotes/data/quote_database.dart';
import 'package:flutter_quote_master/quotes/models/quote.dart';
import 'package:flutter_quote_master/core/utils/internet_connection.dart';
import 'package:flutter_quote_master/app_scaffold.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(QuoteAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  // ignore: unused_local_variable
  Box _quotesBox = await Hive.openBox<Quote>('quotesBox');
  if (await InternetCheck().connected) await QuoteDatabase().initData();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeMode _themeMode = ThemeMode.light;
  late Box _quotesBox;

  void addToFavorites(Quote quote) {
    quote.isFavorite = !quote.isFavorite;
    _quotesBox.put(quote.key, quote);
  }

  @override
  void initState() {
    super.initState();
    _quotesBox = Hive.box<Quote>("quotesBox");
  }

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
      home: AppScaffold(addToFavorites),
    );
  }
}
