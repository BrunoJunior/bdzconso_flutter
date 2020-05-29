import 'package:conso/database/database.dart';

class ListePleinsAnnuels {
  final List<Plein> pleins;
  final bool anneePrec;
  ListePleinsAnnuels(this.pleins, {this.anneePrec = false});
}
