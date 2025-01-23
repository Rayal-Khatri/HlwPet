import 'package:frontend/Controllers/Popular_product_controller.dart';
import 'package:frontend/Controllers/Shelter_controller.dart';
import 'package:frontend/Data/API/API_Client.dart';
import 'package:get/get.dart';
import 'package:frontend/Data/Repository/Popular_Pet_repo.dart';
import 'package:frontend/Data/Repository/Shelter_repo.dart';
import 'package:frontend/Utils/appConstants.dart';

Future<void> init() async {
  //api clients
  Get.lazyPut(() => ApiClient(appBaseURL: AppConstants.BASE_URL));

  //repo
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => ShelterRepo(apiClient: Get.find()));

  //controller
  Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()));
  Get.lazyPut(() => ShelterController(shelterRepo: Get.find()));
}
