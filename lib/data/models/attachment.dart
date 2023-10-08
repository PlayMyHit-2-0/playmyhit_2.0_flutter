import 'dart:io';

import 'package:playmyhit/data/enumerations/attachment_type.dart';

class Attachment {
  final AttachmentType? attachmentType;
  String? attachmentUrl;
  late final File? attachmentFile;

  Attachment(File? file,{required this.attachmentType, required this.attachmentUrl}){
    attachmentFile = file;
  }

  Map<String,dynamic> toJson() => {
    "attachment_type" : attachmentType,
    "attachment_url" : attachmentUrl ?? ""
  };

  Attachment.fromJson(Map<String, dynamic> json)
      : attachmentType = json['attachment_type'],
        attachmentUrl = json['attachment_url'];

}