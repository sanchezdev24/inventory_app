import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let CHANNEL = "com.inventory_app/native_storage"
    private let KEY_SAVED_ITEMS = "saved_items"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller = window?.rootViewController as! FlutterViewController
        let nativeChannel = FlutterMethodChannel(
            name: CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )

        nativeChannel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }

            switch call.method {
            case "saveItem":
                if let args = call.arguments as? [String: Any],
                   let itemJson = args["item"] as? String {
                    let savedItem = self.saveItem(itemJson: itemJson)
                    result(savedItem)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT",
                                        message: "Item cannot be null",
                                        details: nil))
                }

            case "getItems":
                let items = self.getItems()
                result(items)

            case "getItemById":
                if let args = call.arguments as? [String: Any],
                   let itemId = args["itemId"] as? String {
                    let item = self.getItemById(itemId: itemId)
                    result(item)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT",
                                        message: "ItemId cannot be null",
                                        details: nil))
                }

            case "updateItem":
                if let args = call.arguments as? [String: Any],
                   let itemJson = args["item"] as? String {
                    let updatedItem = self.updateItem(itemJson: itemJson)
                    result(updatedItem)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT",
                                        message: "Item cannot be null",
                                        details: nil))
                }

            case "deleteItem":
                if let args = call.arguments as? [String: Any],
                   let itemId = args["itemId"] as? String {
                    let success = self.deleteItem(itemId: itemId)
                    result(success)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT",
                                        message: "ItemId cannot be null",
                                        details: nil))
                }

            case "clearItems":
                let success = self.clearItems()
                result(success)

            case "isProductSaved":
                if let args = call.arguments as? [String: Any],
                   let productId = args["productId"] as? Int {
                    let isSaved = self.isProductSaved(productId: productId)
                    result(isSaved)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT",
                                        message: "ProductId cannot be null",
                                        details: nil))
                }

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - Helper Methods

    private func getItemsArray() -> [[String: Any]] {
        guard let itemsString = UserDefaults.standard.string(forKey: KEY_SAVED_ITEMS),
              let data = itemsString.data(using: .utf8),
              let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            return []
        }
        return jsonArray
    }

    private func saveItemsArray(_ items: [[String: Any]]) -> Bool {
        guard let data = try? JSONSerialization.data(withJSONObject: items),
              let jsonString = String(data: data, encoding: .utf8) else {
            return false
        }
        UserDefaults.standard.set(jsonString, forKey: KEY_SAVED_ITEMS)
        return UserDefaults.standard.synchronize()
    }

    // MARK: - Native Storage Methods

    private func saveItem(itemJson: String) -> String? {
        guard let data = itemJson.data(using: .utf8),
              let newItem = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }

        var items = getItemsArray()
        items.append(newItem)

        if saveItemsArray(items) {
            return itemJson
        }
        return nil
    }

    private func getItems() -> String {
        return UserDefaults.standard.string(forKey: KEY_SAVED_ITEMS) ?? "[]"
    }

    private func getItemById(itemId: String) -> String? {
        let items = getItemsArray()

        for item in items {
            if let id = item["id"] as? String, id == itemId {
                guard let data = try? JSONSerialization.data(withJSONObject: item),
                      let jsonString = String(data: data, encoding: .utf8) else {
                    return nil
                }
                return jsonString
            }
        }
        return nil
    }

    private func updateItem(itemJson: String) -> String? {
        guard let data = itemJson.data(using: .utf8),
              let updatedItem = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let itemId = updatedItem["id"] as? String else {
            return nil
        }

        var items = getItemsArray()

        for (index, item) in items.enumerated() {
            if let id = item["id"] as? String, id == itemId {
                items[index] = updatedItem
                if saveItemsArray(items) {
                    return itemJson
                }
                return nil
            }
        }
        return nil
    }

    private func deleteItem(itemId: String) -> Bool {
        var items = getItemsArray()
        let initialCount = items.count

        items.removeAll { item in
            (item["id"] as? String) == itemId
        }

        if items.count < initialCount {
            return saveItemsArray(items)
        }
        return false
    }

    private func clearItems() -> Bool {
        UserDefaults.standard.removeObject(forKey: KEY_SAVED_ITEMS)
        return UserDefaults.standard.synchronize()
    }

    private func isProductSaved(productId: Int) -> Bool {
        let items = getItemsArray()

        return items.contains { item in
            (item["productId"] as? Int) == productId
        }
    }
}