//
//  FavoriteTable.swift
//  MyApp
//
//  Created by Trung on 12/11/2022.
//

import Foundation

class FavoriteIdsTable: IdTable {
    init() {
        super.init(key: "favorite")
    }
}

class IdTable {
    private let userDefault = UserDefaults.standard
    private let key: String
    
    init(key: String) {
        self.key = "IdTable_" + key
    }
    
    private func currentData() -> [String] {
        return userDefault.stringArray(forKey: key) ?? []
    }
    
    private func save(data: [String]) {
        userDefault.setValue(data, forKey: key)
    }
    
    func add(id: String) {
        var current = currentData()
        current.removeAll { $0 == id }
        current.append(id)
        save(data: current)
    }
    
    func remove(id: String) {
        var current = currentData()
        current.removeAll { $0 == id }
        save(data: current)
    }
    
    func has(id: String) -> Bool {
        return currentData().contains { $0 == id }
    }
}
