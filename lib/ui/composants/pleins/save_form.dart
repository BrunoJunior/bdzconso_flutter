import 'package:conso/blocs/add_plein_form_bloc.dart';
import 'package:conso/blocs/bloc_provider.dart';
import 'package:flutter/material.dart';

class SaveForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<AddPleinFormBloc>(context);
    return StreamBuilder<bool>(
        stream: formBloc.isValid,
        builder: (context, snapshot) {
          return IconButton(
            icon: Icon(Icons.save),
            onPressed:
                (snapshot.data ?? false) ? () => formBloc.onSubmit : null,
          );
        });
  }
}
