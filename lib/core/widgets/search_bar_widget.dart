import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_quote_master/quotes/models/quote.dart';
import 'package:hive/hive.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(bool, List<Quote>) onSearchStateChanged;
  final List<Quote> baseQuotesList;

  const SearchBarWidget(
      {super.key,
      required this.baseQuotesList,
      required this.onSearchStateChanged});
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
  int toggle = 0;

  @override
  void initState() {
    _quotesBox = Hive.box<Quote>("quotesBox");
    _filteredQuotesList = widget.baseQuotesList;
    _searchController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          margin: const EdgeInsets.all(4.0),
          child: TextField(
            controller: _searchController,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              prefixIcon: const Icon(Icons.search),
              hintText: "Search for Quotes!",
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          isSearchBarNotEmpty = false;
                          widget.onSearchStateChanged(
                              isSearchBarNotEmpty, _filteredQuotesList);
                        });
                      },
                    )
                  : const Icon(
                      Icons.hourglass_bottom,
                      color: Colors.transparent,
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 73, 73, 73),
                ),
              ),
            ),
            onChanged: (input) {
              searchData(input);
              setState(() {
                isSearchBarNotEmpty =
                    (_searchController.text.length > 1) ? true : false;
              });
              widget.onSearchStateChanged(
                  isSearchBarNotEmpty, _filteredQuotesList);
            },
          ),
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
}
