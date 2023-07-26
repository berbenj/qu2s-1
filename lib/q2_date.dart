import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';

class Q2Date {
  DateTime dt = DateTime(0);

  // gregorian date
  int _grYear = 0;
  int _grMonth = 0;
  int _grDay = 0;

  // b36 date
  int _b36Year = 0;
  int _b36Pernor = 0;
  int _b36Scrop = 0;
  int _b36Day = 0;

  // sectodecimal time
  int _sdHour = 0;
  int _sdMinute = 0;
  int _sdSecond = 0;
  int _sdMilliSecond = 0;
  int _sdMicroSecond = 0;

  // metric time
  int _mtArton = 0;
  int _mtJitt = 0;

  Q2Date(DateTime dt) {
    // ignore: prefer_initializing_formals
    this.dt = dt;

    _grYear = dt.year;
    _grMonth = dt.month;
    _grDay = dt.day;

    DateTime date = dt;
    // offset date to the b36 start of year
    date = date.subYears(1);
    date = date.addDays(121);
    _b36Year = date.year;
    _b36Day = date.getDayOfYear;
    // a b36 season consists of 91 days
    _b36Pernor = _b36Day ~/ 91;
    _b36Day %= 91;
    // a b36 week consists of 13 days
    _b36Scrop = _b36Day ~/ 13;
    _b36Day %= 13;

    _sdHour = dt.getHours;
    _sdMinute = dt.getMinutes;
    _sdSecond = dt.getSeconds;
    _sdMilliSecond = dt.getMilliseconds;
    _sdMicroSecond = dt.microsecond;

    date = dt;
    int milliSeconds =
        (((date.hour) * 60 + date.minute) * 60 + date.second) * 1000 +
            date.millisecond;
    int bigS = (milliSeconds.toDouble() / (36 * 24) * 1000).floor();
    bigS ~/= 1000;
    _mtArton = bigS ~/ 1000;
    _mtJitt = bigS % 1000;
  }

  String get grYear {
    return _grYear.toString().padLeft(4, '0');
  }

  String get grMonth {
    return _grMonth.toString().padLeft(2, '0');
  }

  String get grDay {
    return _grDay.toString().padLeft(2, '0');
  }

  String get b36Year {
    return _b36Year.toRadixString(36).padLeft(3, '0');
  }

  String get b36Pernor {
    return (_b36Pernor + 1).toRadixString(5).characters.last;
  }

  String get b36Scrop {
    return (_b36Scrop + 1).toString();
  }

  String get b36Day {
    return _b36Day.toRadixString(13);
  }

  String get sdHour {
    return _sdHour.toString().padLeft(2, '0');
  }

  String get sdMinute {
    return _sdMinute.toString().padLeft(2, '0');
  }

  String get sdSecond {
    return _sdSecond.toString().padLeft(2, '0');
  }

  String get sdMilliSecond {
    return _sdMilliSecond.toString().padLeft(3, '0');
  }

  String get sdMicroSecond {
    return _sdMicroSecond.toString().padLeft(3, '0');
  }

  String get mtArton {
    return _mtArton.toString().padLeft(2, '0');
  }

  String get mtJitt {
    return _mtJitt.toString().padLeft(3, '0');
  }
}
