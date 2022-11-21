//
//  ViewModel.swift
//  Sample
//
//  Created by Trung on 20/11/2022.
//

import Foundation

class ViewModel: ObservableObject {
    private let favoriteIdsTable = FavoriteIdsTable()
    private let monsterTable = MonsterTable()
    private let bannerTable = BannerTable()
    
    enum Section {
        case banner(index: Int)
        case monster(index: Int, rows: Monsters)
    }
    
    @Published private(set) var sections: [Section] = []
    
    func firstLoad() {
        let bannerPositions = bannerTable.bannerPositions()
        monsterTable.loadAllMonster { monsters in
            let pokemons = self.groupPokemons(input: self.setFavorite(input: monsters))
            let totalSection = pokemons.count + bannerPositions.count
            var tempSections: [Section] = []
            var bannerIndex = 0
            var monsterIndex = 0
            (0..<totalSection).forEach { index in
                if bannerPositions.contains(where: { $0 == index }) {
                    tempSections.append(.banner(index: bannerIndex))
                    bannerIndex += 1
                } else {
                    tempSections.append(.monster(index: monsterIndex, rows: pokemons[monsterIndex]))
                    monsterIndex += 1
                }
            }
            
            self.sections = tempSections
        }
    }
    
    func toggleFavorite(monster: Monster) {
        if monster.isFavorite {
            favoriteIdsTable.remove(id: monster.id.description)
        } else {
            favoriteIdsTable.add(id: monster.id.description)
        }
        monster.isFavorite = !monster.isFavorite
        sections = sections
    }
    
    private func setFavorite(input: Monsters) -> Monsters {
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
