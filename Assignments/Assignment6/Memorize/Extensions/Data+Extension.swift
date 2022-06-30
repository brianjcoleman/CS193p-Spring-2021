//
//  Data+Extension.swift
//  Memorize
//
//  Created by Brian Coleman on 2022-06-29.
//

import Foundation

extension Data {
    var utf8: String? { String(data: self, encoding: .utf8)}
}
