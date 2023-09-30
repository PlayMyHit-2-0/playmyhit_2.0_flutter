import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget{
  final String city;
  final String country;
  final String state;
  final String intro;
  const ProfileInfo({
    super.key,
    required this.city,
    required this.country,
    required this.state,
    required this.intro
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20)
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white38,
        height: 200,
        child: Column(
          children: [
            Row(
              children:[
                const Text("Location",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )
                ),
                const SizedBox(width: 20,),
                Text("$city, $state")
              ]
            ),
            Row(
              children:[
                const Text("Country",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )
                ),
                const SizedBox(width: 20,),
                Text(country)
              ]
            ),
            const SizedBox(height: 20,),
            Row(
              children:[
                const Text("Bio",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )
                ),
                const SizedBox(width: 20,),
                Flexible(
                  child: Text(
                    intro,
                    maxLines: 5,
                    overflow: TextOverflow.fade,
                  )  
                )
              ]
            )
          ],
        )
      ),
    );
  }
}