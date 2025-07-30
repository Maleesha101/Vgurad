import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:vguard/models/disease_info.dart';
import 'package:vguard/models/medicine.dart';
import 'package:vguard/models/prediction_response.dart';

class DiseaseScanService {
  static const String _baseUrl = "http://4.224.250.251";

  // Method to predict disease from an image
  Future<PredictionResponse> predictDisease(dynamic imageData) async {
    final uri = Uri.parse('$_baseUrl/predict');
    var request = http.MultipartRequest('POST', uri);

    if (imageData is File) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageData.path,
          contentType: MediaType('image', 'png'),
        ),
      );
    } else if (imageData is Uint8List) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageData,
          filename: 'image.png',
          contentType: MediaType('image', 'png'),
        ),
      );
    } else {
      throw Exception(
        'Unsupported image data type. Expected File or Uint8List.',
      );
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        return PredictionResponse.fromJson(jsonResponse);
      } else {
        final errorBody = await response.stream.bytesToString();
        throw Exception(
          'Failed to predict disease: ${response.statusCode} - $errorBody',
        );
      }
    } catch (e) {
      print('Error predicting disease: $e');
      throw Exception('Error predicting disease: $e');
    }
  }

  // Method to get specific disease information
  Future<DiseaseInfo> getDiseaseInfo(String diseaseName) async {
    final uri = Uri.parse('$_baseUrl/disease-info/$diseaseName');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return DiseaseInfo.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Failed to load disease info: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error getting disease info: $e'); // For debugging
      throw Exception('Error getting disease info: $e');
    }
  }

  // Method to get recommended medicines for a disease
  Future<MedicineResponse> getRecommendedMedicines(String diseaseName) async {
    final uri = Uri.parse('$_baseUrl/disease-medicines?name=$diseaseName');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return MedicineResponse.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Failed to load medicines: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error getting recommended medicines: $e');
      throw Exception('Error getting recommended medicines: $e');
    }
  }
}
