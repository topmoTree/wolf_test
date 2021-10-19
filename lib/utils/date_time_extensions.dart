import 'package:intl/intl.dart';

final _timeFormat = DateFormat("HH:mm");
final _dateFormat = DateFormat("EEEE dd MMMM");

//https://stackoverflow.com/a/56252864 should use intl package
final _dateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");

extension DateTimeExt on DateTime{
  String printTime(){
    return _timeFormat.format(this);
  }

  String printDate(){
    return _dateFormat.format(this);
  }
}