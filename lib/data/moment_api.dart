import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Medicine {
  final String name;
  bool taken;

  //added tablets and milligramsPerTablet to count amount per week
  int tabletsQty;
  int milligramsPerTablet;

  Medicine(this.name, this.tabletsQty, this.milligramsPerTablet,
      [this.taken = false]);
}

class Moment {
  final String title;
  final Icon icon;
  final List<Medicine> medicines;
  final DateTime date;
  bool isCollapsed;

  Moment(this.title, this.date, this.icon, this.medicines,
      [this.isCollapsed = true]);
}

class MomentApi {
  static final _dateFormat = DateFormat("yyyy-MM-dd HH:mm");

  static DateTime _dateTimeFromString(String dateStr) {
    return _dateFormat.parse(dateStr);
  }

  static bool _randomBool() {
    final randomNum = Random();
    return randomNum.nextBool();
  }

  static Moment breakfast(String day) {
    return Moment("Ontbijt", _dateTimeFromString("2019-01-$day 8:00"),
        const Icon(Icons.free_breakfast), [
      Medicine("Paracetamol", 2, 40, _randomBool()),
      Medicine("Vitamine C", 3, 100, _randomBool())
    ]);
  }

  static Moment lunch(String day) {
    return Moment("Lunch", _dateTimeFromString("2019-01-$day 12:00"),
        const Icon(Icons.home), [Medicine("Acebutol", 2, 200, _randomBool())]);
  }

  static Moment atWork(String day) {
    return Moment(
        "Op 't werk",
        _dateTimeFromString("2019-01-$day 15:00"),
        const Icon(Icons.business_center),
        [Medicine("Paracetamol", 4, 500, _randomBool())]);
  }

  static Moment bedTime(String day) {
    return Moment("Voor het slapen", _dateTimeFromString("2019-01-$day 22:00"),
        const Icon(Icons.alarm), [Medicine("Melatonin", 2, 300)]);
  }

  static List<Moment> getMoments() {
    final moments = [
      breakfast("01"),
      lunch("01"),
      breakfast("02"),
      lunch("02"),
      atWork("02"),
      breakfast("03"),
      lunch("03"),
      breakfast("04"),
      atWork("04"),
      breakfast("06"),
      lunch("06"),
      atWork("06"),
      bedTime("07"),
      breakfast("08"),
      lunch("08"),
      breakfast("09"),
      lunch("09"),
      atWork("09"),
      breakfast("10"),
      lunch("10"),
      breakfast("11"),
      atWork("11"),
      breakfast("13"),
      lunch("13"),
      atWork("13"),
      bedTime("14"),
    ];

    moments[Random().nextInt(moments.length - 1)].isCollapsed = false;

    return moments;
  }
}
