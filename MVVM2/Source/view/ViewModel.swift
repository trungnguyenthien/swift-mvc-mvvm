//
//  ViewModel.swift
//  Sample
//
//  Created by Trung on 20/11/2022.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    @Published private(set) var sections: [Section] = []
    
    private let bannerTable = BannerTable()
    private let monsterService = MonsterService()
    private var cancellables: Set<AnyCancellable> = []
    
    enum Section {
        case banner(index: Int)
        case monster(index: Int, rows: Monsters)
        case error
    }
    
    func firstLoad() {
        
        monsterService.loadByGroup().sink { completion in
            switch(completion) {
            case .finished: return
            case .failure: self.sections = [.error]
            }
        } receiveValue: { monsters in
            let bannerPositions = self.bannerTable.bannerPositions()
            var tempSections: [Section] = []
            var bannerIndex = 0
            var monsterIndex = 0
            let totalSection = monsters.count + bannerPositions.count
            (0..<totalSection).forEach { index in
                if bannerPositions.contains(where: { $0 == index }) {
                    tempSections.append(.banner(index: bannerIndex))
                    bannerIndex += 1
                } else {
                    tempSections.append(.monster(index: monsterIndex, rows: monsters[monsterIndex]))
                    monsterIndex += 1
                }
            }
            
            self.sections = tempSections
        }.store(in: &cancellables)
    }
    
    func toggleFavorite(monster: Monster) {
        monsterService.toggleFavorite(monster: monster)
        sections = sections
    }
}
