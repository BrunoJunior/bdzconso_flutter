import 'package:intl/intl.dart';

typedef ValidationCallback<T> = bool Function(T value);

class ObjectValidator {
  static bool required(v) => null != v;
}

class DoubleValidator {
  static const String _rule = r"^(-?\d+[.,]\d+)$|^(-?\d+)$";
  static double parse(String v) =>
      double.tryParse((v ?? '').replaceAll(',', '.'));
  static bool isValid(String v) => RegExp(_rule).hasMatch(v ?? '');
  static ValidationCallback<String> isGreaterThan(double num) =>
      (v) => isValid(v) && parse(v) > num;
  static ValidationCallback<String> isLesserThan(double num) =>
      (v) => isValid(v) && parse(v) < num;
  static ValidationCallback<String> isEqualsTo(double num) =>
      (v) => isValid(v) && parse(v) == num;
  static ValidationCallback<String> isGreaterOrEqualsTo(double num) =>
      (v) => isEqualsTo(num)(v) || isGreaterThan(num)(v);
  static ValidationCallback<String> isLesserOrEqualsTo(double num) =>
      (v) => isEqualsTo(num)(v) || isLesserThan(num)(v);
}

class IntValidator {
  static const String _rule = r"^(-?\d+)$";
  static int parse(String v) => int.parse(v ?? '');
  static bool isValid(String v) => RegExp(_rule).hasMatch(v);
  static ValidationCallback<String> isGreaterThan(int num) =>
      (v) => isValid(v) && parse(v) > num;
  static ValidationCallback<String> isLesserThan(int num) =>
      (v) => isValid(v) && parse(v) < num;
  static ValidationCallback<String> isEqualsTo(int num) =>
      (v) => isValid(v) && parse(v) == num;
  static ValidationCallback<String> isGreaterOrEqualsTo(int num) =>
      (v) => isEqualsTo(num)(v) || isGreaterThan(num)(v);
  static ValidationCallback<String> isLesserOrEqualsTo(int num) =>
      (v) => isEqualsTo(num)(v) || isLesserThan(num)(v);
}

class StringValidator {
  static bool required(String v) => null != v && v.isNotEmpty;
}

class DateValidator {
  static bool isValid(String v) {
    try {
      DateFormat.yMd().parse(v);
      return true;
    } catch (_) {
      return false;
    }
  }

  static bool isNotInFuture(String v) =>
      isValid(v) && !DateFormat.yMd().parse(v).isAfter(DateTime.now());
}

class ListValidator {
  static bool isNotEmpty(List v) => null != v && v.length > 0;
  static ValidationCallback<T> isIn<T>(List<T> Function() fl) => (v) {
        final l = fl();
        return isNotEmpty(l) && l.contains(v);
      };
}
