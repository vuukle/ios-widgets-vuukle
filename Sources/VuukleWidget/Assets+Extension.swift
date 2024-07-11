//
//  Assets+Extension.swift
//  Vuukle
//
//  Created by Narek Dallakyan on 20.04.22.
//

extension String {
    func formatColor() throws -> String {
        if self.starts(with: "#") {
            return "%23" + self.dropFirst()
        } else if self.starts(with: "%23") {
            return self
        } else {
            return ""
        }
    }
}
