import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:racoon_tech_panel/src/dto/version_dto.dart';

class CheckVersionRepository {

  static final api = dotenv.env['API'];

  static Future<bool?> hasNewVersion() async {
    try {
      final String endpoint = api! + '/version.php';
      final response = await Dio().get(endpoint);
      final version = VersionDTO.fromJson(response.data);

      if(version.currentVersion != dotenv.env['VERSION']) {
        debugPrint('New version available');
        return true;
      } else {
        debugPrint('No new version available');
        return false;
      }

    } catch(e) {
      debugPrint('Error checking version: $e');
    }

  }
  
}