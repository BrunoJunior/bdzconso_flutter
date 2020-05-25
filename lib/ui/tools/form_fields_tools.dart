import 'package:flutter/material.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

FormFieldValidator<String> requiredValidator =
    (String value) => value.isEmpty ? 'Champ requis' : null;
