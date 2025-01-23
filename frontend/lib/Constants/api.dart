// final String api = 'http://10.0.2.2:8000/profile/';

import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = "http://127.0.0.1:8000/";

class Profile {
  final String baseUrl = "http://127.0.0.1:8000/";
  Future<List<dynamic>> getProfile() async {
    try {
      var response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> dataList = jsonDecode(response.body);
        return dataList;
      } else {
        throw Future.error('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Future.error('Failed to load profile: $e');
    }
  }
}

//   Future<void> getProfile() async {
//     try {
//       var response = await http.get(Uri.parse(baseUrl));
//       final List<dynamic> dataList = jsonDecode(response.body);
//       final List<Map<String, dynamic>> data =
//           dataList.cast<Map<String, dynamic>>();
//       for (var profile in data) {
//         ownProfile.add(PetOwnerProfile.fromMap(profile));
//       }
//       print(ownProfile.length);
//     } catch (e) {
//       throw Future.error('Failed to load profile: $e');
//     }
//   }
// }


      // if (response.statusCode == 200) {
      //   final List<dynamic> dataList = jsonDecode(response.body);
      //   final List<Map<String, dynamic>> data =
      //       dataList.cast<Map<String, dynamic>>();
            
      //   return data;
      // } else {
      //   final Map<String, dynamic> errorData = jsonDecode(response.body);
      //   return Future.error('Failed to load profile: ${errorData["detail"]}');
      // }

