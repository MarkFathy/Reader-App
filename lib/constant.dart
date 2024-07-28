import 'package:flutter/material.dart';

String ip = '';

var colorPrimary = Color.fromRGBO(31, 43, 70, 1);
var colorSelectedBN = Color(0xFF36BFC6);
var colorSecondary = Color.fromRGBO(233, 239, 255, 1);

var colorLightGrey = Color(0xFF707070);


BoxDecoration containerDecoration= const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromRGBO(31, 43, 70, 1),
      Color.fromRGBO(134, 159, 216, 1),
    ],
  ),
);