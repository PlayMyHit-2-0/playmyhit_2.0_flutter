import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:playmyhit/data/enumerations/poopometer_layout_direction.dart';
import 'package:playmyhit/data/enumerations/poopometer_swipe_direction.dart';

class LikeDislikeGestureUI extends StatefulWidget {
  const LikeDislikeGestureUI({super.key, required this.onSlideStart, required this.onSlideUpdate, required this.onSlideEnd, required this.layoutDirection, required this.value});

  final Function(double) onSlideStart;
  final Function(double) onSlideUpdate;
  final Function(PoopometerSwipeDirection) onSlideEnd;
  final PoopometerLayoutDirection layoutDirection;
  final double value;

  @override
  State<StatefulWidget> createState() {
    return LikeDislikeGestureUIState();
  }
  
}




class LikeDislikeGestureUIState extends State<LikeDislikeGestureUI> {
  double startPos = 0;
  double endPos = 0;
  double? likeAmount;

  Widget _verticalSlider() => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Container(
      height: 100,
      width: widget.value,
      color: Colors.red,
      child: Stack(
        children: [
          LayoutBuilder(
            builder:(context, constraints) {
              if(widget.value > constraints.maxHeight){
                likeAmount = constraints.maxHeight;
              }
              return AnimatedContainer(
                color: Colors.brown,
                height: likeAmount,
                duration: Duration.zero,
              );
            },
          ),
        ],
      )
    ),
  );

  Widget _verticalSliderWithDetector() => Column(
    children: [
      const Text("🔥", style: TextStyle(fontSize: 30)),
      GestureDetector(
        onVerticalDragStart:(details){
          startPos = details.localPosition.dy;
        },
        onVerticalDragUpdate: (details){
          setState((){
            endPos = details.localPosition.dy;
            likeAmount = endPos > 0 ? endPos > 100 ? 100 : endPos : 0;
          });
          // Notify the parent widget of the update.
          widget.onSlideUpdate(likeAmount!);
        },
        onVerticalDragEnd: (details){
          if(kDebugMode){
            double finalYDelta = startPos - endPos;
            if(finalYDelta > 0) {
              widget.onSlideEnd(PoopometerSwipeDirection.up);
            }else if(finalYDelta < 0){
              widget.onSlideEnd(PoopometerSwipeDirection.down);
            }
          }
        },
        child: _verticalSlider()
      ),
      const Text("💩", style: TextStyle(fontSize: 30)),
    ]
  );

  Widget _horizontalSlider() => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Container(
      width: 100,
      height: 30,
      color: Colors.brown,
      child: Stack(
        children: [
          LayoutBuilder(
            builder:(context, constraints) {
              if(likeAmount! > constraints.maxWidth){
                likeAmount = constraints.maxWidth;
                widget.onSlideUpdate(likeAmount!);
              }
              return AnimatedContainer(
                color: Colors.red,
                width: likeAmount,
                duration: Duration.zero,
              );
            },
          ),
        ],
      )
    ),
  );


  Widget _horizontalSliderWithDetector() =>  SizedBox(
    width: 200,
    child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("💩", style: TextStyle(fontSize: 30)),
          GestureDetector(
            onHorizontalDragStart:(details){
              startPos = details.localPosition.dx;
            },
            onHorizontalDragUpdate: (details){
              setState((){
                endPos = details.localPosition.dx;
                likeAmount = endPos > 0 ? endPos : 0;
              });
              widget.onSlideUpdate(likeAmount!);
            },
            onHorizontalDragEnd: (details){
              if(kDebugMode){
                double finalXDelta = startPos - endPos;
                if(finalXDelta > 0) {
                  widget.onSlideEnd(PoopometerSwipeDirection.left);
                }else if(finalXDelta < 0){
                  widget.onSlideEnd(PoopometerSwipeDirection.right);
                }
              }
            },
            child: _horizontalSlider()
          ),
          const Text("🔥", style: TextStyle(fontSize: 30)),
        ]
      ),
  );

  @override
  Widget build(BuildContext context) {
    likeAmount ??= widget.value;
    return widget.layoutDirection == PoopometerLayoutDirection.vertical ? _verticalSliderWithDetector() : _horizontalSliderWithDetector();
  }
}


          
