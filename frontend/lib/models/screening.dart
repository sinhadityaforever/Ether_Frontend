import 'package:flutter/material.dart';
import 'package:frontend/models/interestModel.dart';

class ScreeningModel {
  bool isSelected;
  String textOfButton;
  Color colorFromModel;
  List<InterestModel> screenedInterests;
  double sizeFromModel;
  IconData iconFromModel;
  ScreeningModel({
    this.colorFromModel = Colors.pinkAccent,
    this.isSelected = false,
    this.sizeFromModel = 25.00,
    required this.textOfButton,
    required this.screenedInterests,
    this.iconFromModel = Icons.question_answer,
  });

  void toggleSelect() {
    isSelected = !isSelected;
  }
}
