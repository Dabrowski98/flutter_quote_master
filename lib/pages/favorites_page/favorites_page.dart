import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quote_master/core/widgets/search_results_widget.dart';
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
  int _textAnimationsFinished = 0;
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

    const emptyPageTextStyle = TextStyle(
      height: 1.6,
      color: Color.fromARGB(255, 72, 72, 72),
      fontSize: 24,
    );

    const emptyPageTextStyleBig = TextStyle(
      height: 3,
      color: Color.fromARGB(255, 72, 72, 72),
      fontSize: 32,
      fontWeight: FontWeight.w500,
    );

    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBarWidget(
            onSearchStateChanged: updateSearchState,
            baseQuotesList: _favoriteQuotesList,
            titleOfThePage: "Your Favorite Quotes!",
          ),
          Expanded(
            child: searchResultsList.isNotEmpty
                ? SearchResults(
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
                  )
                : Tile(
                    borderColor: Colors.transparent,
                    color: Color.fromARGB(255, 207, 207, 207),
                    padding: 8,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Column(children: [
                        SizedBox(
                          height: constraints.maxHeight / 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              AnimatedTextKit(
                                isRepeatingAnimation: false,
                                pause: Duration(milliseconds: 200),
                                onFinished: () {
                                  setState(() {
                                    _textAnimationsFinished++;
                                  });
                                },
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    "Empty list?",
                                    speed: Durations.short1,
                                    textStyle: emptyPageTextStyleBig,
                                  ),
                                ],
                              ),
                              if (_textAnimationsFinished > 0)
                                AnimatedTextKit(
                                  isRepeatingAnimation: false,
                                  pause: Duration(milliseconds: 200),
                                  onFinished: () {
                                    setState(() {
                                      _textAnimationsFinished++;
                                    });
                                  },
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                      "No worries!",
                                      speed: Durations.short1,
                                      textStyle: emptyPageTextStyleBig,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        if (_textAnimationsFinished > 1)
                          AnimatedTextKit(
                            isRepeatingAnimation: false,
                            pause: Duration(milliseconds: 200),
                            onFinished: () {
                              setState(() {
                                _textAnimationsFinished++;
                              });
                            },
                            animatedTexts: [
                              TypewriterAnimatedText(
                                "Your favorite quotes are just a click away. Explore, discover, and fill this space with the words that inspire you.",
                                textStyle: emptyPageTextStyle,
                              ),
                            ],
                          ),
                        if (_textAnimationsFinished > 2)
                          Align(
                            alignment: Alignment.centerRight,
                            child: AnimatedTextKit(
                              isRepeatingAnimation: false,
                              pause: Duration(milliseconds: 200),
                              onFinished: () {
                                _textAnimationsFinished++;
                              },
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  "Start browsing now!",
                                  textStyle: emptyPageTextStyleBig,
                                ),
                              ],
                            ),
                          ),
                      ]);
                    }),
                  ),
          )
        ],
      ),
    );
  }
}
