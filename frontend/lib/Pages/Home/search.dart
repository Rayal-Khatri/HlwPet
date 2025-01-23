import 'package:flutter/material.dart';
import 'package:frontend/Utils/appConstants.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/Models/owner_profile_models.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  List<User> searchResults = [];

  Future<List<User>> searchUsers(String query) async {
    final response = await http
        .get(Uri.parse('${AppConstants.BASE_URL}/search/?query=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['users'];
      return data.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  void performSearch(String query) async {
    try {
      List<User> results = await searchUsers(query);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print('Error searching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Search Users',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) => performSearch(query),
              decoration: const InputDecoration(
                labelText: 'Search users',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final user = searchResults[index];
                return ListTile(
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text('@${user.username}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
