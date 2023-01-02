import 'package:hive/hive.dart';

part 'cliente_model.g.dart';

@HiveType(typeId: 1)
class Cliente extends HiveObject {
  @HiveField(0)
  String? idCliente;
  @HiveField(1)
  int? idUsuario;
  @HiveField(2)
  String? nome;
  @HiveField(3)
  int? agencia;
  @HiveField(4)
  int? conta;
  @HiveField(5)
  DateTime? dataLancamento;
  @HiveField(6)
  String? telefone1;
  @HiveField(7)
  String? telefone2;
}
