import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/Controllers/Popular_product_controller.dart';
import 'package:frontend/Routes/route_helper.dart';
import 'package:frontend/Utils/Colors.dart';
import 'package:frontend/Utils/appConstants.dart';
import 'package:frontend/Utils/dimentions.dart';
import 'package:frontend/Widgets/App_icon.dart';
import 'package:frontend/Widgets/Big_texts123.dart';
import 'package:frontend/Widgets/Expandable_text.dart';

class AdoptionPetDetails extends StatelessWidget {
  final int pageID;
  const AdoptionPetDetails({super.key, required this.pageID});

  @override
  Widget build(BuildContext context) {
    var dog = Get.find<PopularProductController>().popularProductList[pageID];
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.getInitial());
                  },
                  child: const AppIcon(icon: Icons.clear),
                ),
                const AppIcon(
                  icon: Icons.catching_pokemon,
                  iconColor: AppColors.mainColor,
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Container(
                padding: EdgeInsets.only(
                    top: Dimensions.height10 / 2, bottom: Dimensions.height10),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.height20),
                    topRight: Radius.circular(Dimensions.height20),
                  ),
                ),
                child: Center(
                    child:
                        BigText(size: Dimensions.TextSize26, text: dog.name)),
              ),
            ),
            pinned: true,
            backgroundColor: AppColors.mainColor,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "${AppConstants.BASE_URL}${AppConstants.ADOPT_PET_URL}/" +
                    dog.img,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: Dimensions.height20, right: Dimensions.height20),
                  child: ExpandableTextWidget(text: dog.personality),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: Dimensions.BottomHeightBar,
        padding: EdgeInsets.only(
            top: Dimensions.height30,
            bottom: Dimensions.height30,
            left: Dimensions.height20,
            right: Dimensions.height20),
        decoration: BoxDecoration(
            color: AppColors.buttonBackgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.height20),
                topRight: Radius.circular(Dimensions.height20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.only(
                    top: Dimensions.height20,
                    bottom: Dimensions.height20,
                    left: Dimensions.height10,
                    right: Dimensions.height10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.height20),
                    color: Colors.white),
                child: AppIcon(
                  icon: Icons.favorite,
                  iconColor: AppColors.mainColor,
                  iconSize: Dimensions.height30,
                )),
            Container(
              padding: EdgeInsets.only(
                top: Dimensions.height20,
                bottom: Dimensions.height20,
                left: Dimensions.height20,
                right: Dimensions.height20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.height20),
                color: AppColors.mainColor,
              ),
              child: BigText(
                size: 18,
                text: "Fill Adoption Form",
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
