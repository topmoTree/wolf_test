import 'package:intl/intl.dart';

final _timeFormat = DateFormat("HH:mm");
final _dateFormat = DateFormat("EEEE dd MMMM");

extension DateTimeExt on DateTime {
  String printTime() {
    return _timeFormat.format(this);
  }

  String printDate() {
    return _dateFormat.format(this);
  }
}
