//
//  Bundle+Extension.swift
//  MyApp
//
//  Created by Trung on 22/10/2022.
//

import Foundation

extension Bundle {
    class func stringContent(ofFile fileName: String, withType type: String) -> String? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: type) else { return nil }
        return try? String(contentsOfFile: path)
    }
    
    class func dataContent(ofFile fileName: String, withType type: String) -> Data? {
        guard let string = stringContent(ofFile: fileName, withType: type) else { return nil }
        return string.data(using: String.Encoding.utf8)
    }
}
