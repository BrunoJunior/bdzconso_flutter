import 'package:flutter/material.dart';
import 'package:fueltter/forms/form.dart';
import 'package:fueltter/forms/plein_form.dart';
import 'package:provider/provider.dart';

class SaveForm extends StatelessWidget {
  const SaveForm();
  @override
  Widget build(BuildContext context) => Selector<PleinForm, FormStatus>(
        selector: (_, form) => form.status,
        builder: (context, status, __) => IconButton(
          icon: Icon(FormStatus.SUBMITTING == status ? Icons.sync : Icons.save),
          onPressed: FormStatus.VALID == status
              ? () async {
                  await Provider.of<PleinForm>(context, listen: false).submit();
                  Navigator.pop(context);
                }
              : null,
        ),
      );
}
