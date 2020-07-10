import 'package:flutter/material.dart';
import 'package:mission7chiptest7/edit_tags_page.dart';
import 'display_tags_page.dart';

void main() {
  runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => ChipChosen(),
        '/edit': (context) => ChipsEdit(),
      }
  ));
}
