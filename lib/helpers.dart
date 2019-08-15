import 'package:intl/intl.dart';

String shortDateFormat(DateTime dateTime){
  return DateFormat("MM/dd/yyyy hh:mm").format(dateTime);
}
