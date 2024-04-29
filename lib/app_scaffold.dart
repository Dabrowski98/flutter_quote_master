import 'package:flutter/material.dart';
import 'package:flutter_quote_master/pages/favorites_page/favorites_page.dart';
import 'package:flutter_quote_master/pages/home_page/home_page.dart';
import 'package:flutter_quote_master/pages/notifications_page/notifications_page.dart';
import 'package:flutter_quote_master/pages/settings_page/settings_page.dart';
import 'package:flutter_quote_master/quotes/models/quote.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold(void Function(Quote quote) this.addToFavorites,
      {super.key});

  final Function addToFavorites;
  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _currentPageIndex = 1;
  final _pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    const navigationBarItems = [
      BottomNavigationBarItem(
          label: "Favorites",
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite)),
      BottomNavigationBarItem(
          label: "Home Page",
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home)),
      BottomNavigationBarItem(
          label: "Notifications",
          icon: Icon(Icons.notifications_none),
          activeIcon: Icon(Icons.notifications))
    ];
    
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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          FavoritesPage(addToFavorites: widget.addToFavorites),
          HomePage(addToFavorites: widget.addToFavorites),
          const NotificationsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.cyan[900],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) {
          animateToNewPage(index);
        },
        currentIndex: _currentPageIndex,
        items: navigationBarItems,
      ),
    );
  }

  void animateToNewPage(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }
}
