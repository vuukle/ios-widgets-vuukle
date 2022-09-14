//
//  Utils.swift
//  Vuukle
//
//  Created by Garnik Ghazaryan on 25.03.22.
//

import Foundation

class Utils {
    class UserDefaultsManager {
        static func saveValue(string: String, key: String) {
            UserDefaults.standard.set(string, forKey: key)
            UserDefaults.standard.synchronize()
        }

        static func getValue(for key: String) -> String? {
            UserDefaults.standard.value(forKey: key) as? String
        }

        static func removeValue(for key: String) {
            UserDefaults.standard.removeObject(forKey: key)
        }

        static func saveCodableValue<T: Codable>(_ value: T, key: String) {
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(value) else { return }
            UserDefaults.standard.set(data, forKey: key)
        }

        static func getCodableValue<T: Codable>(key: String) -> T? {
            let decoder = JSONDecoder()
            guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
            return try? decoder.decode(T.self, from: data)
        }
    }

    static func addUniqueObserver(observer: Any, selector: Selector, name: NSNotification.Name, object: Any?) {
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }
}
