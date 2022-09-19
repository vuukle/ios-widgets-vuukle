//
//  URL+Extension.swift
//  Vuukle
//
//  Created by Narek Dallakyan on 31.05.22.
//

import Foundation

extension URL {
    mutating func appendParam(name: String, value: String) {
        var components = URLComponents(string: self.absoluteString)
        let item = URLQueryItem(name: name, value: value)
        components?.queryItems?.append(item)
        self = components?.url ?? self
    }

    mutating func removeParam(name: String?, value: String? = nil) {
        var components = URLComponents(string: self.absoluteString)
        if let name = name, let value = value {
            components?.queryItems?.removeAll(where: { $0.name == name && $0.value == value })
        } else if let name = name {
            components?.queryItems?.removeAll(where: { $0.name == name })
        } else if let value = value {
            components?.queryItems?.removeAll(where: { $0.value == value })
        }
        self = components?.url ?? self
    }

    mutating func appendParams(params: [URLQueryItem]) {
        if !params.isEmpty {
            params.forEach { appendParam(name: $0.name, value: $0.value ?? "") }
        }
    }

    mutating func removeParams(names: [String], values: [String] = []) {
        if names.isEmpty && !values.isEmpty {
            values.forEach { removeParam(name: nil, value: $0) }
        } else if !names.isEmpty {
            names.forEach { removeParam(name: $0) }
        }
    }
}
