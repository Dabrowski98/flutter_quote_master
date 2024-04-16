import 'package:flutter/material.dart';
import 'package:flutter_quote_master/data/quote_database.dart';
import 'package:flutter_quote_master/models/quote.dart';
import 'package:flutter_quote_master/pages/favorites_page.dart';
import 'package:flutter_quote_master/pages/home_page/home_page.dart';
import 'package:flutter_quote_master/pages/search_page.dart';
import 'package:flutter_quote_master/pages/settings_page.dart';
import 'package:flutter_quote_master/utils/internet_connection.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(QuoteAdapter());
  Box box = await Hive.openBox<Quote>('mybox');
  if (await InternetCheck().connected) await QuoteDatabase().initData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffe6e6e6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffe6e6e6),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xffe6e6e6),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color(0xffe6e6e6),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SettingsPage();
                }));
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ))
        ],
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              color: Color.fromARGB(255, 73, 73, 73),
              fontSize: 32,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "Quote",
              ),
              TextSpan(
                text: "Master",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        surfaceTintColor: Colors.white,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: "Favorites"),
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.search),
              selectedIcon: Icon(Icons.search),
              label: "Search"),
        ],
      ),
      body: <Widget>[
        const FavoritesPage(),
        const HomePage(),
        const SearchPage(),
      ][currentPageIndex],
    );
  }
}
