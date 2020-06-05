import 'package:flutter/foundation.dart';
import 'package:fueltter/forms/form_element.dart';

enum FormStatus {
  INVALID,
  VALID,
  SUBMITTING,
  SUBMITTED,
  SUBMISSION_ERROR,
}

abstract class Form<K> with ChangeNotifier {
  FormStatus _status = FormStatus.INVALID;
  Map<K, FormElement> _fields = Map();

  void addField<T>(FormElement<K, T> field) {
    field.addListener(() => addField((field..dispose()).copy));
    _fields[field.key] = field;
    check();
  }

  @override
  dispose() {
    _fields.values.forEach((f) => f.dispose());
    super.dispose();
  }

  FormStatus get status => _status;

  FormElement<K, T> getField<T>(K key) => _fields[key];

  @protected
  set status(FormStatus status) => _status = status;

  @protected
  Future<void> onSubmit();

  void check() {
    final isOk = _fields.values.where((el) => null != el.error).isEmpty;
    status = isOk ? FormStatus.VALID : FormStatus.INVALID;
    notifyListeners();
  }

  Future<void> submit() async {
    if (FormStatus.VALID != status) {
      return;
    }
    status = FormStatus.SUBMITTING;
    notifyListeners();
    try {
      await onSubmit();
      status = FormStatus.SUBMITTED;
    } catch (e) {
      print(e);
      status = FormStatus.SUBMISSION_ERROR;
    } finally {
      notifyListeners();
    }
  }
}
