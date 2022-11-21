//
//  MonsterService.swift
//  Sample
//
//  Created by Trung on 20/11/2022.
//

import Foundation
import Combine

class MonsterService {
    private let monsterTable = MonsterTable()
    private let favoriteIdsTable = FavoriteIdsTable()
    
    func loadByGroup() -> PassthroughSubject<[Monsters], Error> {
        let subject = PassthroughSubject<[Monsters], Error>()
        monsterTable.loadAllMonster { [weak self] monsters in
            guard let self = self else {
                subject.send(completion: .failure(NSError()))
                return
            }
            
            let groups = self.groupPokemons(input: self.markFavorite(input: monsters))
            subject.send(groups)
            subject.send(completion: .finished)
        }
        return subject
    }
    
    func toggleFavorite(monster: Monster) {
        switch(monster.isFavorite) {
        case true: favoriteIdsTable.remove(id: monster.id.description)
        case false: favoriteIdsTable.add(id: monster.id.description)
        }
        monster.isFavorite = !monster.isFavorite
    }
    
    private func markFavorite(input: Monsters) -> Monsters {
        var output = Monsters()
        input.forEach { monster in
            let copy = monster
            copy.isFavorite = favoriteIdsTable.has(id: "\(copy.id)")
            output.append(copy)
        }
        return output
    }
    
    private func groupPokemons(input: Monsters) -> [Monsters] {
        var output = [Monsters]()
        
        let full = input.map { item -> [Int] in
            let next = item.evolution.next ?? []
            let nextIds = next.flatMap { $0 }.compactMap { $0.intOrNil }
            let prevIds = item.evolution.prev?.compactMap { $0.intOrNil } ?? []
            var output = [Int]()
            output.append(item.id)
            output.append(contentsOf: nextIds)
            output.append(contentsOf: prevIds)
            
            return output.distinct
        }
        
        var current = [Int]()
        full.forEach { group in
            if group.containAny(in: current) {
                current.append(contentsOf: group)
                current = current.distinct
            } else if current.isEmpty {
                current.append(contentsOf: group)
            } else {
                let sectionMonster = input.find(ids: current.sorted())
                output.append(sectionMonster)
                current = []
            }
        }
        
        return output
    }
}
