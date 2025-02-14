import 'dart:convert';
import 'dart:io'; // For SocketException
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart'; // Import the http package

import '../../models/PalyerModel.dart';

var logger = Logger();

Future<List<PlayerModel>> fetchPlayerData({int maxRetries = 3}) async {
  int retryCount = 0;

  while (retryCount < maxRetries) {
    try {
      // Request data from the link with a timeout
      final response = await http
          .get(Uri.parse('https://guesstheplayer.site/players_data2.json'))
          .timeout(const Duration(seconds: 20)); // Add a timeout

      if (response.statusCode == 200) {
        logger.i('Data fetched successfully');
        // Check if the response body is empty or null before parsing
        if (response.body.isEmpty) {
          logger.e('Response body is empty.');
          throw Exception('Response body is empty.');
        }
        List<dynamic> jsonResponse = json.decode(response.body);

        // Convert data to a list of PlayerModel
        return jsonResponse.map((data) {
          // Validate each data item
          if (data is! Map<String, dynamic>) {
            throw const FormatException("Invalid JSON format: Expected a map.");
          }
          return PlayerModel.fromJson(data);
        }).toList();
      } else {
        // If the response is not successful
        logger.e('Failed to fetch data: ${response.statusCode}');
        throw Exception('Failed to load player data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Log the error to the console
      logger.e('Error during data fetching: $error');

      // Check if the error is a network-related error
      if (error is SocketException || error is HttpException) {
        retryCount++;
        logger.w('Network error occurred. Retrying ($retryCount/$maxRetries)...');
        await Future.delayed(const Duration(seconds: 2)); // Wait before retrying
      } else {
        // If it's not a network error, rethrow the error to be handled
        //  Example of specific error handling
        if (error is FormatException) {
          // Handle JSON format error
          logger.e('Invalid JSON format: $error');
          throw Exception('Invalid data format received from server.');
        }
        // Re-throw the error if it's not a network error
        throw Exception('Failed to fetch data: $error');
      }
    }
  }

  // If all retries failed
  throw Exception('Failed to fetch data after $maxRetries retries. Check your internet connection.');
}