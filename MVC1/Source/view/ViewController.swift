//
//  ViewController.swift
//  MyApp
//
//  Created by Trung on 01/10/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    enum Section {
        case banner(index: Int)
        case monster(index: Int, rows: Monsters)
    }
    
    var sections = [Section]()
    
    @IBOutlet weak var tableView: UITableView!
    private let favoriteIdsTable = FavoriteIdsTable()
    private let monsterTable = MonsterTable()
    private let bannerTable = BannerTable()
    var pokemons = [Monsters]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerRow(type: PokeRow.self)
        tableView.registerRow(type: BannerRow.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let banners = bannerTable.bannerPositions()
        monsterTable.loadAllMonster { monsters in
            self.pokemons = self.groupPokemons(input: monsters)
            let totalSection = self.pokemons.count + banners.count
            self.sections.removeAll()
            var bannerIndex = 0
            var monsterIndex = 0
            (0..<totalSection).forEach { index in
                if banners.contains(where: { $0 == index }) {
                    self.sections.append(.banner(index: bannerIndex))
                    bannerIndex += 1
                } else {
                    self.sections.append(.monster(index: monsterIndex, rows: self.pokemons[monsterIndex]))
                    monsterIndex += 1
                }
            }
            
            mainThread { self.tableView.reloadData() }
        }
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (sections[section]) {
        case .monster(index: let index, rows: _): return "Pokemon Evolution: #\(index)"
        case .banner(index: _): return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (sections[section]) {
        case .monster(index: _, rows: let rows): return rows.count
        case .banner(index: _): return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(sections[indexPath.section]) {
        case .banner(let index):
            let cell: BannerRow = tableView.dequeueRow(index: indexPath)
            bindBannerRow(cell: cell, index: index)
            return cell
            
        case let .monster(_, rows):
            let cell: PokeRow = tableView.dequeueRow(index: indexPath)
            let poke = rows[indexPath.row]
            bindPokeRow(cell: cell, poke: poke)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    private func bindBannerRow(cell: BannerRow, index: Int) {
        cell.bind(index: index)
    }
    
    private func bindPokeRow(cell: PokeRow, poke: Monster) {
        let id = "\(poke.id)"
        
        cell.bind(
            name: poke.name.japanese,
            imageUrl: poke.image.thumbnail,
            description: poke.monsterDescription,
            isFavorite: favoriteIdsTable.has(id: id)
        )
        
        cell.tapOnHeart = { row in
            let isFavorite = self.favoriteIdsTable.has(id: id)
            if isFavorite {
                self.favoriteIdsTable.remove(id: id)
            } else {
                self.favoriteIdsTable.add(id: id)
            }
            row.set(isFavorite: !isFavorite)
        }
        
        cell.tapOnSelf = { row in
            print("Send Clicklog")
        }
    }
}
