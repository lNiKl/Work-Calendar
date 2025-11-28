// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WorkDay.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkDayAdapter extends TypeAdapter<WorkDay> {
  @override
  final int typeId = 0;

  @override
  WorkDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkDay(
      date: fields[0] as DateTime,
      type: fields[1] as DayType,
      hours: fields[2] as double,
      hourlyRate: fields[3] as double,
      notes: fields[4] as String?,
      isPaid: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WorkDay obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.hours)
      ..writeByte(3)
      ..write(obj.hourlyRate)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.isPaid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DayTypeAdapter extends TypeAdapter<DayType> {
  @override
  final int typeId = 1;

  @override
  DayType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DayType.work;
      case 1:
        return DayType.weekend;
      case 2:
        return DayType.vacation;
      case 3:
        return DayType.sick;
      default:
        return DayType.work;
    }
  }

  @override
  void write(BinaryWriter writer, DayType obj) {
    switch (obj) {
      case DayType.work:
        writer.writeByte(0);
        break;
      case DayType.weekend:
        writer.writeByte(1);
        break;
      case DayType.vacation:
        writer.writeByte(2);
        break;
      case DayType.sick:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
