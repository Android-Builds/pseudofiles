import 'package:flutter/cupertino.dart';

class Category {
  final String _name;
  final IconData _icon;
  String size = '';
  final Widget page;
  final Function getSize;
  final dynamic argument;

  Category(
    this._name,
    this._icon,
    this.page,
    this.getSize,
    this.argument,
  );

  String get name => _name;
  IconData get icon => _icon;
}
