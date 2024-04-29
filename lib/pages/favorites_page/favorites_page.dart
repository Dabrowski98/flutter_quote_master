import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quote_master/core/widgets/searchResults.dart';
import 'package:flutter_quote_master/core/widgets/tile.dart';
import 'package:flutter_quote_master/pages/home_page/main_quote_widget.dart';
import 'package:flutter_quote_master/quotes/models/quote.dart';
import 'package:flutter_quote_master/pages/home_page/categories_widget.dart';
import 'package:flutter_quote_master/pages/home_page/rate_widget.dart';
import 'package:flutter_quote_master/core/widgets/search_bar_widget.dart';
import 'package:hive/hive.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({
    super.key,
    required this.addToFavorites,
  });

  final Function addToFavorites;
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Quote> _favoriteQuotesList = [];
  late Box _quotesBox;
  late int _pickedQuoteIndex;
  late DisplayMode _displayMode;
  bool _shouldShowSearchResults = false;
  bool isSearchBarNotEmpty = false;
  List<Quote> searchResultsList = [];

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
  void initState() {
    super.initState();
    _quotesBox = Hive.box<Quote>("quotesBox");
    _favoriteQuotesList = _quotesBox.values
        .where((element) => element.isFavorite == true)
        .toList()
        .cast();
    searchResultsList = _favoriteQuotesList;
    _pickedQuoteIndex = -1;
    _displayMode = DisplayMode.searchResults;
  }

  @override
  void didUpdateWidget(FavoritesPage oldWidget) {
    // setState(() {
    //   _shouldShowSearchResults = true;
    //   _displayMode = DisplayMode.searchResults;
    // });
  }

  onTapSearchResult(
    int newPickedQuoteIndex,
    bool newShouldShowSearchResults,
    DisplayMode newDisplayMode,
  ) {
    setState(() {
      _pickedQuoteIndex = newPickedQuoteIndex;
      _shouldShowSearchResults = newShouldShowSearchResults;
      _displayMode = newDisplayMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBarWidget(
            onSearchStateChanged: updateSearchState,
            baseQuotesList: _favoriteQuotesList,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Your \nfavorite \nQuotes!",
              maxLines: 3,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: SearchResults(
              searchResultsList,
              onTapSearchResult: (
                pickedQuoteIndex,
                shouldShowSearchResults,
                displayMode,
              ) {
                onTapSearchResult(
                  pickedQuoteIndex,
                  shouldShowSearchResults,
                  displayMode,
                );
              },
            ),
          ),
          //   Row(
          //     children: [
          //       RateWidget(size: size),
          //       CategoriesWidget(size: size),
          //     ],
          //   ),
        ],
      ),
    );
  }
}
