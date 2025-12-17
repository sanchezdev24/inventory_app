package com.example.inventory_app

import android.content.Context
import android.content.SharedPreferences
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.inventory_app/native_storage"
    private val PREFS_NAME = "inventory_app_prefs"
    private val KEY_SAVED_ITEMS = "saved_items"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveItem" -> {
                    val itemJson = call.argument<String>("item")
                    if (itemJson != null) {
                        val savedItem = saveItem(itemJson)
                        result.success(savedItem)
                    } else {
                        result.error("INVALID_ARGUMENT", "Item cannot be null", null)
                    }
                }
                "getItems" -> {
                    val items = getItems()
                    result.success(items)
                }
                "getItemById" -> {
                    val itemId = call.argument<String>("itemId")
                    if (itemId != null) {
                        val item = getItemById(itemId)
                        result.success(item)
                    } else {
                        result.error("INVALID_ARGUMENT", "ItemId cannot be null", null)
                    }
                }
                "updateItem" -> {
                    val itemJson = call.argument<String>("item")
                    if (itemJson != null) {
                        val updatedItem = updateItem(itemJson)
                        result.success(updatedItem)
                    } else {
                        result.error("INVALID_ARGUMENT", "Item cannot be null", null)
                    }
                }
                "deleteItem" -> {
                    val itemId = call.argument<String>("itemId")
                    if (itemId != null) {
                        val success = deleteItem(itemId)
                        result.success(success)
                    } else {
                        result.error("INVALID_ARGUMENT", "ItemId cannot be null", null)
                    }
                }
                "clearItems" -> {
                    val success = clearItems()
                    result.success(success)
                }
                "isProductSaved" -> {
                    val productId = call.argument<Int>("productId")
                    if (productId != null) {
                        val isSaved = isProductSaved(productId)
                        result.success(isSaved)
                    } else {
                        result.error("INVALID_ARGUMENT", "ProductId cannot be null", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getPreferences(): SharedPreferences {
        return getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    }

    private fun getItemsArray(): JSONArray {
        val itemsString = getPreferences().getString(KEY_SAVED_ITEMS, "[]") ?: "[]"
        return try {
            JSONArray(itemsString)
        } catch (e: Exception) {
            JSONArray()
        }
    }

    private fun saveItemsArray(jsonArray: JSONArray): Boolean {
        return try {
            val editor = getPreferences().edit()
            editor.putString(KEY_SAVED_ITEMS, jsonArray.toString())
            editor.apply()
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun saveItem(itemJson: String): String? {
        return try {
            val newItem = JSONObject(itemJson)
            val itemsArray = getItemsArray()
            itemsArray.put(newItem)
            saveItemsArray(itemsArray)
            itemJson
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun getItems(): String {
        return try {
            getPreferences().getString(KEY_SAVED_ITEMS, "[]") ?: "[]"
        } catch (e: Exception) {
            e.printStackTrace()
            "[]"
        }
    }

    private fun getItemById(itemId: String): String? {
        return try {
            val itemsArray = getItemsArray()
            for (i in 0 until itemsArray.length()) {
                val item = itemsArray.getJSONObject(i)
                if (item.getString("id") == itemId) {
                    return item.toString()
                }
            }
            null
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun updateItem(itemJson: String): String? {
        return try {
            val updatedItem = JSONObject(itemJson)
            val itemId = updatedItem.getString("id")
            val itemsArray = getItemsArray()

            for (i in 0 until itemsArray.length()) {
                val item = itemsArray.getJSONObject(i)
                if (item.getString("id") == itemId) {
                    itemsArray.put(i, updatedItem)
                    saveItemsArray(itemsArray)
                    return itemJson
                }
            }
            null
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun deleteItem(itemId: String): Boolean {
        return try {
            val itemsArray = getItemsArray()
            val newArray = JSONArray()
            var found = false

            for (i in 0 until itemsArray.length()) {
                val item = itemsArray.getJSONObject(i)
                if (item.getString("id") != itemId) {
                    newArray.put(item)
                } else {
                    found = true
                }
            }

            if (found) {
                saveItemsArray(newArray)
            }
            found
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun clearItems(): Boolean {
        return try {
            val editor = getPreferences().edit()
            editor.remove(KEY_SAVED_ITEMS)
            editor.apply()
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun isProductSaved(productId: Int): Boolean {
        return try {
            val itemsArray = getItemsArray()
            for (i in 0 until itemsArray.length()) {
                val item = itemsArray.getJSONObject(i)
                if (item.getInt("productId") == productId) {
                    return true
                }
            }
            false
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}