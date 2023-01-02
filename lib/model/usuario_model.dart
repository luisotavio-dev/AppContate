import 'package:hive/hive.dart';

part 'usuario_model.g.dart';

@HiveType(typeId: 0)
class Usuario extends HiveObject {
  @HiveField(0)
  String? idUsuario;
  @HiveField(1)
  String? nome;
  @HiveField(2)
  String? senha;
}
