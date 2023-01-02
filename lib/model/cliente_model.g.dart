// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClienteAdapter extends TypeAdapter<Cliente> {
  @override
  final int typeId = 1;

  @override
  Cliente read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cliente()
      ..idCliente = fields[0] as String?
      ..idUsuario = fields[1] as int?
      ..nome = fields[2] as String?
      ..agencia = fields[3] as int?
      ..conta = fields[4] as int?
      ..dataLancamento = fields[5] as DateTime?
      ..telefone1 = fields[6] as String?
      ..telefone2 = fields[7] as String?;
  }

  @override
  void write(BinaryWriter writer, Cliente obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.idCliente)
      ..writeByte(1)
      ..write(obj.idUsuario)
      ..writeByte(2)
      ..write(obj.nome)
      ..writeByte(3)
      ..write(obj.agencia)
      ..writeByte(4)
      ..write(obj.conta)
      ..writeByte(5)
      ..write(obj.dataLancamento)
      ..writeByte(6)
      ..write(obj.telefone1)
      ..writeByte(7)
      ..write(obj.telefone2);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClienteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
