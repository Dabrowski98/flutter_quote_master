import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/widgets/tile.dart';

class RateWidget extends StatelessWidget {
  const RateWidget({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size / 3,
      height: (size / 3),
      child: GestureDetector(
        onTap: () async {
          _launchURL(Uri.https('play.google.com'));
        },
        child: const Tile(
          child: Text(
            "Rate the app",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
