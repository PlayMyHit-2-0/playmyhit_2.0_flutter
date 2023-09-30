import 'package:flutter/material.dart';
import 'package:playmyhit/presentation/post_screen/new_post_ui/advertisement_unit.dart';

class AdvertisementArea extends StatelessWidget {
  const AdvertisementArea({super.key});

  @override
  Widget build(BuildContext context){
    return _advertisementArea(context);
  }
}

SingleChildScrollView _advertisementArea(BuildContext context) => const SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Sponsored Ads"),
      Row(
        children: [
          AdvertisementUnit(),
          AdvertisementUnit(),
          AdvertisementUnit()
        ]
      ),
    ],
  )
);
