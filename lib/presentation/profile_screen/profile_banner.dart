import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileBanner extends StatelessWidget {
  final String profileBannerUrl;
  final String profilePictureUrl;
  final String username;
  const ProfileBanner({
    super.key, 
    required this.profileBannerUrl,
    required this.profilePictureUrl,
    required this.username
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 250,
          width: MediaQuery.of(context).size.width,
          // child: Image.network(
          //   profileBannerUrl,
          //   fit: BoxFit.cover,
          //   errorBuilder: (context, error, stackTrace) => const CircularProgressIndicator(),
          // ),
          child: CachedNetworkImage(
            imageUrl: profileBannerUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(color: Colors.redAccent),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
        ),
        Positioned(
          top: 30,
          left: (MediaQuery.of(context).size.width / 2) - (140 / 2),
          child: Center(
            child: SizedBox(
              height: 140,
              width: 140,
              child: CircleAvatar(
                backgroundImage: Image.network(profilePictureUrl).image,
                onBackgroundImageError: (exception, stackTrace) => const CircularProgressIndicator(),
              ),
            )
          ),
        ),
        Positioned(
          left: (MediaQuery.of(context).size.width / 2) - (300 / 2),
          bottom: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 30,
              width: 300,
              color: Colors.white,
              child: Center(child: Text(username, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))
            )
          )
        )
      ]
    );
  }
}