import 'package:get/get.dart';
import 'package:frontend/Data/API/API_Client.dart';
import 'package:frontend/Utils/appConstants.dart';

class ShelterRepo extends GetxService {
  final ApiClient apiClient;
  ShelterRepo({required this.apiClient});

  Future<Response> getShelterList() async {
    return await apiClient.getData(AppConstants.SHELTER_URL);
  }
}
