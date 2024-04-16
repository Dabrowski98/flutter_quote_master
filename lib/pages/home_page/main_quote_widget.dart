import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quote_master/data/quote_database.dart';
import 'package:flutter_quote_master/models/quote.dart';
import 'package:flutter_quote_master/widgets/tile.dart';

class MainQuoteWidget extends StatefulWidget {
  const MainQuoteWidget({super.key, required this.isSearching});
  final bool isSearching;

  @override
  State<MainQuoteWidget> createState() => _MainQuoteWidgetState();
}

class _MainQuoteWidgetState extends State<MainQuoteWidget> {
  bool _quotePrintingFinished = false;
  late Future<Quote?> _quoteFuture;

  @override
  void initState() {
    _quoteFuture = QuoteDatabase().getDailyQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Tile(
          color: const Color.fromARGB(255, 73, 73, 73),
          child: widget.isSearching ? showSearchResults() : showQuote(),
        ),
      ),
    );
  }

  Column showQuote() {
    return Column(
      children: [
        const Text(
          "Quote of the day!",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        FutureBuilder(
          future: _quoteFuture,
          builder: (
            context,
            snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AnimatedTextKit(
                repeatForever: true,
                pause: Duration.zero,
                animatedTexts: [
                  TypewriterAnimatedText(" ",
                      speed: Durations.long1,
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ))
                ],
              );
            }
            if (snapshot.hasData) {
              final data = snapshot.data;
              final content = data!.content;
              final author = data.author;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      onFinished: () => setState(() {
                        _quotePrintingFinished = true;
                      }),
                      pause: Duration.zero,
                      animatedTexts: [
                        TypewriterAnimatedText(content,
                            textAlign: TextAlign.left,
                            textStyle: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  if (_quotePrintingFinished == true)
                    AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TypewriterAnimatedText(author,
                            textAlign: TextAlign.center,
                            textStyle: const TextStyle(color: Colors.white)),
                      ],
                    )
                ],
              );
            } else {
              return AnimatedTextKit(
                repeatForever: true,
                pause: Duration.zero,
                animatedTexts: [
                  TypewriterAnimatedText(" ", speed: Durations.long1)
                ],
              );
            }
          },
        ),
      ],
    );
  }

  showSearchResults() {
    return Text("Search");
  }
}
