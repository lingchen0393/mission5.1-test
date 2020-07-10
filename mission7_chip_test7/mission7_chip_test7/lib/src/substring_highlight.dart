/**
 * 以char为单位查找text中的高亮部分
 */

library substring_highlight;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Widget that renders a string with sub-string highlighting.
class SubstringHighlight extends StatelessWidget {
  /// The String searched by {SubstringHighlight.term}.
  final String text;

  /// The sub-string that is highlighted inside {SubstringHighlight.text}.
  final String term;

  /// The {TextStyle} of the {SubstringHighlight.text} that isn't highlighted.
  final TextStyle textStyle;

  /// The {TextStyle} of the {SubstringHighlight.term}s found.
  final TextStyle textStyleHighlight;

  SubstringHighlight({
    @required this.text,
    @required this.term,
    this.textStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    this.textStyleHighlight = const TextStyle(
      color: Colors.green,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
  });

  //  ///从得到的textSpan widgetlist中得到对应index的string

//  List<String> _suggestionRich = [];// 带高亮属性推荐列表
//  List<InlineSpan> _suggestionSpan = [];
//
//  List<String> phraseList = [];

//
//  //构建rich推荐列表
//  Widget buildRichText(String phrase, String searched) {
//    //List<InlineSpan> _suggestionSpan = [];
//    int i;
//    for (i = 0; i < phrase.length; i++) {
//      phraseList.add(phrase[i]);
//    }
//    print(phraseList);
//    for (String word in phraseList) {
//      _suggestionSpan.add(
//          TextSpan(text: "$word ",
//            style: TextStyle(
//              fontSize: 18,
//              color: checkWordContained(word, searched),
//            ),
//          )
//      );
//    }
//    phraseList.clear();
//    return RichText(
//      textAlign: TextAlign.start,
//      text: TextSpan(
//        style: TextStyle(fontSize: 17, color: Colors.black),
//        children: _suggestionSpan,
//      ),
//    );
//  }

//  ///关键字颜色变化监控
//  checkWordContained(String word, String searched){
//    List<String> searchedList = [];
//    for(int i = 0;i<searched.length;i++){
//      searchedList.add(searched[i]);
//    }
//    for(String searchWord in searchedList){
//      if(word == searchWord){
//        return Colors.green;
//      }
//    }
//    return Colors.black;
//  }
//
//  /**
//   * textfield输入推荐项
//   */
//  _onTextChanged(String text){
//    setState(() {
//      _suggestion = tags.where((element) => element.toString().toLowerCase().contains(text.toLowerCase()))
//          .toList();
//    });
//  }


  @override
  Widget build(BuildContext context) {
    if (term.isEmpty) {
      return Text(text, style: textStyle);
    } else {
      String termLC = term.toLowerCase();

      List<InlineSpan> children = [];
      //text.indexOf(term);

      List<String> spanList = text.toLowerCase().split(termLC);
      int i = 0;
      //遍历查找
      for (var v in spanList) {
        if (v.isNotEmpty) {
          children.add(TextSpan(
              text: text.substring(i, i + v.length), style: textStyle));
          i += v.length;
        }
        if (i < text.length) {
          children.add(TextSpan(
              text: text.substring(i, i + term.length),
              style: textStyleHighlight));
          i += term.length;
        }
      }
      return RichText(text: TextSpan(children: children));
    }
  }
}