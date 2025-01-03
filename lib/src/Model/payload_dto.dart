import 'package:logger/web.dart';

String PayloadDTO(Map<String, dynamic> payload) {
  String payloadStr = payload
      .entries
      .map((entry) => (entry.value != '') ? '${entry.key}: ${(entry.value is String) ? '"${entry.value}"' : '${entry.value}'}' : null)
      .where((entry) => entry != null)
      .join(', ');

  return payloadStr;
}

String payloadInput(Map<String, dynamic> payload) {
  return payload.entries
      .map((entry) {
       
      })
      .join(', ');
}
