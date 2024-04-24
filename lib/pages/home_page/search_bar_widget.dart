import 'package:flutter/material.dart';
import 'package:flutter_quote_master/quotes/models/quote.dart';
import 'package:hive/hive.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(bool, List<Quote>) onSearchStateChanged;
  const SearchBarWidget({super.key, required this.onSearchStateChanged});
  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late Box<Quote> box;
  bool isSearching = false;
  List<Quote> filteredQuotes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    box = Hive.box<Quote>("mybox");
    filteredQuotes = box.values.toList();
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
                        isSearching = false;
                          widget.onSearchStateChanged(
                              isSearching, filteredQuotes);
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
                isSearching =
                    (_searchController.text.length > 1) ? true : false;
              });
              widget.onSearchStateChanged(isSearching, filteredQuotes);
            },
          ),
        ),
      ],
    );
  }

  void searchData(String input) {
    String query = input.toLowerCase();
    if (query.length > 1) {
      setState(
        () {
          filteredQuotes = box.values
              .where((quote) =>
                  quote.content.toLowerCase().contains(query) ||
                  quote.author.toLowerCase().contains(query) ||
                  quote.tags.any((tag) => tag.toLowerCase().contains(query)))
              .toList();
        },
      );
      widget.onSearchStateChanged(isSearching, filteredQuotes);
    }
  }
}
