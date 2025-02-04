import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/web.dart';

class FileuploadRepository {

  static Future<FormData> getFormDataOfImages(BuildContext context, String folderPath, String fileName, imagesModel) async {
    // ✅ Initialize FormData
    FormData formData = FormData.fromMap({
      "path": "imgs/products/$folderPath",  // ✅ Correctly add the path field
    });

    // ✅ Web Upload
    if (kIsWeb) {
      formData.files.add(
        MapEntry(
          "file",
          MultipartFile.fromBytes(
            imagesModel.imagesBytes[0],  // ✅ Get image bytes
            filename: "${fileName}.png",
            contentType: MediaType("image", "jpeg"),
          ),
        ),
      );
    }
    // ✅ Mobile Upload (Android/iOS)
    else if ((Platform.isAndroid || Platform.isIOS || Platform.isWindows || Platform.isMacOS || Platform.isLinux) && imagesModel.selectedImages != null && imagesModel.selectedImages!.isNotEmpty) {
      
      List<int> fileBytes = await imagesModel.selectedImages![0].readAsBytes();

      formData.files.add(
        MapEntry(
          "file",
          MultipartFile.fromBytes(
            fileBytes,
            filename: "${fileName}.png",
            contentType: MediaType("image", "jpeg"),
          ),
        ),
      );
    }

    return formData;
  }
  
}