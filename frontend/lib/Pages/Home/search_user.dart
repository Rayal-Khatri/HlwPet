import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/Pages/Home/visit_profile.dart';
import 'package:frontend/Utils/appConstants.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:frontend/Widgets/bottom_navigation_bar.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/Models/searched_user.dart'; // import your UserProfile model

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<UserProfile> _userProfiles = [];

  Future<void> _performSearch(String searchTerm) async {
    String apiUrl = '${AppConstants.BASE_URL}/search_user';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'searchTerm': searchTerm},
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 202) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        List<dynamic> profiles = responseData['profiles'];

        _userProfiles =
            profiles.map((profile) => UserProfile.fromJson(profile)).toList();

        print(_userProfiles);
        setState(() {});
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Search',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final searchTerm = _searchController.text;
                if (searchTerm.isNotEmpty) {
                  _performSearch(searchTerm);
                }
              },
              child: const Text('Search'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _userProfiles.length,
                itemBuilder: (context, index) {
                  final profile = _userProfiles[index];
                  return UserCard(
                    profile: profile,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitProfile(
                            title: profile.user.username,
                            userId: profile.profileId),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class UserCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onPressed;

  const UserCard({super.key, required this.profile, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.user.username,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${profile.user.firstName} ${profile.user.lastName} from ${profile.address}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
