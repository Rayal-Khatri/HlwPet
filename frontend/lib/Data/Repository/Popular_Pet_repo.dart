import 'package:get/get.dart';
import 'package:frontend/Data/API/API_Client.dart';
import 'package:frontend/Utils/appConstants.dart';

class PopularProductRepo extends GetxService {
  final ApiClient apiClient;
  PopularProductRepo({required this.apiClient});

  Future<Response> getPopularProductList() async {
    return await apiClient.getData(AppConstants.ADOPT_PET_URL);
  }
}
