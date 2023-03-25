import 'package:background_app/data/api/app_conifg.dart';
import 'package:background_app/data/api/graphql_api_client.dart';
import 'package:get/get.dart';

void setUpClient(String token) {
  final appConfig =
      AppConfig(baseUrl: 'https://api.iaffirmdaily.com/graphql', token: token);

  GraphQLApiClient client = GraphQLApiClient(appConfig);
  if (Get.isRegistered<GraphQLApiClient>()) {
    Get.delete<GraphQLApiClient>();
  }

  Get.put<GraphQLApiClient>(client);
}
