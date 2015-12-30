library wChaser.src.utils.dates;

String getPrettyDates(DateTime dateToCompare) {
  Duration d = new DateTime.now().difference(dateToCompare);
  dateLabel(length, label) => 'Updated $length $label ago';

  if (d.inDays > 0) {
    return dateLabel(d.inDays, d.inDays == 1 ? 'day' : 'days');
  } else if (d.inHours >= 1) {
    return dateLabel(d.inHours, d.inHours == 1 ? 'hour' : 'hours');
  } else if (d.inMinutes >= 1) {
    return dateLabel(d.inMinutes, d.inMinutes == 1 ? 'minute' : 'minutes');
  } else if (d.inSeconds > 0) {
    return dateLabel(d.inSeconds, d.inSeconds == 1 ? 'second' : 'seconds');
  }

  return '';
}
