import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fueltter/forms/form_element.dart';
import 'package:fueltter/forms/plein_form.dart';
import 'package:fueltter/ui/composants/form_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class ZoneDate extends StatelessWidget {
  const ZoneDate();

  Future<void> _selectDate(
      BuildContext context, FormElement<PleinField, String> dateInput) async {
    final DateTime now = DateTime.now();
    DateTime date = await showDatePicker(
      context: context,
      initialDate: DateFormat.yMd().parse(dateInput.value),
      firstDate: DateTime(now.year - 50),
      lastDate: DateTime(now.year + 50),
    );
    dateInput.change(DateFormat.yMd().format(date));
  }

  @override
  Widget build(BuildContext context) {
    return FormCard(
      title: 'Infos générales',
      titleIcon: const FaIcon(FontAwesomeIcons.infoCircle),
      children: [
        Selector<PleinForm, FormElement<PleinField, String>>(
          selector: (_, form) => form.date,
          builder: (context, date, _) => TextFormField(
            decoration: InputDecoration(
              labelText: 'Date *',
              icon: const Icon(Icons.calendar_today),
            ),
            controller: TextEditingController(text: date.value),
            focusNode: AlwaysDisabledFocusNode(),
            onTap: () => _selectDate(context, date),
          ),
        ),
      ],
    );
  }
}
