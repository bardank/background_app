import 'dart:developer';
import 'dart:math';

import 'package:background_app/data/api/graphql_api_client.dart';
import 'package:background_app/data/modal/affirmation_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import "package:gql/language.dart" as lang;
import "package:gql/ast.dart" as ast;


class AffirmationController extends GetxController {
  List<Affirmation> affirmations = <Affirmation>[].obs;

  Future<List<Affirmation>?> queryAffirmation(
      {required Map<String, dynamic> variables,
      bool includeCustomAfirmation = false,
      FetchPolicy fetchPolicy = FetchPolicy.cacheAndNetwork}) async {
    final ast.DocumentNode query = lang.parseString(r"""
    query FetchAffirmations($fetchAffirmationsInput: FetchAffirmationInput!) {
      fetchAffirmations(fetchAffirmationsInput: $fetchAffirmationsInput) {
        _id
        caption
        createdAt
        subTitle
        type
        youtubeAudio
        youtubeVideo
      }
    }
    """);

    GraphQLApiClient client = Get.find<GraphQLApiClient>();
    QueryResult result = await client.query(query,
        variables: variables, fetchPolicy: FetchPolicy.cacheAndNetwork);

    if (result.data != null) {
      List<Affirmation> affirmations =
          AffirmationData.fromJson(result.data as Map<String, dynamic>)
              .fetchAffirmations;

     
      return affirmations;
    }
  
    return null;
  }

  

 

  
}
