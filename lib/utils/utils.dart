

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DateFormatter{
  static const DATE_FORMAT = 'HH:mm dd/MM/yyyy';
  static String FormateDate(String date)
  {
   DateTime  datetime=DateTime.parse(date);
   return DateFormat(DATE_FORMAT,).format(datetime);
  }

}