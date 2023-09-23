import 'package:playmyhit/data/enumerations/attachment_type.dart';

class Attachment {
  AttachmentType? attachmentType;
  String? attachmentUrl;
  Attachment();


  Map<String,dynamic> toJson() => {
    "attachment_type" : attachmentType,
    "attachment_url" : attachmentUrl ?? ""
  };

  Attachment.fromJson(Map<String, dynamic> json)
      : attachmentType = json['attachment_type'],
        attachmentUrl = json['attachment_url'];

}