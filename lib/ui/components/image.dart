import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  final String? imageUrl;
  final bool isRounded;
  final double size;
  const CustomCachedImage(
      {Key? key, required this.imageUrl, this.isRounded = false,this.size=50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isRounded
        ? CachedNetworkImage(
            imageUrl: imageUrl ?? "",
            imageBuilder: (context, imageProvider) => Container(
              height: size,
              width: size,
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
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              backgroundImage:
                  Image.asset("lib/assets/images/profile.png").image,
              radius: size/2,
            ),
          )
        : CachedNetworkImage(
            imageUrl: imageUrl ?? "",
            imageBuilder: (context, imageProvider) => Container(
              height: size,
              width: size,
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
            errorWidget: (context, url, error) => Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: Theme.of(context).secondaryHeaderColor, width: 3.0),
                image: DecorationImage(
                  image: Image.asset("lib/assets/images/profile.png").image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
  }
}
