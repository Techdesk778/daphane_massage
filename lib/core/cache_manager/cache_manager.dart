import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../exceptions/sever_exception.dart';


class CacheManager {
  // Singleton Pattern implementation
  CacheManager._privateConstructor();
  static final CacheManager instance = CacheManager._privateConstructor();

  SharedPreferences? _prefs;

  /// Call this inside main.dart during application boot phase initialization
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Read dynamic primitive values (String, int, double, bool) safely from disk
  T? readKey<T>(String key) {
    if (_prefs == null) throw const CacheException("CacheManager has not been initialized. Call init() first.");
    try {
      return _prefs!.get(key) as T?;
    } catch (e) {
      debugPrint("Error reading key '$key' from cache: $e");
      throw const CacheException();
    }
  }

  /// Writes primitive data variations or custom serializable objects dynamically to storage
  Future<bool> writeKey(String key, dynamic value) async {
    if (_prefs == null) throw const CacheException("CacheManager has not been initialized.");
    try {
      if (value is String) return await _prefs!.setString(key, value);
      if (value is int) return await _prefs!.setInt(key, value);
      if (value is bool) return await _prefs!.setBool(key, value);
      if (value is double) return await _prefs!.setDouble(key, value);
      if (value is Map || value is List) {
        // Automatically serialize JSON maps/lists down to string structures safely
        return await _prefs!.setString(key, jsonEncode(value));
      }
      throw Exception("Unsupported value data type provided to storage runtime pipeline.");
    } catch (e) {
      debugPrint("Error writing key '$key' to cache: $e");
      throw const CacheException();
    }
  }

  /// Reads a cached JSON map string structure and maps it back into a standard Dart key-value Map
  Map<String, dynamic>? readJsonMap(String key) {
    final String? rawString = readKey<String>(key);
    if (rawString == null) return null;
    try {
      return jsonDecode(rawString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint("Error parsing cached JSON map string alignment data values: $e");
      return null;
    }
  }

  /// Clears a specific key string from the device cache layer
  Future<bool> clearKey(String key) async {
    if (_prefs == null) return false;
    return await _prefs!.remove(key);
  }

  /// Wipes out all stored cache on log out
  Future<bool> clearAllCache() async {
    if (_prefs == null) return false;
    return await _prefs!.clear();
  }
}