import 'package:flutter/foundation.dart';

typedef ValidationCallback<T> = bool Function(T value);

class ValidatedItem<T> {
  final T value;
  final String error;
  ValidatedItem({this.value, this.error});
  bool hasValue() => null != value;
  bool hasError() => null != error;
}

class ItemValidator<T> {
  final ValidationCallback<T> validation;
  final String errorMsg;
  ItemValidator({@required this.validation, @required this.errorMsg});

  static ItemValidator alwaysValid =
      ItemValidator(validation: (_) => true, errorMsg: '');
  static ItemValidator notNull =
      ItemValidator(validation: (v) => null != v, errorMsg: 'Champ requis !');
  static ItemValidator<String> stringRequired = ItemValidator<String>(
      validation: (v) => (v ?? '').isNotEmpty, errorMsg: 'Champ requis !');

  ValidatedItem<T> check(T value) => validation(value)
      ? ValidatedItem(value: value)
      : ValidatedItem(error: errorMsg);
}
