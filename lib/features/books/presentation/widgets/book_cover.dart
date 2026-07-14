import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookCover extends StatelessWidget {
  const BookCover({required this.url, this.width = 88, this.height = 132, super.key});
  final String? url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: SizedBox(
      width: width,
      height: height,
      child: url == null
          ? _placeholder(context)
          : CachedNetworkImage(
              imageUrl: url!,
              fit: BoxFit.cover,
              placeholder: (context, url) => _placeholder(context),
              errorWidget: (context, url, error) => _placeholder(context),
            ),
    ),
  );

  Widget _placeholder(BuildContext context) => ColoredBox(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: const Center(child: Icon(Icons.menu_book_rounded, size: 38)),
  );
}
