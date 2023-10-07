import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  final String? imageUrl;
  final bool isRounded;
  const CustomCachedImage(
      {Key? key, required this.imageUrl, this.isRounded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isRounded
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            imageBuilder: (context, imageProvider) => Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(100.0),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
            errorWidget: (context, url, error) =>CircleAvatar(
              backgroundImage: Image.asset(
                                      "lib/assets/images/profile.png").image,
              radius: 25,
            ),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl!,
            imageBuilder: (context, imageProvider) => Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: Theme.of(context).secondaryHeaderColor, width: 3.0),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: Theme.of(context).secondaryHeaderColor, width: 3.0),
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              backgroundImage: Image.asset(
                                      "lib/assets/images/profile.png").image,
              radius: 25,
            ),
          );
  }
}
