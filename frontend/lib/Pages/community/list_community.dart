import 'package:flutter/material.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:frontend/Models/community_list.dart';
import 'package:frontend/Pages/Community/community_home.dart';
import 'package:frontend/Utils/appConstants.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:frontend/Widgets/bottom_navigation_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CommunityList extends StatefulWidget {
  const CommunityList({super.key});

  @override
  State<CommunityList> createState() => _CommunityListState();
}

class _CommunityListState extends State<CommunityList> {
  List<CommunityListModel> communities = [];
  String appBarTitle = 'Your Community';

  @override
  void initState() {
    super.initState();
    fetchCommunities();
  }

  Future<void> fetchCommunities() async {
    final String? accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('${AppConstants.BASE_URL}/community/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      final List<CommunityListModel> communityList = data.map((communityData) {
        return CommunityListModel.fromJson(communityData);
      }).toList();

      setState(() {
        communities = communityList;
      });
    } else {
      // Handle error
      print('Failed to fetch communities: ${response.statusCode}');
    }
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
            const SizedBox(height: 16),
            SizedBox(
              height: 500,
              width: 500,
              child: ListView.builder(
                itemCount: communities.length,
                itemBuilder: (context, index) {
                  return CommunityCard(
                    community: communities[index],
                    onPressed: () =>
                        navigateToCommunityProfile(communities[index].id),
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

  void navigateToCommunityProfile(int communityId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityProfilePage(communityId: communityId),
      ),
    );
  }
}

class CommunityCard extends StatelessWidget {
  final CommunityListModel community;
  final VoidCallback onPressed;

  const CommunityCard({super.key, required this.community, required this.onPressed});

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
                community.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
