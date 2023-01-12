import 'package:hive/hive.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';

part 'agendamento_model.g.dart';

@HiveType(typeId: 4)
class Agendamento extends HiveObject {
  @HiveField(0)
  Cliente? cliente;
  @HiveField(1)
  DateTime? dataLancamento;
  @HiveField(2)
  DateTime? dataAgendamento;
  @HiveField(3)
  String? descricao;
}
