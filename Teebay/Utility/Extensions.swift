//
//  Extensions.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 15/6/25.
//

import Foundation


// MARK: - Data
extension Data {
    var prettyPrintedJSONString: NSString? {
        guard
            let object = try? JSONSerialization.jsonObject(with: self),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        else {
            return nil
        }
        
        return jsonString
    }
}
