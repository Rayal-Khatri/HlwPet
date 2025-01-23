import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key, required int community_id});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
      ),
      body: Column(
        children: [
          // Create Post Container
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create a New Post',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.edit),
              ],
            ),
          ),
          // Community Posts
          Expanded(
            child: ListView.builder(
              itemCount: communityPosts.length,
              itemBuilder: (context, index) {
                return CommunityPostCard(post: communityPosts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityPost {
  final String title;
  final String username;
  final String content;
  final String imageUrl;

  CommunityPost({
    required this.title,
    required this.username,
    required this.content,
    required this.imageUrl,
  });
}

class CommunityPostCard extends StatelessWidget {
  final CommunityPost post;

  const CommunityPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            post.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Posted by ${post.username}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  post.content,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(icon: Icons.thumb_up, label: 'Upvote'),
                    _buildActionButton(icon: Icons.comment, label: 'Comment'),
                    _buildActionButton(icon: Icons.share, label: 'Share'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

List<CommunityPost> communityPosts = [
  CommunityPost(
    title: 'Exciting News!',
    username: 'user123',
    content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
    imageUrl: 'https://www.pinterest.com/pin/21251429480747181/',
  ),
  CommunityPost(
    title: 'New Pet Photos!',
    username: 'petlover45',
    content: 'Check out these adorable pictures of my pets! 🐾',
    imageUrl: 'https://www.pinterest.com/pin/21251429480747181/',
  ),
  CommunityPost(
    title: 'Tech Talk',
    username: 'techguru',
    content:
        'Discussing the latest trends in technology. What are your thoughts?',
    imageUrl: 'https://www.pinterest.com/pin/21251429480747181/',
  ),
];
