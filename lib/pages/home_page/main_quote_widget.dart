import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quote_master/core/widgets/search_results_widget.dart';
import 'package:hive/hive.dart';
import 'package:share/share.dart';

import 'package:flutter_quote_master/core/widgets/tile.dart';
import 'package:flutter_quote_master/quotes/data/quote_database.dart';
import 'package:flutter_quote_master/quotes/models/quote.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MainQuoteWidget extends StatefulWidget {
  const MainQuoteWidget({
    super.key,
    required this.isSearchBarNotEmpty,
    required this.searchResultsList,
    required this.addToFavorites,
  });

  final bool isSearchBarNotEmpty;
  final List<Quote> searchResultsList;
  final Function addToFavorites;

  @override
  State<MainQuoteWidget> createState() => _MainQuoteWidgetState();
}

class _MainQuoteWidgetState extends State<MainQuoteWidget> {
  late Box<Quote> _quotesBox;

  late List<Quote> _quotes;
  late Quote _quoteOfTheDay;
  late int _pickedQuoteIndex;

  late CarouselController _buttonCarouselController;
  late CarouselController _buttonCarouselController2;

  late DisplayMode _displayMode;
  late bool _isFirstOfSearchedQuotes = false;
  final Map<int, bool> _quotePrintingFinishedMap = {};
  bool _shouldShowSearchResults = false;

  @override
  void initState() {
    super.initState();
    _displayMode = DisplayMode.quoteOfTheDay;
    _quoteOfTheDay = QuoteDatabase().getDailyQuote();
    _quotesBox = Hive.box<Quote>("quotesBox");
    _quotes = _quotesBox.values.toList();
    _quotes.shuffle();
    _buttonCarouselController = CarouselController();
    _buttonCarouselController2 = CarouselController();
    _pickedQuoteIndex = -1;
  }

  @override
  void didUpdateWidget(MainQuoteWidget oldWidget) {
    if (!widget.isSearchBarNotEmpty &&
        widget.isSearchBarNotEmpty != oldWidget.isSearchBarNotEmpty) {
      setState(() {
        _displayMode = DisplayMode.quoteOfTheDay;
        _isFirstOfSearchedQuotes = false;
      });
    } else {
      setState(() {
        _shouldShowSearchResults = true;
        _pastelColors.shuffle();
        _displayMode = DisplayMode.searchResults;
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  onTapSearchResult(int newPickedQuoteIndex, bool newShouldShowSearchResults,
      DisplayMode newDisplayMode) {
    setState(() {
      _pickedQuoteIndex = newPickedQuoteIndex;
      _shouldShowSearchResults = newShouldShowSearchResults;
      _displayMode = newDisplayMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Visibility(
            visible: !widget.isSearchBarNotEmpty,
            maintainState: true,
            child: CarouselSlider.builder(
              carouselController: _buttonCarouselController,
              itemCount: _quotes.length + 1,
              options: CarouselOptions(
                  enlargeCenterPage: true,
                  height: 9999,
                  enableInfiniteScroll: false,
                  viewportFraction: 1),
              itemBuilder: (context, index, realIndex) {
                setIndexTo0() {
                  if (_buttonCarouselController.ready) {
                    _buttonCarouselController.animateToPage(0);
                  }
                }

                if (index == 0) {
                  return Tile(
                    color: const Color.fromARGB(255, 73, 73, 73),
                    child: showQuote(_quoteOfTheDay, QuoteType.quoteOfTheDay),
                  );
                } else {
                  return Tile(
                    color: Color.alphaBlend(
                      _pastelColors[index % _pastelColors.length]
                          .withOpacity(0.7),
                      Colors.black,
                    ),
                    child: showQuote(
                      _quotes[index],
                      QuoteType.regularQuote,
                      setIndexTo0: setIndexTo0,
                    ),
                  );
                }
              },
            ),
          ),
          if (_shouldShowSearchResults)
            widget.isSearchBarNotEmpty
                ? SearchResults(widget.searchResultsList, onTapSearchResult: (
                    pickedQuoteIndex,
                    shouldShowSearchResults,
                    displayMode,
                  ) {
                    onTapSearchResult(
                      pickedQuoteIndex,
                      shouldShowSearchResults,
                      displayMode,
                    );
                  })
                : SizedBox.shrink(),
          if (widget.isSearchBarNotEmpty &&
              _displayMode == DisplayMode.selectedQuote)
            CarouselSlider.builder(
              carouselController: _buttonCarouselController2,
              itemCount: widget.searchResultsList.length,
              options: CarouselOptions(
                  enlargeCenterPage: true,
                  height: 9999,
                  enableInfiniteScroll: false,
                  viewportFraction: 1),
              itemBuilder: (context, index, realIndex) {
                if (index == 0) {
                  _isFirstOfSearchedQuotes = true;
                } else {
                  _isFirstOfSearchedQuotes = false;
                }

                setIndexTo0() {
                  if (_buttonCarouselController2.ready) {
                    _buttonCarouselController2.animateToPage(0);
                  }
                }

                return Tile(
                  color: Color.alphaBlend(
                    _pastelColors[
                            index % (_pastelColors.length + _pickedQuoteIndex)]
                        .withOpacity(0.7),
                    Colors.black,
                  ),
                  child: showQuote(
                    widget.searchResultsList[index +
                        _pickedQuoteIndex % widget.searchResultsList.length],
                    QuoteType.regularQuote,
                    setIndexTo0: setIndexTo0,
                  ),
                );
              },
            )
        ],
      ),
    );
  }

  showQuote(Quote? quote, QuoteType quoteType, {void Function()? setIndexTo0}) {
    if (quote == null) {
      return Quote(
          content: "No quote found",
          author: "author",
          authorSlug: "authorSlug",
          tags: ["tags"],
          length: 0,
          id: "00000");
    }

    if (_quotePrintingFinishedMap[quote.key] == null) {
      _quotePrintingFinishedMap[quote.key] = false;
    }

    return Stack(
      children: [
        quoteType == QuoteType.quoteOfTheDay
            ? const Placeholder(
                color: Colors.transparent,
              )
            : Positioned(
                top: 10,
                left: -6,
                child: OutlinedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide.none),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      backgroundColor: MaterialStateProperty.all(null),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                    ),
                    onPressed: _isFirstOfSearchedQuotes
                        ? () {
                            setState(() {
                              _shouldShowSearchResults = true;
                              _displayMode = DisplayMode.searchResults;
                            });
                          }
                        : setIndexTo0,
                    child: _isFirstOfSearchedQuotes
                        ? const Icon(
                            Icons.arrow_upward,
                            color: Color.fromARGB(255, 73, 73, 73),
                          )
                        : const Icon(
                            Icons.arrow_back,
                            color: Color.fromARGB(255, 73, 73, 73),
                          )),
              ),
        Positioned(
          top: 10,
          left: quoteType == QuoteType.quoteOfTheDay ? 10 : null,
          right: quoteType != QuoteType.quoteOfTheDay ? 10 : null,
          child: Text(
            quoteType == QuoteType.quoteOfTheDay
                ? "Quote of the day!"
                : quote.tags.isEmpty
                    ? "Just a quote"
                    : quote.tags[0],
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Center(
          child: LayoutBuilder(
            builder: (context, BoxConstraints viewportConstraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: -150 + viewportConstraints.maxHeight < 0
                        ? 0
                        : -150 + viewportConstraints.maxHeight),
                child: SizedBox(
                  height: 0,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: AnimatedTextKit(
                                isRepeatingAnimation: false,
                                displayFullTextOnTap: true,
                                onTap: () => setState(
                                  () {
                                    _quotePrintingFinishedMap[quote.key] = true;
                                  },
                                ),
                                onFinished: () => setState(
                                  () {
                                    _quotePrintingFinishedMap[quote.key] = true;
                                  },
                                ),
                                pause: Duration.zero,
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    "    \"${quote.content}\"",
                                    textAlign: TextAlign.left,
                                    textStyle: const TextStyle(
                                        height: 1.6,
                                        color: Colors.white,
                                        fontSize: 24),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_quotePrintingFinishedMap[quote.key] == true)
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                child: AnimatedTextKit(
                                  isRepeatingAnimation: false,
                                  animatedTexts: [
                                    TypewriterAnimatedText("~ ${quote.author}",
                                        textAlign: TextAlign.end,
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 16)),
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 0,
          child: Row(
            children: [
              SizedBox(
                height: 55,
                width: 55,
                child: OutlinedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide.none),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      backgroundColor: MaterialStateProperty.all(null),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.addToFavorites(quote);
                      });
                    },
                    child: Icon(
                      quote.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 55,
                width: 55,
                child: OutlinedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide.none),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    backgroundColor: MaterialStateProperty.all(null),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                  ),
                  onPressed: () {
                    shareQuote(quote);
                  },
                  child: Icon(
                    Icons.share,
                    color: quoteType == QuoteType.quoteOfTheDay
                        ? Colors.grey
                        : const Color.fromARGB(255, 73, 73, 73),
                  ),
                ),
              ),
            ],
          ),
        )
            .animate(
                target: _quotePrintingFinishedMap[quote.key] == true ? 1 : 0)
            .moveY(begin: 50)
            .fadeIn()
      ],
    );
  }

  void shareQuote(Quote quote) {
    Share.share("Check out this inspiring quote from QuoteMaster App!\n\n"
        "\"${quote.content}\" \n\n"
        "~ ${quote.author}\n\n"
        "Shared through QuoteMaster App!");
  }

//   AnimatedTextKit showTextProgressIndicator() {
//     return AnimatedTextKit(
//       repeatForever: true,
//       pause: Duration.zero,
//       animatedTexts: [
//         TypewriterAnimatedText(" ",
//             speed: Durations.long1,
//             textStyle: const TextStyle(
//               color: Colors.white,
//             ))
//       ],
//     );
//   }
}

enum QuoteType {
  quoteOfTheDay,
  regularQuote;
}

enum DisplayMode { quoteOfTheDay, selectedQuote, searchResults }

List<Color> _pastelColors = [
  Color.fromARGB(255, 215, 150, 150),
  Color.fromARGB(255, 215, 181, 150),
  Color.fromARGB(255, 204, 215, 150),
  Color.fromARGB(255, 150, 215, 152),
  Color.fromARGB(255, 150, 215, 203),
  Color.fromARGB(255, 150, 215, 215),
  Color.fromARGB(255, 150, 174, 215),
  Color.fromARGB(255, 163, 150, 215),
  Color.fromARGB(255, 180, 150, 215),
  Color.fromARGB(255, 215, 150, 201),
  Color.fromARGB(255, 227, 166, 188),
];
