import 'dart:typed_data';

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

Map<String, Uint8List> appIcons = <String, Uint8List>{};

List<String> suggestions = [];

String termsAndConditions =
    'By agreeing to this, I declare that I am aware that Peseudofiles is an unfinished product and is currently in the beta stage. Using this software can incure loss of my data and that I am solely responsible for my loss own data. I will not withheld anyone but myself responsible for the loss the the data. The developers of the software will not be responsible for whatever you might do with your data.';
