// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'space_model.g.dart';

@JsonSerializable()
class LMChatSpaceModel {
  final String name;
  final String description;
  final String imageUrl;
  final String id;
  final bool isPinned;
  bool isJoined;
  final int members;
  final int messages;

  LMChatSpaceModel({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.id,
    required this.isPinned,
    required this.members,
    required this.messages,
    this.isJoined = false,
  });

  factory LMChatSpaceModel.fromJson(Map<String, dynamic> json) =>
      _$SpaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpaceModelToJson(this);
}
