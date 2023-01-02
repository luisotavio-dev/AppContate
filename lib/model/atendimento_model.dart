import 'package:hive/hive.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';

part 'atendimento_model.g.dart';

@HiveType(typeId: 3)
class Atendimento extends HiveObject {
  @HiveField(0)
  Cliente? cliente;
  @HiveField(1)
  String? idUsuario;
  @HiveField(2)
  DateTime? dataLancamento;
  @HiveField(3)
  String? descricao;
  @HiveField(4)
  bool? atendeu;
}
