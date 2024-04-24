import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quote_master/quotes/models/quote.dart';
import 'package:flutter_quote_master/pages/home_page/categories_widget.dart';
import 'package:flutter_quote_master/pages/home_page/main_quote_widget.dart';
import 'package:flutter_quote_master/pages/home_page/rate_widget.dart';
import 'package:flutter_quote_master/pages/home_page/search_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  List<Quote> searchResults = [];

  void updateSearchState(bool value, List<Quote> results) {
    setState(
      () {
        isSearching = value;
        if (value) {
          searchResults = results;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          SearchBarWidget(onSearchStateChanged: updateSearchState),
          MainQuoteWidget(
            isSearching: isSearching,
            searchResults: searchResults,
          ),
          Row(
            children: [
              RateWidget(size: size),
              CategoriesWidget(size: size),
            ],
          ),
        ],
      ),
    );
  }
}
