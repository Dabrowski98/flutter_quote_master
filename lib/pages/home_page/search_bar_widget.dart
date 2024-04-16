import 'package:flutter/material.dart';
import 'package:flutter_quote_master/models/quote.dart';
import 'package:hive/hive.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(bool) onSearchStateChanged;
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
              prefixIcon: const Icon(Icons.search),
              hintText: "Search",
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
              widget.onSearchStateChanged(isSearching);
            },
          ),
        ),
        displaySearchResults()
      ],
    );
  }

  void searchData(String input) {
    String query = input.toLowerCase();
    if (query.length > 1 && filteredQuotes.length > 1) {
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
    }
  }

  displaySearchResults() {
    if (isSearching) {
      print("SEARCHING");
      return SizedBox(
        height: calculateListViewHeight(filteredQuotes),
        child: Stack(
          children: [
            ListView.builder(
              itemCount: filteredQuotes.length,
              itemBuilder: (context, index) => Container(
                padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Text(filteredQuotes[index].content),
              ),
            ),
          ],
        ),
      );
    } else {
      print("NOT SEARCHING");
      return SizedBox.shrink();
    }
  }

  double calculateListViewHeight(List<Quote> quotes) {
    if (quotes.length < 4)
      return quotes.length * 50;
    else
      return 300;
  }
}
