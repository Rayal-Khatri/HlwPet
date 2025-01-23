// home_page.dart
import 'package:flutter/material.dart';
import 'package:frontend/Models/owner_profile_models.dart';
import 'package:frontend/Pages/Community/list_community.dart';
import 'package:frontend/Utils/appConstants.dart';
import 'package:frontend/Widgets/bottom_navigation_bar.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/Models/post_model.dart';

class VisitProfile extends StatefulWidget {
  const VisitProfile({super.key, required this.title, required userId});

  final String title;

  @override
  State<VisitProfile> createState() => VisitProfileState();
}

class VisitProfileState extends State<VisitProfile> {
  List<PetOwnerProfile> ownProfile = [];
  bool isLoading = true;
  late String user;
  String appBarTitle = '';
  List<PostModel> posts = [];

  Future<void> _fetchProfileData() async {
    try {
      const String baseUrl = "${AppConstants.BASE_URL}"; //${widget.userId}
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
          print(response.body);
          if (responseData is List) {
            ownProfile = responseData.map((profile) {
              return PetOwnerProfile.fromJson(profile);
            }).toList();
          } else if (responseData is Map<String, dynamic>) {
            ownProfile = [
              PetOwnerProfile.fromJson(responseData),
            ];
          }

          user = ownProfile.isNotEmpty ? ownProfile[0].user.username : '';
          appBarTitle = "$user's Profile";

          setState(() {
            isLoading = false;
          });
        } else {
          throw Future.error('Failed to load profile: ${response.statusCode}');
        }
      } else {
        print('Access token is null');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: appBarTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildProfilePicture(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildUserInfo(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _FollowSection(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildPetsSection(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CommunityList()),
                );
              },
              child: const Text('View Community List'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildProfilePicture() {
    return _buildPostImage(ownProfile.isNotEmpty ? ownProfile[0].photo : '');
  }

  Widget _buildUserInfo() {
    final profile = ownProfile.isNotEmpty ? ownProfile[0] : null;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (profile != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          profile.user.firstName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                            width:
                                4), // Add spacing between first name and last name
                        Text(
                          profile.user.lastName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(), // Make first name and last name stick to the start
                        SizedBox(
                          width: 80, // Adjust the button size as needed
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => Follow(
                              //     ),
                              //   ),
                              // );
                            },
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 4),
                                Text('Follow'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      profile.user.username,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              'About Me',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              profile.bio,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _FollowSection() {
    // final profile = ownProfile.isNotEmpty ? ownProfile[0] : null;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Following:  57',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Followers:  49',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Pets:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (ownProfile.isNotEmpty && ownProfile[0].pets.isNotEmpty)
          ...ownProfile[0].pets.map((pet) => _buildPetSegment(pet)),
      ],
    );
  }

  Widget _buildPetSegment(Pet pet) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPetPicture(pet.petphoto),
          Text(
            'Pet Name: ${pet.name}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'Species: ${pet.species}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Breed: ${pet.breed}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Age: ${pet.age}',
            style: const TextStyle(fontSize: 16),
          ),
          // You can add more pet details as needed
        ],
      ),
    );
  }

  Widget _buildPetPicture(imgpath) {
    return _buildProfileImage(imgpath);
  }

  // Widget _buildPostsSection(List<PostModel> posts) {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       border: Border(bottom: BorderSide(color: Colors.grey)),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             'Posts:',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 8),
  //           for (var post in posts)
  //             GestureDetector(
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => PostDetailScreen(
  //                       postTitle: post.description,
  //                       postContent:
  //                           "${post.createdAt.year}-${post.createdAt.month}-${post.createdAt.day}",
  //                       imagePath: post.imageUrl,
  //                     ),
  //                   ),
  //                 );
  //               },
  //               child: _buildPostPreview(
  //                 post.description,
  //                 post.createdAt,
  //                 post.imageUrl,
  //                 post.author[0].username,
  //               ),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildPostPreview(
  //   String postTitle,
  //   DateTime createdAt,
  //   String imagePath,
  //   String author,
  // ) {
  //   String formattedDate =
  //       "${createdAt.year}-${createdAt.month}-${createdAt.day}";

  //   return Container(
  //     padding: const EdgeInsets.all(16.0),
  //     margin: const EdgeInsets.symmetric(vertical: 10.0),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.blueGrey, width: 2.0),
  //       borderRadius: BorderRadius.circular(10.0),
  //       color: Colors.grey[200],
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.25),
  //           spreadRadius: 2,
  //           blurRadius: 5,
  //           offset: const Offset(0, 3),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           postTitle,
  //           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           formattedDate,
  //           style: const TextStyle(fontSize: 14, color: Colors.grey),
  //         ),
  //         const SizedBox(height: 8),
  //         _buildPostImage(imagePath),
  //       ],
  //     ),
  //   );
  // }

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
