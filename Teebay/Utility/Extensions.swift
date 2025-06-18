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



extension String {
    enum RegexType {
        case none
        case mobile                         // Example: "+88 019234567"
        case email                          // Example: "foo@example.com"
        case minLetters(_ letters: Int)     // Example: "Al"
        case minDigit(_ digits: Int)        // Example: "0612345"
        case onlyLetters                    // Example: "ABDEFGHILM"
        case onlyNumbers                    // Example: "132543136"
        case noSpecialChars                 // Example: "Malago'": OK - "Malagò": KO
        
        fileprivate var pattern: String {
            switch self {
            case .none:
                return ""
            case .mobile:
                return #"^(?:\+?88)?01[3-9]\d{8}$"#
            case .email:
                return #"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$"#
            case .minLetters(let letters):
                return #"^\D{"# + "\(letters)" + #",}$"#
            case .minDigit(let digits):
                return #"^(\d{"# + "\(digits)" + #",}){1}$"#
            case .onlyLetters:
                return #"^[A-Za-z]+$"#
            case .onlyNumbers:
                return #"^[0-9]+$"#
            case .noSpecialChars:
                return #"^[A-Za-z0-9\s+\\\-\/?:().,']+$"#
            }
        }
    }
    
    func isValidWith(regexType: RegexType) -> Bool {
            
            switch regexType {
            case .none : return true
            default    : break
            }
            
            let pattern = regexType.pattern
            guard let gRegex = try? NSRegularExpression(pattern: pattern) else {
                return false
            }
            
            let range = NSRange(location: 0, length: self.utf16.count)
            
            if gRegex.firstMatch(in: self, options: [], range: range) != nil {
                return true
            }
            
            return false
        }
    
    
    func toFormattedDate() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: self) else {
            return nil
        }
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let daySuffix = Self.getDaySuffix(for: day)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        let monthYear = dateFormatter.string(from: date)
        return "\(day)\(daySuffix) \(monthYear)"
    }
    
    private static func getDaySuffix(for day: Int) -> String {
        switch day {
        case 11, 12, 13:
            return "th"
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
}

extension UserDefaults  {

    var isLoggedIn: Bool? {
        get {
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}




