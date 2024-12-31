import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:racoon_tech_panel/src/Model/version_dto.dart';
import 'package:racoon_tech_panel/src/ViewModel/utils/request.dart';

class CheckVersionRepository {

  static final api = dotenv.env['API'];

  static Future<bool?> hasNewVersion() async {
    try {
      final String endpoint = '${api!}/version.php';
      final request = requestInterceptor();
      final response = await request.get(endpoint);
      final version = VersionDTO.fromJson(response.data);

      debugPrint('Version from API: ${version.currentVersion}');
      debugPrint('Version from .env: ${dotenv.env['VERSION']}');

      if(version.currentVersion.trim() != dotenv.env['VERSION']!.trim()) {
        debugPrint('New version available');
        return true;
      } else {
        debugPrint('No new version available');
        return false;
      }

    } catch(e) {
      debugPrint('Error checking version: $e');
    }
    return null;

  }
  
}