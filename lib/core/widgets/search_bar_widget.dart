import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quote_master/quotes/models/quote.dart';
import 'package:hive/hive.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(bool, List<Quote>) onSearchStateChanged;
  final List<Quote> baseQuotesList;
  final String titleOfThePage;

  const SearchBarWidget(
      {super.key,
      required this.baseQuotesList,
      required this.onSearchStateChanged,
      this.titleOfThePage = ""});
  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  late Box<Quote> _quotesBox;
  bool isSearchBarNotEmpty = false;
  List<Quote> _filteredQuotesList = [];
  late TextEditingController _searchController;
  late AnimationController _animationController;
  late bool toggle;

  @override
  void initState() {
    _quotesBox = Hive.box<Quote>("quotesBox");
    _filteredQuotesList = widget.baseQuotesList;
    _searchController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    toggle = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              left: 10,
              child: Container(
                margin: const EdgeInsets.all(4.0),
                height: 48,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                      style: const TextStyle(
                        color: Color.fromARGB(255, 48, 48, 48),
                        fontSize: 24,
                      ),
                      children: getStyledTitle(widget.titleOfThePage)),
                ),
              ),
            ),
            Container(
              height: 48,
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.all(4.0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height: 48,
                width: toggle ? MediaQuery.of(context).size.width : 48,
                curve: Curves.ease,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: const [
                    BoxShadow(
                      color: const Color.fromARGB(255, 73, 73, 73),
                      spreadRadius: -2.0,
                      offset: Offset(0, 5),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 400),
                      left: toggle ? 50 : -50,
                      curve: Curves.ease,
                      child: AnimatedOpacity(
                        opacity: toggle ? 1 : 0,
                        duration: Duration(milliseconds: 150),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: _searchController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              hintText: "Search for Quotes!",
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          isSearchBarNotEmpty = false;
                                          widget.onSearchStateChanged(
                                              isSearchBarNotEmpty,
                                              _filteredQuotesList);
                                        });
                                      },
                                    )
                                  : const Icon(
                                      Icons.hourglass_bottom,
                                      color: Colors.transparent,
                                    ),
                            ),
                            onChanged: (input) {
                              searchData(input);
                              setState(() {
                                isSearchBarNotEmpty =
                                    (_searchController.text.length > 1)
                                        ? true
                                        : false;
                              });
                              widget.onSearchStateChanged(
                                  isSearchBarNotEmpty, _filteredQuotesList);
                            },
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Color(0xFF484848),
                      borderRadius: BorderRadius.circular(30.0),
                      child: IconButton(
                        icon: Icon(Icons.search),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            if (toggle) {
                              print(toggle);
                              toggle = false;
                              _animationController.forward();
                            } else {
                              print(toggle);
                              toggle = true;
                              _searchController.clear();

                              _animationController.reverse();
                            }
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void searchData(String input) {
    String query = input.toLowerCase();
    // if (query.length > 1) {
    setState(
      () {
        _filteredQuotesList = widget.baseQuotesList
            .where((quote) =>
                quote.content.toLowerCase().contains(query) ||
                quote.author.toLowerCase().contains(query) ||
                quote.tags.any((tag) => tag.toLowerCase().contains(query)))
            .toList();
      },
    );
    widget.onSearchStateChanged(isSearchBarNotEmpty, _filteredQuotesList);
    // }
  }

  List<TextSpan> getStyledTitle(String titleOfThePage) {
    List<String> words = titleOfThePage.split(" ");
    List<TextSpan> result = [];

    for (var word in words) {
      result.add(TextSpan(
        text: word[0],
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ));
      result.add(TextSpan(
        text: '${word.substring(1)} ',
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ));
    }
    return result;
  }
}
