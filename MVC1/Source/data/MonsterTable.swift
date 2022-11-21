//
//  MonsterTable.swift
//  Sample
//
//  Created by Trung on 20/11/2022.
//

import Foundation

class MonsterTable {
    // This file was generated from JSON Schema using quicktype, do not modify it directly.
    // To parse the JSON, add this file to your project and do:
    //
    //   let monster = try? newJSONDecoder().decode(Monster.self, from: jsonData)

    func loadAllMonster(completed: @escaping (Monsters) -> Void) {
        DispatchQueue.global().async {
            guard let data = Bundle.dataContent(ofFile: "pokedex", withType: "json") else {
                completed([])
                return
            }
            let list = try? JSONDecoder().decode(Monsters.self, from: data)
            completed(list ?? [])
        }

    }
}
