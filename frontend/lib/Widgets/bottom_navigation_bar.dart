import 'package:flutter/material.dart';
import 'package:frontend/Pages/Community/create_community.dart';
import 'package:frontend/Pages/Home/feature_page.dart';
import 'package:frontend/Pages/Home/home_page.dart';
import 'package:frontend/Pages/Home/owner_profile.dart';
import 'package:frontend/Pages/Home/search_user.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home, color: Colors.green, size: 24.0),
        ),
        BottomNavigationBarItem(
          label: 'Search',
          icon: Icon(Icons.search_off_rounded, color: Colors.grey, size: 24.0),
        ),
        BottomNavigationBarItem(
          label: 'Create',
          icon: Icon(Icons.add_outlined, color: Colors.grey, size: 24.0),
        ),
        BottomNavigationBarItem(
          label: 'Features',
          icon: Icon(Icons.widgets,
              color: Colors.grey, size: 24.0), // New icon for Features
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.person, color: Colors.grey, size: 24.0),
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Search()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommunityApplicationPage()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const FeaturesPage()), // Navigate to FeaturesPage
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const OwnerProfile(title: 'Profile')),
            );
            break;
        }
      },
    );
  }
}
