import 'package:flutter/material.dart';
import 'Pages/Home/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(), // Pass the title here (title: 'Pet App')
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:frontend/Controllers/Popular_product_controller.dart';
// import 'package:frontend/Controllers/Shelter_controller.dart';
// import 'package:frontend/Pages/Home/home_pets.dart';
// import 'package:frontend/breeddt/breed_detection.dart';
// import 'Helper/Dependencies.dart' as dep;
// import 'Routes/route_helper.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dep.init();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.This is testing
//   @override
//   Widget build(BuildContext context) {
//     Get.find<PopularProductController>().getPopularProductList();
//     Get.find<ShelterController>().getShelterList();
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Hello Pet',
//       home: BreedDetectionPage(),
//       initialRoute: RouteHelper.initial,
//       getPages: RouteHelper.routes,
//     );
//     //AdoptionPetDetails
//     //SymptomAnalysis
//     //MainPetPage
//   }
// }
