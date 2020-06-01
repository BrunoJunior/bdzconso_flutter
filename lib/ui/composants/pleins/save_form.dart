import 'package:flutter/material.dart';
import 'package:fueltter/blocs/add_plein_form_bloc.dart';
import 'package:fueltter/blocs/bloc_provider.dart';

class SaveForm extends StatelessWidget {
  const SaveForm();
  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<AddPleinFormBloc>(context);
    return StreamBuilder<bool>(
        stream: formBloc.isValid,
        builder: (context, snapshot) {
          return IconButton(
            icon: const Icon(Icons.save),
            onPressed:
                (snapshot.data ?? false) ? () => formBloc.onSubmit : null,
          );
        });
  }
}
