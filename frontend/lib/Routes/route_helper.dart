import 'package:get/get.dart';
import 'package:frontend/Pages/Home/home_pets.dart';
import 'package:frontend/Pages/Shelters/Popular_Shelthers_page.dart';
import '../Pages/Shelters/Adoption_Pet_Details.dart';

class RouteHelper {
  static const String initial = '/';
  static const String Shelters = "/shelter";
  static const String Dogs = "/Dogs";

  static String getInitial() => initial;
  static String getShelter(int pageID) => '$Shelters?pageID=$pageID';
  static String getDogs(int pageID) => '$Dogs?pageID=$pageID';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const MainPetPage()),
    GetPage(
        name: Shelters,
        page: () {
          var pageID = Get.parameters['pageID'];
          return PopularShelter(pageID: int.parse(pageID!));
        },
        transition: Transition.fadeIn),
    GetPage(
        name: Dogs,
        page: () {
          var pageID = Get.parameters['pageID'];
          return AdoptionPetDetails(pageID: int.parse(pageID!));
        },
        transition: Transition.fadeIn),
  ];
}
