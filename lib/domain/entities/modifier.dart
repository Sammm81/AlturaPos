import 'package:freezed_annotation/freezed_annotation.dart';

part 'modifier.freezed.dart';
part 'modifier.g.dart';

@freezed
class Modifier with _$Modifier {
  const factory Modifier({
    required String id,
    required String name,
    required double price,
    required String category,
  }) = _Modifier;

  factory Modifier.fromJson(Map<String, dynamic> json) => _$ModifierFromJson(json);
}
