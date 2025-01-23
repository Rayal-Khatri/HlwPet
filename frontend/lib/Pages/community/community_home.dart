import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:frontend/Models/community_model.dart';
import 'package:frontend/Models/post_model.dart';
import 'package:frontend/Pages/posts/create_post.dart';
import 'package:frontend/Utils/appConstants.dart';
import 'package:frontend/Widgets/bottom_navigation_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/Widgets/appbar.dart';
import 'package:intl/intl.dart';

class CommunityProfilePage extends StatefulWidget {
  final int communityId;

  const CommunityProfilePage({super.key, required this.communityId});

  @override
  _CommunityProfilePageState createState() => _CommunityProfilePageState();
}

class _CommunityProfilePageState extends State<CommunityProfilePage> {
  CommunityDetail? communityData;
  bool isLoading = true;
  late String community;
  String appBarTitle = '';
  List<PostModel> posts = [];
  @override
  void initState() {
    super.initState();
    fetchCommunity();
    fetchPosts();
  }

  Future<void> fetchCommunity() async {
    final String? accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('${AppConstants.BASE_URL}/community/${widget.communityId}'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      dynamic responseData = json.decode(response.body)['data'];
      print(responseData);

      communityData = CommunityDetail.fromJson(responseData);

      appBarTitle = "${communityData?.name}'s Profile";

      setState(() {});
    } else {
      // Handle error
      print('Failed to fetch community: ${response.statusCode}');
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
          List<dynamic> responseData = jsonDecode(response.body);
          print(responseData);

          posts = responseData.map((jsonpost) {
            return PostModel.fromJson(jsonpost);
          }).toList();

          setState(() {
            isLoading = false;
          });
        } else {
          throw Future.error('Failed to load posts: ${response.statusCode}');
        }
      } else {
        print('Access token is null');
      }
    } catch (e) {
      print('Error fetching posts: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCommunityPicture(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildcommunityInfo(),
                ElevatedButton(
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 4),
                      Text('Join'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Members:'),
            const SizedBox(height: 8),
            if (communityData != null)
              for (int memberId in communityData!.members)
                _buildMemberSegment('User $memberId'),
            const SizedBox(height: 16),
            PostBox(),
            const SizedBox(height: 16),
            const Text(
              'Posts:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            viewPosts(),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildCommunityPicture() {
    return _buildProfileImage(
        communityData?.coverPhoto ?? 'images/default_pp.jpg');
  }

  Widget _buildcommunityInfo() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            communityData?.name ?? '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            communityData?.description ?? '',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          )
        ]));
  }

  Widget _buildMemberSegment(String memberName) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Text(
        memberName,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget PostBox() {
    return GestureDetector(
      onTap: () {
        // Add your navigation logic
        print(widget.communityId);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Create_Post(communityId: communityData!.id)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  "What's on your mind?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Create_Post()),
                // );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 15.0)),
                side: WidgetStateProperty.all(
                  const BorderSide(
                    width: 2.0, // Adjust border width
                    color: Colors.blue,
                  ),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              child: const Text(
                'Create Post',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget viewPosts() {
    return SingleChildScrollView(
      child: Column(
        children: posts.map((post) => _buildPostCard(post)).toList(),
      ),
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
                      onTap: () {},
                    ),
                    _buildActionButton(
                      icon: Icons.comment,
                      label: 'Comment',
                      onTap: () {},
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

  Widget _buildProfileImage(String imagePath) {
    double fixedWidth = 100.0;
    double fixedHeight = 100.0;

    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: fixedWidth,
        height: fixedHeight,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.cover,
      );
    } else if (imagePath.startsWith('images')) {
      // Local asset image
      return Image.asset(
        imagePath,
        width: fixedWidth,
        height: fixedHeight,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'images/default_pp.jpg',
        width: fixedWidth,
        height: fixedHeight,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buildPostImage(String imagePath) {
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
}
