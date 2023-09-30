import 'package:flutter/material.dart';

class AdvertisementUnit extends StatelessWidget {
  const AdvertisementUnit({super.key});

  @override 
  Widget build(BuildContext context){
    return _advertisementUnit(context);
  }
}

Container _advertisementUnit(BuildContext context) => Container(
  height: MediaQuery.of(context).size.height * 0.2, //20% of the view's height
  width: MediaQuery.of(context).size.height * 0.2, // 20% of the view's height
  color: Colors.black38,
  child: const Icon(Icons.ad_units)
);