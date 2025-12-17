import 'dart:convert';

import 'package:flutter/services.dart';

import '../error/exceptions.dart';

/// Method Channel for native platform communication
class NativeStorageChannel {
  static const String _channelName = 'com.inventory_app/native_storage';
  static const MethodChannel _channel = MethodChannel(_channelName);

  // Method names
  static const String _saveItem = 'saveItem';
  static const String _getItems = 'getItems';
  static const String _getItemById = 'getItemById';
  static const String _updateItem = 'updateItem';
  static const String _deleteItem = 'deleteItem';
  static const String _clearItems = 'clearItems';
  static const String _isProductSaved = 'isProductSaved';

  /// Save a single item to native storage
  Future<Map<String, dynamic>?> saveItem(Map<String, dynamic> item) async {
    try {
      final jsonString = jsonEncode(item);
      final result = await _channel.invokeMethod<String>(
        _saveItem,
        {'item': jsonString},
      );
      if (result != null && result.isNotEmpty) {
        return jsonDecode(result) as Map<String, dynamic>;
      }
      return null;
    } on PlatformException catch (e) {
      throw CacheException(
        message: 'Error saving item to native storage: ${e.message}',
      );
    }
  }

  /// Get all items from native storage
  Future<List<Map<String, dynamic>>> getItems() async {
    try {
      final result = await _channel.invokeMethod<String>(_getItems);
      if (result == null || result.isEmpty) {
        return [];
      }
      final List<dynamic> decoded = jsonDecode(result);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } on PlatformException catch (e) {
      throw CacheException(
        message: 'Error getting items from native storage: ${e.message}',
      );
    }
  }

  /// Get item by ID from native storage
  Future<Map<String, dynamic>?> getItemById(String itemId) async {
    try {
      final result = await _channel.invokeMethod<String>(
        _getItemById,
        {'itemId': itemId},
      );
      if (result == null || result.isEmpty) {
        return null;
      }
      return jsonDecode(result) as Map<String, dynamic>;
    } on PlatformException catch (e) {
      throw CacheException(
        message: 'Error getting item from native storage: ${e.message}',
      );
    }
  }

  /// Update an existing item
  Future<Map<String, dynamic>?> updateItem(Map<String, dynamic> item) async {
    try {
      final jsonString = jsonEncode(item);
      final result = await _channel.invokeMethod<String>(
        _updateItem,
        {'item': jsonString},
      );
      if (result != null && result.isNotEmpty) {
        return jsonDecode(result) as Map<String, dynamic>;
      }
      return null;
    } on PlatformException catch (e) {
      throw CacheException(
        message: 'Error updating item in native storage: ${e.message}',
      );
    }
  }

  /// Delete a specific item by ID
  Future<bool> deleteItem(String itemId) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        _deleteItem,
        {'itemId': itemId},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      throw CacheException(
        message: 'Error deleting item from native storage: ${e.message}',
      );
    }
  }

  /// Clear all items from native storage
  Future<bool> clearItems() async {
    try {
      final result = await _channel.invokeMethod<bool>(_clearItems);
      return result ?? false;
    } on PlatformException catch (e) {
      throw CacheException(
        message: 'Error clearing native storage: ${e.message}',
      );
    }
  }

  /// Check if a product is already saved
  Future<bool> isProductSaved(int productId) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        _isProductSaved,
        {'productId': productId},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      throw CacheException(
        message: 'Error checking product in native storage: ${e.message}',
      );
    }
  }
}