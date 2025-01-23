import 'package:flutter/material.dart';
import 'package:frontend/Widgets/bottom_navigation_bar.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:frontend/breeddt/breed_detection.dart';

import '../Symptoms/Symptom_Analysis.dart';
import 'Pets_to_adopt.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Features',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureBox(
                  context,
                  Icons.healing,
                  'Symptom Analysis',
                  const SymptomAnalysis(),
                ),
                _buildFeatureBox(
                  context,
                  Icons.pets,
                  'Breed Detection',
                  const BreedDetectionPage(),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureBox(
                  context,
                  Icons.home,
                  'Adoption and Shelter',
                  const PetAdoptChoices(),
                ),
                _buildFeatureBox(
                  context,
                  Icons.notifications,
                  'Scheduling',
                  const SchedulingScreen(),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildFeatureBox(
    BuildContext context,
    IconData icon,
    String text,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        width: 160.0, // Increased width for a better aspect ratio
        height: 160.0, // Increased height for a better aspect ratio
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(
              20.0), // Increased border radius for a softer look
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: Colors.blue,
            ),
            const SizedBox(
                height: 12.0), // Increased spacing between icon and text
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0), // Added padding for text
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center, // Center-aligned the text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Replace these with your actual screen widgets
class SymptomAnalysisScreen extends StatelessWidget {
  const SymptomAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Symptom Analysis')),
      body: const Center(child: Text('Symptom Analysis Screen')),
    );
  }
}

class BreedDetectionScreen extends StatelessWidget {
  const BreedDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Breed Detection')),
      body: const Center(child: Text('Breed Detection Screen')),
    );
  }
}

class AdoptionScreen extends StatelessWidget {
  const AdoptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adoption and Shelter')),
      body: const Center(child: Text('Adoption and Shelter Screen')),
    );
  }
}

class SchedulingScreen extends StatelessWidget {
  const SchedulingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scheduling')),
      body: const Center(child: Text('Scheduling Screen')),
    );
  }
}
