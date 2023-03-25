// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'affirmation_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LikedAffirmationAdapter extends TypeAdapter<LikedAffirmation> {
  @override
  final int typeId = 13;

  @override
  LikedAffirmation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LikedAffirmation(
      id: fields[0] as String?,
      createdAt: fields[1] as DateTime?,
      affirmation: fields[2] as Affirmation?,
      updatedAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LikedAffirmation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.affirmation)
      ..writeByte(3)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LikedAffirmationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AffirmationAdapter extends TypeAdapter<Affirmation> {
  @override
  final int typeId = 10;

  @override
  Affirmation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Affirmation(
      id: fields[0] as String,
      caption: fields[1] as String,
      createdAt: fields[2] as DateTime,
      subTitle: fields[3] as String?,
      type: fields[4] as String,
      youtubeAudio: fields[5] as String?,
      youtubeVideo: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Affirmation obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.caption)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.subTitle)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.youtubeAudio)
      ..writeByte(6)
      ..write(obj.youtubeVideo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AffirmationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
