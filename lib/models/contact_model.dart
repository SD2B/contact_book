import 'package:freezed_annotation/freezed_annotation.dart';
part '../gen/contact_model.freezed.dart';
part '../gen/contact_model.g.dart';

@freezed
class ContactModel with _$ContactModel {
  const factory ContactModel({
    int? id,
    String? name,
   @JsonKey(name: "group_name") String? group,
    String? phone,
    String? email,
    String? image,
  }) = _ContactModel;

  factory ContactModel.fromJson(Map<String, dynamic> json) => _$ContactModelFromJson(json);
}


