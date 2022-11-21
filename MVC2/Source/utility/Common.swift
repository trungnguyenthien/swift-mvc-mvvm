//
//  Common.swift
//  Sample
//
//  Created by Trung on 20/11/2022.
//

import Foundation


extension Monsters {
    func find(id: Int) -> Monster? {
        first { $0.id == id }
    }
    
    func find(ids: [Int]) -> Monsters {
        ids.compactMap { find(id: $0) }
    }
}

extension String {
    var intOrNil: Int? { Int(self) }
}

extension Sequence where Iterator.Element: Hashable {
    var distinct: [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return filter { seen.updateValue(true, forKey: $0) == nil }
    }
    
    func containAny(in list: [Iterator.Element]) -> Bool {
        contains { item1 in
            list.contains { item1 == $0 }
        }
    }
}

func mainThread(_ code: @escaping () -> Void) {
    DispatchQueue.main.async { code() }
}

func background(_ code: @escaping () -> Void) {
    DispatchQueue.global().async { code() }
}
