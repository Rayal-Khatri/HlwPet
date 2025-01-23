import 'package:flutter/material.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:frontend/Models/post_model.dart';
import 'package:frontend/Utils/appConstants.dart';
import 'package:frontend/Widgets/bottom_navigation_bar.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PostModel> posts = [];
  bool isLoading = true;
  String appBarTitle = 'New Feeds';

  Future<void> _handleUpvote(int postId) async {
    try {
      const String baseUrl = "${AppConstants.BASE_URL}/posts/";
      final String? accessToken = await getAccessToken();

      if (accessToken != null) {
        var response = await http.post(
          Uri.parse('$baseUrl/upvote/$postId'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 201) {
          print('Upvoted successfully');
        } else if (response.statusCode == 400 &&
            response.body.contains('Already upvoted')) {
          print('Already upvoted');
        } else {
          throw Future.error('Failed to upvote post: ${response.statusCode}');
        }
      } else {
        print('Access token is null');
      }
    } catch (e) {
      print('Error during upvote: $e');
    }
  }

  Future<void> fetchPosts() async {
    try {
      const String baseUrl = "${AppConstants.BASE_URL}/posts";
      final String? accessToken = await getAccessToken();

      if (accessToken != null) {
        var response = await http.get(
          Uri.parse(baseUrl),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          dynamic responseData = jsonDecode(response.body);
          print(responseData);

          if (responseData is List<dynamic>) {
            posts = responseData.map((jsonPost) {
              return PostModel.fromJson(jsonPost);
            }).toList();

            setState(() {
              isLoading = false;
            });
          } else {
            throw Future.error('Invalid response format');
          }
        } else {
          throw Future.error('Failed to load posts: ${response.statusCode}');
        }
      } else {
        print('Access token is null');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: CustomAppBar(title: appBarTitle),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hot Posts',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              viewPosts(),
              const SizedBox(height: 16),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }

  Widget viewPosts() {
    return Column(
      children: posts.map((post) => _buildPostCard(post)).toList(),
    );
  }

  Widget _buildPostCard(PostModel post) {
    // Retrieve createdAt from the post object
    DateTime createdAt = post.createdAt;

    return Card(
      margin: const EdgeInsets.all(8.0),
      color: const Color.fromARGB(255, 160, 209, 233),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.author.isNotEmpty
                      ? post.author.first.username.toUpperCase()
                      : '',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MMMM d, y').format(createdAt),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  post.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 176, 227, 226),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      post.description,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(
                      icon: Icons.thumb_up,
                      label: 'Upvote',
                      onTap: () {
                        _handleUpvote(
                            post.id); // Make sure _handleUpvote is implemented
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.comment,
                      label: 'Comment',
                      onTap: () {
                        // Implement the comment action
                        // _handleComment(post.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildPostImage(String imagePath) {
    return SizedBox(
      height: 200, // Set a fixed height or adjust accordingly
      child: _buildImage(imagePath),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return AspectRatio(
        aspectRatio: 16 / 10,
        child: CachedNetworkImage(
          imageUrl: imagePath,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.fill,
        ),
      );
    } else if (imagePath.startsWith('images')) {
      // Local asset image
      return AspectRatio(
        aspectRatio: 16 / 10,
        child: Image.asset(
          imagePath,
          fit: BoxFit.fill,
        ),
      );
    } else {
      return Container(
        color: Colors.grey,
        child: const Center(
          child: Text('Unsupported image source'),
        ),
      );
    }
  }
}
