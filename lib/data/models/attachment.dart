import 'package:playmyhit/data/enumerations/attachment_type.dart';

class Attachment {
  final AttachmentType attachmentType;
  final String attachmentUrl;
  Attachment({required this.attachmentType, required this.attachmentUrl});


  Map<String,dynamic> toJson() => {
    "attachment_type" : attachmentType,
    "attachment_url" : attachmentUrl
  };

}