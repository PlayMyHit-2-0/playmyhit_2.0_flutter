import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/models/attachment.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';
import 'package:playmyhit/presentation/common_widgets/music_item.dart';
import 'package:playmyhit/presentation/common_widgets/video_item.dart';
import 'package:playmyhit/presentation/post_screen/post_ui/add_music_button.dart';
import 'package:playmyhit/presentation/post_screen/post_ui/add_photos_button.dart';
import 'package:playmyhit/presentation/post_screen/post_ui/add_videos_button.dart';
import 'package:playmyhit/presentation/post_screen/post_ui/advertisement_area.dart';
import 'package:playmyhit/presentation/post_screen/post_ui/submit_post_button.dart';

class PostUI extends StatefulWidget {
  final TextEditingController postContentController;
  final List<Attachment>? attachedImageFiles;
  final List<Attachment>? attachedVideoFiles;
  final List<Attachment>? attachedAudioFiles;
  final List<Attachment>? attachedPdfFiles;

  const PostUI({
    super.key, 
    required this.postContentController,
    required this.attachedImageFiles,
    required this.attachedVideoFiles,
    required this.attachedAudioFiles,
    required this.attachedPdfFiles
  });
  
  @override
  State<StatefulWidget> createState() {
    return PostUIState();
  }
}

class PostUIState extends State<PostUI>{

  bool visible = false;

  @override
  void initState() {
    visible = false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PostUI oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
     //In 1 second show it
    Future.delayed(const Duration(milliseconds: 0),(){
      if(mounted){
        setState(() {
          visible = true;
        }); 
      }
    });
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: postUI(
        postContentController: widget.postContentController, 
        context: context,
        imageAttachments: widget.attachedImageFiles, 
        videoAttachments: widget.attachedVideoFiles, 
        audioAttachments: widget.attachedAudioFiles,
        pdfAttachments: widget.attachedPdfFiles
      )
    );
  }
}

Widget postUI(
    {required TextEditingController postContentController,
    required BuildContext context, 
    List<Attachment>? imageAttachments,
    List<Attachment>? videoAttachments,
    List<Attachment>? audioAttachments,
    List<Attachment>? pdfAttachments
    }
) => Scaffold(
    appBar: AppBar(
      title: const Text("New Post"),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          postContentsLabel,
          postContentTextField(postContentController, context),
          Padding(
            padding: const EdgeInsets.all(10),
            child: BlocProvider.value(
              value: BlocProvider.of<PostBloc>(context),
              child: const Row(
                children: [
                  AddPhotosButton(),
                  SizedBox(width: 10),
                  AddVideosButton(),
                  SizedBox(width: 10),
                  AddMusicButton(),
                  Spacer(),
                  SubmitPostButton()
                ]
              )
            ),
          ),
          // Images Attachemnts
          // RepositoryProvider.of<PostsRepository>(context).postAttachments.isNotEmpty ? imagesAttachedLabel : Container(),
          const SizedBox(height: 8),
          imageAttachments != null ? attachedImagesList(imageAttachments, context) : Container(),
          const SizedBox(height: 8),
          videoAttachments != null ? attachedVideosList(videoAttachments, context) : Container(),
          const SizedBox(height: 8),
          audioAttachments != null ? attachedAudioList(audioAttachments, context) : Container(),
          const SizedBox(height: 8),
          // Text(audioAttachments?.length.toString() ?? "audioAttachments null"),
          const AdvertisementArea(),

        ],
      ),
    )
  );

Widget attachedAudioList(List<Attachment> attachments, BuildContext context){
  if(attachments.isNotEmpty){
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 8, right: 8),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: attachments.isNotEmpty ? attachments.map((audio)=>Container(
          margin: const EdgeInsets.only(right: 8),
          // width:/,
          height: 50,
          child: MusicItem(
            inList: false,
            thumbnailUrl: null,
            fileUrl: audio.attachmentUrl,
            name: "${audio.attachmentFile?.path.split("/").last.substring(0,15)}...",
            audioFile: audio.attachmentFile,
          )
        )).toList() : []
      )
    );
  }else{
    return const Text("No audio attached.");
  }
}

Widget attachedVideosList(List<Attachment> attachments, BuildContext context){
    if(attachments.isNotEmpty){
      return SingleChildScrollView(
        padding: const EdgeInsets.only(left:  8, right: 8),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: attachments.isNotEmpty ? attachments.map((video)=>SizedBox(
            width: 200,
            height: 100,
            child: VideoItem(attachment: video,)
          )).toList() : []
        ),
      );
    }else{
      return const Text("No videos attached.");
    }
}

Widget attachedImagesList(List<Attachment>? attachments, BuildContext context) => SingleChildScrollView(
  padding: const EdgeInsets.only(left: 8, right: 8),
  scrollDirection: Axis.horizontal,
  child: Row(
    children: attachments!.isNotEmpty ? attachments.map((currentImageFile) => Container(
      margin: const EdgeInsets.only(right: 8),
      height: 100,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 100,
              width: 100,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.file(currentImageFile.attachmentFile!),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: FloatingActionButton(
              heroTag: currentImageFile.attachmentFile!.path,
              backgroundColor: Colors.redAccent,
              mini: true,
              onPressed: (){
                if(kDebugMode){
                  print("Deleting image.");
                }
                BlocProvider.of<PostBloc>(context).add(PostDeleteAttachmentEvent(selectedAttachmentFile: currentImageFile.attachmentFile!));
              },
              child: const Icon(Icons.delete)
            )
          )
        ]
      )
    )).toList() : [
      const Text("No images attached.")
    ]
  )
);

Widget imagesAttachedLabel = const Row(
  children: [
    Text("Images Attached:", textAlign: TextAlign.start,),
    Spacer(flex: 2),
  ]
);

Widget postContentsLabel = const Row(
  children: [
    Text("Post Contents:", textAlign: TextAlign.start,),
    Spacer(flex: 2),
  ]
);

Widget postContentTextField(TextEditingController postContentController, BuildContext context) =>  TextField(
  controller: postContentController,
  decoration: const InputDecoration(
    hintText: "Write your post here...",
    label: Text("Post")
  ),
  maxLines: 5,
  onChanged: (newValue){
    BlocProvider.of<PostBloc>(context).add(PostUpdatePostContentText(postContentText: newValue)); 
  },
);