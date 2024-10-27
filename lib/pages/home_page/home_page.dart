import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quote_master/quotes/models/quote.dart';
import 'package:flutter_quote_master/pages/home_page/categories_widget.dart';
import 'package:flutter_quote_master/pages/home_page/main_quote_widget.dart';
import 'package:flutter_quote_master/pages/home_page/rate_widget.dart';
import 'package:flutter_quote_master/core/widgets/search_bar_widget.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.addToFavorites});

  final Function addToFavorites;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearchBarNotEmpty = false;
  List<Quote> searchResultsList = [];
  late Box<Quote> _quotesBox;
  late List<Quote> _quotes;

  @override
  void initState() {
    _quotesBox = Hive.box<Quote>("quotesBox");
    _quotes = _quotesBox.values.toList();
    super.initState();
  }

  void updateSearchState(bool value, List<Quote> results) {
    setState(
      () {
        isSearchBarNotEmpty = value;
        if (value) {
          searchResultsList = results;
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
          SearchBarWidget(
            onSearchStateChanged: updateSearchState,
            baseQuotesList: _quotes,
            titleOfThePage: "Home Page",
          ),
          MainQuoteWidget(
            isSearchBarNotEmpty: isSearchBarNotEmpty,
            searchResultsList: searchResultsList,
            addToFavorites: widget.addToFavorites,
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
