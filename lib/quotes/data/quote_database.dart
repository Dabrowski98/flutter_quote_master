import 'package:flutter_quote_master/quotes/models/quote.dart';
import 'package:flutter_quote_master/quotes/services/quote_service.dart';
import 'package:hive_flutter/adapters.dart';

class QuoteDatabase {
  final String boxName = "mybox";
  static int dayPassed = DateTime.now().difference(DateTime(1970)).inDays;

  initData() async {
    var box = await Hive.openBox<Quote>(boxName);
    var data = await QuoteService().fetchQuotes();
    int pages = data["totalPages"];
    int totalCount = data["totalCount"];
    if (box.isEmpty) {
      await populateBox(box, pages);
      print("populating");
    } else if (box.length != totalCount) {
      print("local count ${box.length}");
      await box.clear();
      await populateBox(box, pages);
      print("local count ${box.length}");
    } else {
      print("local count ${box.length}");
      print("we're up to date");
    }
  }

  Quote getDailyQuote() {
    var box = Hive.box<Quote>("mybox");
    int dailyQuoteIndex = dayPassed % box.length;
    return box.getAt(dailyQuoteIndex) ??
        Quote(
            content: "No daily quote found!",
            author: "author",
            authorSlug: "authorSlug",
            tags: ["tags"],
            length: 0,
            id: "00000");
  }
}

Future<void> populateBox(Box<Quote> box, int pages) async {
  for (var i = 1; i <= pages; i++) {
    var data = await QuoteService().fetchQuotes(pageNumber: i);
    int quotesOnPage = data["count"];
    for (var j = 0; j < quotesOnPage; j++) {
      var objects = data["results"];
      // print(i * j);
      var addedQuote = Quote(
          content: objects[j]["content"],
          author: objects[j]["author"],
          authorSlug: objects[j]["authorSlug"],
          tags: objects[j]["tags"],
          length: objects[j]["length"],
          id: objects[j]["_id"],
          isFavorite: false,
          key: (i - 1) * 150 + j);
      box.put(addedQuote.key, addedQuote);
    }
  }
}
