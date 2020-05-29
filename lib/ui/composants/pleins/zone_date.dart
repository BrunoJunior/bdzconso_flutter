import 'package:conso/blocs/add_plein_form_bloc.dart';
import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/ui/composants/loader.dart';
import 'package:conso/ui/tools/form_fields_tools.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ZoneDate extends StatelessWidget {
  Future<void> _selectDate(
      BuildContext context, DateTime data, AddPleinFormBloc formBloc) async {
    final DateTime now = DateTime.now();
    DateTime date = await showDatePicker(
      context: context,
      initialDate: data,
      firstDate: DateTime(now.year - 50),
      lastDate: DateTime(now.year + 50),
    );
    formBloc.onDateChanged(DateFormat.yMd().format(date));
  }

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<AddPleinFormBloc>(context);
    return StreamBuilder<DateTime>(
      stream: formBloc.date,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loader();
        }
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Date *',
            icon: Icon(Icons.calendar_today),
          ),
          controller: TextEditingController(
              text: DateFormat.yMd().format(snapshot.data)),
          focusNode: AlwaysDisabledFocusNode(),
          onTap: () => _selectDate(context, snapshot.data, formBloc),
        );
      },
    );
  }
}
