import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/Utils/appConstants.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/Pages/Symptoms/Predictions.dart';
import 'package:frontend/Utils/loading_popup.dart';
import 'package:frontend/Data/Dataset/load_dataset.dart';
import 'package:frontend/Utils/Heading_text.dart';
import 'package:frontend/Utils/Symptoms_dropdown.dart';
import 'package:frontend/Utils/Symptoms_list.dart';

import '../../Widgets/appbar.dart';

class SymptomAnalysis extends StatefulWidget {
  const SymptomAnalysis({super.key});

  @override
  _SymptomAnalysis createState() => _SymptomAnalysis();
}

class _SymptomAnalysis extends State<SymptomAnalysis> {
  List<String> symptoms = [];
  List<String> selectedSymptoms = [];
  bool isLoading = false;
  var appBarTitle = 'Symptom Analysis';

  @override
  void initState() {
    super.initState();
    loadSymptoms();
  }

  Future<void> loadSymptoms() async {
    List<String> loadedSymptoms = await loadDataset();
    setState(() {
      symptoms = loadedSymptoms;
      symptoms = symptoms.toSet().toList(); // Filter out repeating symptoms
    });
  }

  void onRemoveSymptom(String symptom) {
    setState(() {
      selectedSymptoms.remove(symptom);
    });
  }

  void predictDiseases() async {
    setState(() {
      isLoading = true;
    });

    final jsonData = {
      "test_data": selectedSymptoms,
    };
    final jsonString = jsonEncode(jsonData);
    print(jsonString);

    try {
      final response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}/symptom/Predict'),
        body: jsonString,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PredictionScreen(predictions: responseData),
          ),
        );
        Navigator.pop(context);
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: appBarTitle),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SymptomsTitle(
              text: "The Symptoms Are:",
            ),
            const SizedBox(height: 8.0),
            SymptomDropdown(
              hint: 'Select Symptoms',
              value: null,
              symptoms: symptoms,
              onChanged: (String? selectedSymptom) {
                setState(() {
                  if (selectedSymptom != null) {
                    if (!selectedSymptoms.contains(selectedSymptom)) {
                      selectedSymptoms.add(selectedSymptom);
                    }
                  }
                });
              },
            ),
            const SizedBox(height: 16.0),
            SymptomsTitle(text: "Selected Symptoms:"),
            const SizedBox(height: 8.0),
            selectedSymptoms.isNotEmpty
                ? SymptomList(
                    selectedSymptoms: selectedSymptoms,
                    onRemove: onRemoveSymptom,
                  )
                : const Text('No symptoms selected'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedSymptoms.isNotEmpty) {
            showDialog(
              context: context,
              barrierDismissible: false, // Prevent dismissing during loading
              builder: (BuildContext context) {
                return const LoadingPopup(); // This will dismiss the loading dialog
                // Show loading popup while predicting
              },
            );
            predictDiseases();
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Please enter a symptom'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: isLoading
            ? const CircularProgressIndicator()
            : const Icon(Icons.check),
      ),
    );
  }
}
