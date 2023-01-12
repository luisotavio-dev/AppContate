// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agendamento_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgendamentoAdapter extends TypeAdapter<Agendamento> {
  @override
  final int typeId = 4;

  @override
  Agendamento read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Agendamento()
      ..cliente = fields[0] as Cliente?
      ..dataLancamento = fields[1] as DateTime?
      ..dataAgendamento = fields[2] as DateTime?
      ..descricao = fields[3] as String?;
  }

  @override
  void write(BinaryWriter writer, Agendamento obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.cliente)
      ..writeByte(1)
      ..write(obj.dataLancamento)
      ..writeByte(2)
      ..write(obj.dataAgendamento)
      ..writeByte(3)
      ..write(obj.descricao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgendamentoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
