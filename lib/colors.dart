import 'package:flutter/material.dart';

const List<Color> gradient = [Color(0xFF4e54c8), Color(0xFF8f94fb)];

Map<int, Color> primaryColorMap = {
  50: const Color.fromRGBO(76, 73, 255, .1),
  100: const Color.fromRGBO(76, 73, 255, .2),
  200: const Color.fromRGBO(76, 73, 255, .3),
  300: const Color.fromRGBO(76, 73, 255, .4),
  400: const Color.fromRGBO(76, 73, 255, .5),
  500: const Color.fromRGBO(76, 73, 255, .6),
  600: const Color.fromRGBO(76, 73, 255, .7),
  700: const Color.fromRGBO(76, 73, 255, .8),
  800: const Color.fromRGBO(76, 73, 255, .9),
  900: const Color.fromRGBO(76, 73, 255, 1),
};

MaterialColor primaryColor = MaterialColor(0xFF4c49ff, primaryColorMap);
