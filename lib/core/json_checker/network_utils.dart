import 'dart:convert';
import 'package:flutter/material.dart';

class NetworkUtils {
  /// Validates if a given string is a securely formatted JSON object or array.
  /// Prevents unexpected parsing crashes from HTML error pages or bad data gateways.
  static bool isValidJson(String source) {
    if (source.trim().isEmpty) return false;
    try {
      final decoded = jsonDecode(source);
      return decoded is Map<String, dynamic> || decoded is List;
    } catch (e) {
      debugPrint("JSON Validation Failure: $e");
      return false;
    }
  }

  /// Safely attempts to decode a JSON string, returning null instead of throwing an unhandled exception on failure.
  static Map<String, dynamic>? tryDecodeJson(String source) {
    if (!isValidJson(source)) return null;
    try {
      return jsonDecode(source) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}