import 'package:flutter/foundation.dart';
import 'package:fueltter/forms/form_validators.dart';

class FormElement<K, T extends Object> with ChangeNotifier {
  final K key;
  final ValidationCallback<T> _validator;
  final String errorMsg;
  final T errorValue;
  T _value;
  String _error;
  FormElement(this.key,
      {ValidationCallback<T> validator,
      this.errorMsg,
      T initialValue,
      this.errorValue})
      : _validator = validator ?? ((_) => true) {
    change(initialValue, notify: false);
  }

  T get value => _value;

  FormElement<K, T> get copy => FormElement(key,
      validator: _validator, initialValue: _value, errorMsg: errorMsg);

  void change(T value, {notify = true}) {
    if (_validator(value)) {
      _value = value;
      _error = null;
    } else {
      _value = errorValue;
      _error = errorMsg ?? 'Error';
    }
    if (notify) {
      notifyListeners();
    }
  }

  String get error => _error;
}
