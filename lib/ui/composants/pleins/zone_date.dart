import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fueltter/blocs/add_plein_form_bloc.dart';
import 'package:fueltter/blocs/bloc_provider.dart';
import 'package:fueltter/ui/composants/form_card.dart';
import 'package:fueltter/ui/composants/loader.dart';
import 'package:fueltter/ui/tools/form_fields_tools.dart';
import 'package:intl/intl.dart';

class ZoneDate extends StatelessWidget {
  const ZoneDate();

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
    return FormCard(
      title: 'Infos générales',
      titleIcon: const FaIcon(FontAwesomeIcons.infoCircle),
      children: [
        StreamBuilder<DateTime>(
          stream: formBloc.date,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loader();
            }
            return TextFormField(
              decoration: InputDecoration(
                labelText: 'Date *',
                icon: const Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                  text: DateFormat.yMd().format(snapshot.data)),
              focusNode: AlwaysDisabledFocusNode(),
              onTap: () => _selectDate(context, snapshot.data, formBloc),
            );
          },
        ),
      ],
    );
  }
}
