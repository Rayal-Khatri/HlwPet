import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../Utils/appConstants.dart';
import '../Widgets/appbar.dart';

class ResultPage extends StatefulWidget {
  String initialBreed;
  String accuracy;
  File? initialImage;

  ResultPage({
    super.key,
    required this.initialBreed,
    required this.accuracy,
    required this.initialImage,
  });

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late String breed;
  late File? image;

  var appBarTitle = 'Dog Breed Result';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    breed = widget.initialBreed;
    image = widget.initialImage;
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      maxHeight: 300,
      maxWidth: 300,
    );

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        _uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (image == null) {
      // Handle case when no image is selected
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.BASE_URL}/breed_detection/detection'),
      );
      request.headers['Content-Type'] = 'multipart/form-data';
      request.files
          .add(await http.MultipartFile.fromPath('image', image!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(await response.stream.bytesToString());

        String newBreed = jsonResponse['prediction_result']['breed'];
        String accuracy =
            jsonResponse['prediction_result']['accuracy'].toString();

        // Update the breed and accuracy values
        setState(() {
          breed = newBreed;
          widget.accuracy = accuracy;
        });
      } else {
        print('Failed to detect breed. Status code: ${response.statusCode}');
        print(await response.stream.bytesToString());
      }
    } catch (e) {
      print('Error during image upload: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(title: appBarTitle),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            height: size.height * 0.4,
            width: size.width,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image != null
                      ? Image.file(image!).image
                      : const AssetImage("assets/Images/dogphoto.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.35,
            height: size.height * 0.65,
            width: size.width,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36.0),
                  topRight: Radius.circular(36.0),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    breed.isNotEmpty ? breed : "Breed Not found",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.accuracy.isNotEmpty ? widget.accuracy : '%'} Accuracy",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 90,
                  ),
                  if (isLoading)
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImageButton(
    IconData icon,
    Color color,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            side: const BorderSide(width: 2, color: Colors.grey),
            padding: const EdgeInsets.all(16.0),
          ),
          onPressed: onPressed,
          child: Icon(
            icon,
            size: 35,
            color: color,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        )
      ],
    );
  }
}
