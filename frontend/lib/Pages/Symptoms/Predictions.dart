import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:frontend/Utils/Heading_text.dart';

import '../../Widgets/appbar.dart';

class PredictionScreen extends StatelessWidget {
  final List<dynamic> predictions;

  const PredictionScreen({super.key, required this.predictions});

  @override
  Widget build(BuildContext context) {
    print(predictions); // Print predictions in the terminal
    var appBarTitle = 'Predictions';

    return Scaffold(
      appBar: CustomAppBar(title: appBarTitle),
      body: ListView.builder(
        itemCount: predictions.length,
        itemBuilder: (context, index) {
          final prediction = predictions[index];
          final disease = prediction['Disease'];
          final accuracy = prediction['Probability'];
          final accuracyPercentage = (accuracy * 100).toStringAsFixed(1);

          return Column(
            children: [
              ListTile(
                title: SymptomsTitle(text: "$disease :"),
              ),
              CircularPercentIndicator(
                radius: 200,
                lineWidth: 25,
                backgroundColor: const Color.fromARGB(255, 122, 179, 232),
                percent: accuracy, // Ensure accuracy is between 0 and 1
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  "$accuracyPercentage%", // Display the percentage with % symbol
                  style: const TextStyle(fontSize: 45, color: Colors.blue),
                ),
                progressColor: Colors.blue[700],
                animation: true,
                animationDuration: 1000,
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // Navigate back to the previous screen
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
