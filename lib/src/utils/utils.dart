import 'package:intl/intl.dart';

bool isNumeric(String s) {

  if(s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null ) ? false : true ;

}

String numberFormat ( double t) {
      NumberFormat f = new NumberFormat("#,##0.00", "en_US");
      return f.format(t);
}