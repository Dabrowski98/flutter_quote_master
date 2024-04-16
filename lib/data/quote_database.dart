import 'package:flutter_quote_master/models/quote.dart';
import 'package:flutter_quote_master/services/quote_service.dart';
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
    } else if (box.length != totalCount) {
      await box.clear();
    print("local count ${box.length}");
      await populateBox(box, pages);
    print("local count ${box.length}");
    } else {
      print("we're up to date");
    }
  }

  Future<Quote?> getDailyQuote() async {
    var box = Hive.box<Quote>("mybox");
    int dailyQuoteIndex = dayPassed % box.length;
    return box.getAt(dailyQuoteIndex);
  }

  Future<void> populateBox(
      Box<Quote> box, int pages) async {
    for (var i = 1; i <= pages; i++) {
      var data = await QuoteService().fetchQuotes(pageNumber: i);
      int quotesOnPage = data["count"];
      for (var j = 0; j < quotesOnPage; j++) {
        var objects = data["results"];
        // print(i * j);
        await box.add(Quote(
            content: objects[j]["content"],
            author: objects[j]["author"],
            authorSlug: objects[j]["authorSlug"],
            tags: objects[j]["tags"],
            length: objects[j]["length"]));
      }
    }
  }
}
