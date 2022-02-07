import 'package:flutter/material.dart';
import '../classes/categories.dart';

String rootDir = '';
late Size size;
final List<Category> categories = [];
Map allStorageMap = {
  'storage1Total': 0.0,
  'storage1Used': 0.0,
  'storage1Free': 0.0,
  'storage2Total': 0.0,
  'storage2Used': 0.0,
  'storage2Free': 0.0,
};
