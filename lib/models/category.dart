

import 'package:flutter/material.dart';

class Category {
  final Icon icon;
  final String title;
  final String tasks;
  final Function onPressed;

  Category({
    required this.icon,
    required this.onPressed,
    required this.tasks,
    required this.title,
  });
}