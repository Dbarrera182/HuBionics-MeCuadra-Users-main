import 'dart:convert';

class JsonConst {
  static String dateToDay(DateTime date) {
    dynamic dayData =
        '{ "1" : "Lunes", "2" : "Martes", "3" : "Miércoles", "4" : "Jueves", "5" : "Viernes", "6" : "Sábado", "7" : "Domingo" }';

    return json.decode(dayData)['${date.weekday}'];
  }

  static String dateToShortDay(DateTime date) {
    dynamic dayData =
        '{ "1" : "L", "2" : "M", "3" : "M", "4" : "J", "5" : "V", "6" : "S", "7" : "D" }';

    return json.decode(dayData)['${date.weekday}'];
  }

  static String dateToShortMonth(DateTime date) {
    dynamic monthData =
        '{ "1" : "Ene", "2" : "Feb", "3" : "Mar", "4" : "Abr", "5" : "May", "6" : "Jun", "7" : "Jul", "8" : "Ago", "9" : "Sep", "10" : "Oct", "11" : "Nov", "12" : "Dic" }';

    return json.decode(monthData)['${date.month}'];
  }

  static String dateToMonth(DateTime date) {
    dynamic monthData =
        '{ "1" : "Enero", "2" : "Febrero", "3" : "Marzo", "4" : "Abril", "5" : "Mayo", "6" : "Junio", "7" : "Julio", "8" : "Agosto", "9" : "Septiembre", "10" : "Octubre", "11" : "Noviembre", "12" : "Diciembre" }';

    return json.decode(monthData)['${date.month}'] + " " + date.year.toString();
  }

  static String onlyDateToMonth(DateTime date) {
    dynamic monthData =
        '{ "1" : "Enero", "2" : "Febrero", "3" : "Marzo", "4" : "Abril", "5" : "Mayo", "6" : "Junio", "7" : "Julio", "8" : "Agosto", "9" : "Septiembre", "10" : "Octubre", "11" : "Noviembre", "12" : "Diciembre" }';

    return json.decode(monthData)['${date.month}'];
  }
}
