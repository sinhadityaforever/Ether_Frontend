import 'package:flutter/material.dart';

class InterestModel {
  bool isSelected;
  String textOfButton;
  Color colorFromModel;
  double sizeFromModel;

  InterestModel({
    this.colorFromModel = Colors.pinkAccent,
    this.isSelected = false,
    this.sizeFromModel = 25.00,
    required this.textOfButton,
  });
}
