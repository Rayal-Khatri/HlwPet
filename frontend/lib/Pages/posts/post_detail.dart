// PostDetailScreen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Widgets/appbar.dart';

class PostDetailScreen extends StatelessWidget {
  final String postTitle;
  final String postContent;
  final String imagePath;

  const PostDetailScreen({super.key, 
    required this.postTitle,
    required this.postContent,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Post Detail View',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              postTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              postContent,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            _buildPostImage(imagePath, context),
          ],
        ),
      ),
    );
  }

  Widget _buildPostImage(String imagePath, BuildContext context) {
    double containerWidthPercentage =
        0.8; // Set your desired percentage (in this example, 80%)

    double containerWidth =
        MediaQuery.of(context).size.width * containerWidthPercentage;
    if (imagePath.startsWith('http')) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: CachedNetworkImage(
          imageUrl: imagePath,
          width: containerWidth,
          fit: BoxFit.fill,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), // Border color
          borderRadius:
              const BorderRadius.all(Radius.circular(10.0)), // Border radius
        ),
        child: Image.asset(
          'images/default_pp.jpg',
          width: containerWidth,
          fit: BoxFit.fill,
        ),
      );
    }
  }
  // Widget _buildPostImage(String imagePath) {
  //   if (imagePath.startsWith('http')) {
  //     return AspectRatio(
  //       aspectRatio: 9 / 10,
  //       child: CachedNetworkImage(
  //         imageUrl: imagePath,
  //         placeholder: (context, url) => const CircularProgressIndicator(),
  //         errorWidget: (context, url, error) => const Icon(Icons.error),
  //         fit: BoxFit.fill,
  //       ),
  //     );
  //   } else if (imagePath.startsWith('images')) {
  //     // Local asset image
  //     return AspectRatio(
  //       aspectRatio: 9 / 10,
  //       child: Image.asset(
  //         imagePath,
  //         fit: BoxFit.fill,
  //       ),
  //     );
  //   } else {
  //     return Container(
  //       color: Colors.grey,
  //       child: const Center(
  //         child: Text('Unsupported image source'),
  //       ),
  //     );
  //   }
  // }
}
