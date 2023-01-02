import 'package:flutter/material.dart';

const List<Color> gradient = [Color.fromARGB(255, 99, 125, 255), Color.fromARGB(255, 110, 183, 255)];

Map<int, Color> primaryColorMap = {
  50: const Color.fromRGBO(99, 125, 255, .1),
  100: const Color.fromRGBO(99, 125, 255, .2),
  200: const Color.fromRGBO(99, 125, 255, .3),
  300: const Color.fromRGBO(99, 125, 255, .4),
  400: const Color.fromRGBO(99, 125, 255, .5),
  500: const Color.fromRGBO(99, 125, 255, .6),
  600: const Color.fromRGBO(99, 125, 255, .7),
  700: const Color.fromRGBO(99, 125, 255, .8),
  800: const Color.fromRGBO(99, 125, 255, .9),
  900: const Color.fromRGBO(99, 125, 255, 1),
};

MaterialColor primaryColor = MaterialColor(0xFF637dff, primaryColorMap);
