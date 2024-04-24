import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:share/share.dart';

import 'package:flutter_quote_master/core/widgets/tile.dart';
import 'package:flutter_quote_master/quotes/data/quote_database.dart';
import 'package:flutter_quote_master/quotes/models/quote.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MainQuoteWidget extends StatefulWidget {
  const MainQuoteWidget({
    super.key,
    required this.isSearching,
    this.searchResults,
  });

  final bool isSearching;
  final List<Quote>? searchResults;

  @override
  State<MainQuoteWidget> createState() => _MainQuoteWidgetState();
}

class _MainQuoteWidgetState extends State<MainQuoteWidget> {
  late Quote _quoteOfTheDay;
  late Box<Quote> _box;
  late List<Quote> _quotes;
  late CarouselController _buttonCarouselController;
  late DisplayMode _displayMode;
  late Quote _pickedQuote;
  late int _pickedQuoteIndex;
  late bool _isFirstOfSearchedQuotes = false;
  final Map<int, bool> _quotePrintingFinishedMap = {};
  late UniqueKey _key;

  @override
  void initState() {
    _displayMode = DisplayMode.quoteOfTheDay;
    _quoteOfTheDay = QuoteDatabase().getDailyQuote();
    _box = Hive.box<Quote>("mybox");
    _quotes = _box.values.toList();
    _quotes.shuffle();
    _buttonCarouselController = CarouselController();
    _key = UniqueKey();
    super.initState();
  }

  @override
  void didUpdateWidget(MainQuoteWidget oldWidget) {
    if (widget.isSearching) {
      setState(() {
        _displayMode = DisplayMode.searchResults;
      });
    } else {
      setState(() {
        _quotePrintingFinishedMap.clear();
        _displayMode = DisplayMode.quoteOfTheDay;
      });
    }
    if (widget.isSearching != oldWidget.isSearching) {
      setState(() {
        _key = UniqueKey();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Expanded(
        key: _key,
        child: switch (_displayMode) {
      DisplayMode.quoteOfTheDay => CarouselSlider.builder(
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
              Color color = Color.alphaBlend(
                Color.fromARGB(
                  255,
                  index.hashCode % 128,
                  index.hashCode % 64 * 2,
                  index.hashCode % 32 * 4,
                ).withOpacity(0.5),
                Colors.white,
              );

              return Tile(
                color: color,
                child: showQuote(
                  _quotes[index],
                  QuoteType.regularQuote,
                  setIndexTo0: setIndexTo0,
                ),
              );
            }
          },
        ),
      DisplayMode.searchedQuotes => CarouselSlider.builder(
          carouselController: _buttonCarouselController,
          itemCount: widget.searchResults!.length,
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
              if (_buttonCarouselController.ready) {
                _buttonCarouselController.animateToPage(0);
              }
            }

            Color color = Color.alphaBlend(
              Color.fromARGB(
                255,
                index.hashCode % 128,
                index.hashCode % 64 * 2,
                index.hashCode % 32 * 4,
              ).withOpacity(0.5),
              Colors.white,
            );

            return Tile(
              color: color,
              child: showQuote(
                widget.searchResults![
                    index + _pickedQuoteIndex % widget.searchResults!.length],
                QuoteType.regularQuote,
                setIndexTo0: setIndexTo0,
              ),
            );
          },
        ),
      DisplayMode.searchResults => showSearchResults()
    });
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
                          Padding(
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
                                  "\"${quote.content}\"",
                                  textAlign: TextAlign.left,
                                  textStyle: const TextStyle(
                                      height: 1.6,
                                      color: Colors.white,
                                      fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                          if (_quotePrintingFinishedMap[quote.key] == true)
                            SizedBox(
                              width: 9999,
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
                      addToFavorite(quote);
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

  void addToFavorite(Quote quote) {
    return setState(() {
      quote.isFavorite = !quote.isFavorite;
      _box.put(quote.key, quote);
    });
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

  showSearchResults() {
    if (widget.isSearching) {
      return widget.searchResults!.isNotEmpty
          ? Tile(
              color: const Color.fromARGB(255, 73, 73, 73),
              child: ListView.builder(
                  itemCount: widget.searchResults!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _pickedQuote = _quotes.firstWhere((element) =>
                              element.id == widget.searchResults?[index].id);
                          _pickedQuoteIndex = index;
                          _displayMode = DisplayMode.searchedQuotes;
                        });
                      },
                      child: Tile(
                        color: const Color.fromARGB(255, 85, 85, 85),
                        child: Column(
                          children: [
                            Text(
                              widget.searchResults![index].content,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              widget.searchResults![index].author,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          : Tile(
              color: const Color.fromARGB(255, 73, 73, 73),
              child: Center(
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  pause: Duration.zero,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "No matching results found.",
                      textStyle: const TextStyle(
                          height: 1.6, color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            );
    } else {
      return const SizedBox.shrink();
    }
  }
}

enum QuoteType {
  quoteOfTheDay,
  regularQuote;
}

enum DisplayMode { quoteOfTheDay, searchedQuotes, searchResults }
