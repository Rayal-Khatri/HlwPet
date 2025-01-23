import 'package:flutter/material.dart';

class ProfileContainer extends StatelessWidget {
  final int user;
  final String phone_number;
  final String address;
  final List<dynamic> pet_info;

  const ProfileContainer(
      {super.key,
      required this.user,
      required this.phone_number,
      required this.address,
      required this.pet_info});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Column(
          children: [
            Text(
              address,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
