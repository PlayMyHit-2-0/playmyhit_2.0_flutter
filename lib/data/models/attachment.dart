import 'dart:io';

import 'package:playmyhit/data/enumerations/attachment_type.dart';

class Attachment {
  AttachmentType? attachmentType;
  String? attachmentUrl;
  File? attachmentFile;
  String? attachmentThumbnailUrl;
  String? attachmentTitle;

  Attachment(File? file,{required this.attachmentType, required this.attachmentUrl}){
    attachmentFile = file;
  }

  Map<String,dynamic> toJson() => {
    "attachment_type" : attachmentType.toString(),
    "attachment_url" : attachmentUrl ?? ""
  };

  Attachment.fromJson(Map<String, dynamic> json){
    AttachmentType type = AttachmentType.values.where((at)=>at.toString() == json['attachment_type']).first;
    // print("Attachment type: ${type.name}");
    attachmentType = type;
    attachmentUrl = json['attachment_url'];
  }

}