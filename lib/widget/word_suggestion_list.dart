import 'package:flutter/material.dart';
import 'package:olx/utils/Theme.dart';

class WordSuggestionList extends StatelessWidget {
  const WordSuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return Column(
          children: [
            ListTile(
              leading: query.isEmpty ? Icon(Icons.history) : Icon(null),
              // Highlight the substring that matched the query.
              title: RichText(
                text: TextSpan(
                  text: suggestion.substring(0, query.length),
                  style: textTheme.copyWith(fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: suggestion.substring(query.length),
                      style: textTheme,
                    ),
                  ],
                ),
              ),
              onTap: () {
                onSelected(suggestion);
              },
            ),
            Divider(color: Color(0xffE3E7EF),)
          ],
        );
      },
    );
  }
}