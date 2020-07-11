import 'package:flutter/material.dart';
import 'package:mission7chiptest8/pages/edit_tags_page.dart';
import 'pages/display_tags_page.dart';

void main() {
  runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => ChipChosen(),
        '/edit': (context) => ChipsEdit(),
      }
  ));
}
