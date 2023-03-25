import 'package:background_app/data/api/app_conifg.dart';
import 'package:background_app/data/api/logger_api_client.dart';
import 'package:flutter/material.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

class GraphQLApiClient {
  GraphQLApiClient(AppConfig config)
      : graphQLClient = ValueNotifier<GraphQLClient>(
          GraphQLClient(
            cache: GraphQLCache(store: InMemoryStore()),
            link: HttpLink(
              config.baseUrl,
              httpClient: LoggerHttpClient(http.Client()),
              defaultHeaders: {"Authorization": config.token},
            ),
          ),
        );

  final ValueNotifier<GraphQLClient> graphQLClient;

  Future<QueryResult> query(DocumentNode query,
      {required Map<String, dynamic> variables,
      FetchPolicy? fetchPolicy}) async {
    final QueryResult result = await graphQLClient.value.query(QueryOptions(
        document: query,
        variables: variables,
        fetchPolicy: fetchPolicy ?? FetchPolicy.cacheAndNetwork));

    if (result.exception != null) {
      print(result.exception);
      for (final GraphQLError error in result.exception!.graphqlErrors) {
        print(error.message);
      }
    }

    return result;
  }

  Future<QueryResult> mutate(
    DocumentNode documentNode, {
    required Map<String, dynamic> variables,
  }) async {
    final QueryResult result = await graphQLClient.value.mutate(MutationOptions(
      document: documentNode,
      variables: variables,
      fetchPolicy: FetchPolicy.networkOnly,
    ));

    print(result.exception);
    if (result.exception != null) {
      for (final GraphQLError error in result.exception!.graphqlErrors) {
        print(error.message);
      }
    }

    return result;
  }

//  void setCookie(Cookie sidCookie) {
//    graphQLClient.value = GraphQLClient(
//        cache: graphQLClient.value.cache,
//        link: HttpLink(
//          httpClient: _httpClient,
//          uri: _appConfig.graphQLBaseUrl,
//          headers: <String, String>{
//            'cookie': 'sid=${sidCookie.value};',
//          },
//        ));
//  }
//
//  void clearCookies() {
//    graphQLClient.value = GraphQLClient(
//      cache: graphQLClient.value.cache,
//      link: HttpLink(
//        uri: _appConfig.graphQLBaseUrl,
//      ),
//    );
//  }
//
//  Future<QueryResult> query(
//    DocumentNode documentNode, {
//    Map<String, dynamic> variables,
//  }) async {
//    final QueryResult result = await graphQLClient.value.query(QueryOptions(
//      documentNode: documentNode,
//      pollInterval: 10,
//      variables: variables,
//    ));
//
//    if (result.exception != null) {
//      // todo error処理
//      for (final GraphQLError error in result.exception.graphqlErrors) {
//        // todo
//        if (error.message == 'U001 NOT_LOGIN') {
//          throw const AppError(
//              code: ErrorCode.NOT_LOGIN_ERROR, cause: 'Token is expired.');
//        }
//      }
//      Log.e(result.exception.toString());
//    }
//
//    return result;
//  }
//

}
