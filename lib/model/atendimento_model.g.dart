// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atendimento_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AtendimentoAdapter extends TypeAdapter<Atendimento> {
  @override
  final int typeId = 3;

  @override
  Atendimento read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Atendimento()
      ..cliente = fields[0] as Cliente?
      ..idUsuario = fields[1] as String?
      ..dataLancamento = fields[2] as DateTime?
      ..descricao = fields[3] as String?
      ..atendeu = fields[4] as bool?;
  }

  @override
  void write(BinaryWriter writer, Atendimento obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.cliente)
      ..writeByte(1)
      ..write(obj.idUsuario)
      ..writeByte(2)
      ..write(obj.dataLancamento)
      ..writeByte(3)
      ..write(obj.descricao)
      ..writeByte(4)
      ..write(obj.atendeu);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AtendimentoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
