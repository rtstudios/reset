import 'package:flutter/material.dart';
import 'package:quotes/quotes.dart';

var quote = Quotes.getRandom();

class Quote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Text(
        quote.getContent().toString(),
        style: TextStyle(
          fontSize: 20,
          fontFamily: "Avenir",
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
    );
  }
}

class Author extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Text(
        "- " + quote.getAuthor().toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontFamily: "Avenir",
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
