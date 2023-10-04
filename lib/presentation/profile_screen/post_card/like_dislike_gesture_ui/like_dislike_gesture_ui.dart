import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LikeDislikeGestureUI extends StatefulWidget {
  const LikeDislikeGestureUI({super.key});

  @override
  State<StatefulWidget> createState() {
    return LikeDislikeGestureUIState();
  }
  
}

class LikeDislikeGestureUIState extends State<LikeDislikeGestureUI> {
  double startYPos = 0;
  double endYPos = 0;
  double likeHeight = 50;

  Widget slider() => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Container(
      height: 100,
      width: 50,
      color: Colors.red,
      child: Stack(
        children: [
          LayoutBuilder(
            builder:(context, constraints) {
              if(likeHeight > constraints.maxHeight){
                likeHeight = constraints.maxHeight;
              }
              return AnimatedContainer(
                color: Colors.brown,
                height: likeHeight,
                duration: Duration.zero,
              );
            },
          ),
        ],
      )
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("🔥", style: TextStyle(fontSize: 30)),
        GestureDetector(
          onVerticalDragStart:(details){
            startYPos = details.localPosition.dy;
            if(kDebugMode){
              print(startYPos);
            }
          },
          onVerticalDragUpdate: (details){
            if(kDebugMode){
              print("endYPos : $endYPos units");
              print("DeltaYPos : ${startYPos - endYPos} units");
            }
            setState((){
              endYPos = details.localPosition.dy;
              likeHeight = endYPos > 0 ? endYPos : 0;
            });
          
          },
          onVerticalDragEnd: (details){
            if(kDebugMode){
              double finalYDelta = startYPos - endYPos;
              // likeHeight = likeHeight + finalYDelta > 0 ? likeHeight + finalYDelta : 0;
              if(finalYDelta > 0) {
                print("Swiped Up");
              }else if(finalYDelta < 0){
                print("Swiped Down");
              }
            }
          },
          child: slider()
            //   const Text("💩", style: TextStyle(fontSize: 30))
            // ],
          // ),
        ),
        const Text("💩", style: TextStyle(fontSize: 30)),

      ]
    );
  }
}


          
