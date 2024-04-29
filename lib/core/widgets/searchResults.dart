import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_quote_master/core/widgets/tile.dart';
import 'package:flutter_quote_master/pages/home_page/main_quote_widget.dart';
import 'package:flutter_quote_master/quotes/models/quote.dart';

class SearchResults extends StatefulWidget {
  late List<Quote> searchResults;
  final Function(
    int pickedQuoteIndex,
    bool shouldShowSearchResults,
    DisplayMode displayMode,
  ) onTapSearchResult;
  SearchResults(
    this.searchResults, {
    super.key,
    required this.onTapSearchResult,
  });

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final ScrollController _scrollController = ScrollController();
  double scrollOffset = 0;
  double maxScrollOffset = 9999;
  bool _showBottomBlender = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset <= 20 ||
            _scrollController.offset > maxScrollOffset - 20) {
          scrollOffset = _scrollController.offset;
          _showBottomBlender = scrollOffset <= maxScrollOffset - 15;
        }
      });
      print(scrollOffset);
      if (maxScrollOffset == 9999) {
        maxScrollOffset = _scrollController.position.maxScrollExtent;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchResults.isNotEmpty
        ? Tile(
            borderColor: Colors.transparent,
            color: const Color(0xffe6e6e6),
            margin: 0,
            padding: 0,
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.searchResults.length,
                  itemBuilder: (context, index) {
                    String tagsString =
                        widget.searchResults[index].tags.toString();
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.onTapSearchResult(
                              index, false, DisplayMode.selectedQuote);
                        });
                      },
                      child: Tile(
                        margin: 2.0,
                        padding: 0,
                        color: const Color.fromARGB(245, 85, 85, 85),
                        child: SizedBox(
                          height: 80,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 12.0, 0.0, 0.0),
                                child: SizedBox(
                                  width: 9999,
                                  child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 9999,
                                          child: Text(
                                            maxLines: 1,
                                            widget.searchResults[index].content
                                                .padRight(40, " ")
                                                .substring(0, 40),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                width: 175,
                                height: 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerRight,
                                      end: Alignment.centerLeft,
                                      stops: [0.3, 1.0],
                                      colors: [
                                        Color.fromARGB(255, 90, 90, 90),
                                        Color.fromARGB(255, 85, 85, 85)
                                            .withOpacity(0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 8,
                                bottom: 8,
                                child: Text(
                                  // textAlign: TextAlign.end,
                                  widget.searchResults[index].author,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Positioned(
                                left: 8,
                                bottom: 8,
                                child: Text(
                                  // textAlign: TextAlign.end,
                                  tagsString.length > 2
                                      ? "#${tagsString.substring(1, tagsString.length - 1).replaceAll(", ", " #")}"
                                      : "",
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(142, 255, 255, 255)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                    top: 0,
                    width: 500,
                    height: 10,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: scrollOffset >= 15 ? 1 : 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 1.0],
                            colors: [
                              const Color(0xffe6e6e6),
                              Color.fromARGB(255, 90, 90, 90).withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    )),
                Positioned(
                  bottom: 0,
                  width: 500,
                  height: 10,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _showBottomBlender ? 1 : 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.0, 1.0],
                          colors: [
                            const Color(0xffe6e6e6),
                            Color.fromARGB(255, 90, 90, 90).withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
  }
}
