String parseDate(String date) {
  if (date.isEmpty) {
    DateTime dateTime = DateTime.now();
    String day =
        dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day.toString();
    String month =
        dateTime.month < 10 ? '0${dateTime.month}' : dateTime.day.toString();
    return "$day/$month/${dateTime.year}";
  } else {
    DateTime dateTime = DateTime.parse(date);
    String day =
        dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day.toString();
    String month =
        dateTime.month < 10 ? '0${dateTime.month}' : dateTime.day.toString();
    return "$day/$month/${dateTime.year}";
  }
}

String parseUniqueDate(String date) {
  if (date.isEmpty) {
    DateTime dateTime = DateTime.now();
    String weekDay = fetchWeekDay(dateTime.weekday);
    String month = fetchMonth(dateTime.month);
    return "$weekDay, ${dateTime.day} $month ${dateTime.year}";
  } else {
    DateTime dateTime = DateTime.parse(date);
    String weekDay = fetchWeekDay(dateTime.weekday);
    String month = fetchMonth(dateTime.month);
    return "$weekDay, ${dateTime.day} $month ${dateTime.year}";
  }
}

String parseUniqueTime(String time) {
  if (time.isEmpty) {
    DateTime dateTime = DateTime.now();
    int minute = dateTime.minute;
    int hour = dateTime.hour;
    int second = dateTime.second;
    return '$hour:$minute:$second';
  } else {
    DateTime dateTime = DateTime.parse(time);
    int minute = dateTime.minute;
    int hour = dateTime.hour;
    int second = dateTime.second;
    return '$hour:$minute:$second';
  }
}

String parseDataBaseDate(String date) {
  if (date.isEmpty) {
    DateTime dateTime = DateTime.now();
    String month = _checkMonth(dateTime.month);
    String day =
        dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day.toString();
    return "${dateTime.year}-${month}-${day}";
  } else {
    DateTime dateTime = DateTime.parse(date);
    String month = _checkMonth(dateTime.month);
    String day =
        dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day.toString();
    return "${dateTime.year}-${month}-${day}";
  }
}

String parseDataBaseTime(String time) {
  if (time.isEmpty) {
    DateTime dateTime = DateTime.now();
    String minute = _checkMinute(dateTime.minute);
    int hour = dateTime.hour;
    int second = dateTime.second;
    return '$hour:$minute:$second';
  } else {
    DateTime dateTime = DateTime.parse(time);
    String minute = _checkMinute(dateTime.minute);
    int hour = dateTime.hour;
    int second = dateTime.second;
    return '$hour:$minute:$second';
  }
}

String _checkMinute(int minute) {
  if (minute.toString().length == 1) {
    return '0$minute';
  } else {
    return '$minute';
  }
}

String _checkMonth(int month) {
  if (month.toString().length == 1) {
    return '0$month';
  } else {
    return '$month';
  }
}

String fetchWeekDay(int weekDate) {
  switch (weekDate) {
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
    default:
      return "Monday";
  }
}

String fetchMonth(int month) {
  switch (month) {
    case 1:
      return "January";
    case 2:
      return "February";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 12:
      return "December";
    default:
      return "January";
  }
}

String formatDuration(Duration d) {
  var seconds = d.inSeconds;
  final days = seconds ~/ Duration.secondsPerDay;
  seconds -= days * Duration.secondsPerDay;
  final hours = seconds ~/ Duration.secondsPerHour;
  seconds -= hours * Duration.secondsPerHour;
  final minutes = seconds ~/ Duration.secondsPerMinute;
  seconds -= minutes * Duration.secondsPerMinute;

  final List<String> tokens = [];
  if (days != 0) {
    tokens.add('${days}d');
  }
  if (tokens.isNotEmpty || hours != 0) {
    tokens.add('${hours}h');
  }
  if (tokens.isNotEmpty || minutes != 0) {
    tokens.add('${minutes}m');
  }
  tokens.add('${seconds}s');

  return tokens.join(':');
}
//*parse dating 