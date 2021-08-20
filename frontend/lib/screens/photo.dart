import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoArguments {
  final String imageUrl;

  PhotoArguments({
    required this.imageUrl,
  });
}

class Photo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PhotoArguments;
    return Container(
      child: PhotoView(
        imageProvider: NetworkImage(args.imageUrl),
      ),
    );
  }
}
