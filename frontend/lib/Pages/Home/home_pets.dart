import 'package:flutter/material.dart';
import 'package:frontend/Pages/Home/Pets_to_adopt.dart';
import 'package:frontend/Utils/Colors.dart';
import 'package:frontend/Utils/dimentions.dart';
import 'package:frontend/Widgets/Big_texts123.dart';
import 'package:frontend/Widgets/Small_texts.dart';

class MainPetPage extends StatefulWidget {
  const MainPetPage({super.key});

  @override
  State<MainPetPage> createState() => _MainPetPageState();
}

class _MainPetPageState extends State<MainPetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //Location
          Container(
            child: Container(
              margin: EdgeInsets.only(
                  top: Dimensions.height45, bottom: Dimensions.height15),
              padding: EdgeInsets.only(
                  left: Dimensions.height20, right: Dimensions.height20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.height15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      BigText(
                        text: "Nepal",
                        color: AppColors.mainColor,
                      ),
                      Row(
                        children: [
                          SmallText(
                            text: "Lalitpur",
                            color: Colors.black54,
                            size: 8,
                          ),
                          const Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 10,
                          )
                        ],
                      ),
                    ],
                  ),
                  Center(
                      child: Container(
                    width: Dimensions.height45,
                    height: Dimensions.height45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.height15),
                      color: AppColors.mainColor,
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: Dimensions.height24,
                    ),
                  ))
                ],
              ),
            ),
          ),
          //Sliders
          const Expanded(
              child: SingleChildScrollView(
            child: PetAdoptChoices(),
          )),
        ],
      ),
    );
  }
}
