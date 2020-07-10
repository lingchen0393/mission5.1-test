import 'package:flutter/material.dart';
import 'package:mission7chiptest7/main.dart';
import 'dart:math';

const tags = <AppProfile>[
  AppProfile('version'),
  AppProfile('meeting'),
  AppProfile('files'),
  AppProfile('love'),
  AppProfile('food'),
  AppProfile('drinks'),
  AppProfile('toys'),
  AppProfile('gifts'),
  AppProfile('new ideas and i love so that i buy it'),
  AppProfile('协作'),
  AppProfile('看板'),
  AppProfile('version5.1'),
  AppProfile('审批模版'),
  AppProfile('资讯'),
  AppProfile('非常具体的事情1'),
  AppProfile('非常具体的事情一'),
  AppProfile('fcjtdsq1'),
];

class AppProfile {
  final String tagName;

  const AppProfile(this.tagName);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppProfile && runtimeType == other.runtimeType && tagName == other.tagName;

  @override
  int get hashCode => tagName.hashCode;

  @override
  String toString() {
    return 'Profile{$tagName}';
  }

}

