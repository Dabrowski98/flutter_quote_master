import 'package:flutter/material.dart';
import 'package:flutter_quote_master/pages/favorites_page/favorites_page.dart';
import 'package:flutter_quote_master/pages/home_page/home_page.dart';
import 'package:flutter_quote_master/pages/search_page/search_page.dart';
import 'package:flutter_quote_master/pages/settings_page/settings_page.dart';


class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
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
            text: "Quote",
            style: TextStyle(
              color: Color.fromARGB(255, 73, 73, 73),
              fontSize: 32,
            ),
            children: <TextSpan>[
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
