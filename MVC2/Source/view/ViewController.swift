//
//  ViewController.swift
//  MyApp
//
//  Created by Trung on 01/10/2022.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    enum Section {
        case banner(index: Int)
        case monster(index: Int, rows: Monsters)
        case error
    }
    
    var sections = [Section]()
    
    @IBOutlet weak var tableView: UITableView!
    private let bannerTable = BannerTable()
    private let monsterService = MonsterService()
    private var cancellables: Set<AnyCancellable> = []
    var pokemons = [Monsters]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerRow(type: PokeRow.self)
        tableView.registerRow(type: BannerRow.self)
        tableView.registerRow(type: ErrorRow.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        monsterService.loadByGroup().sink { completion in
            switch(completion) {
            case .finished: return
            case .failure: self.sections = [.error]
            }
            self.reloadTable()
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
            self.reloadTable()
        }.store(in: &cancellables)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (sections[section]) {
        case .monster(index: let index, rows: _): return "Pokemon Evolution: #\(index)"
        case .banner: return nil
        case .error: return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (sections[section]) {
        case .monster(index: _, rows: let rows): return rows.count
        case .banner(index: _): return 1
        case .error: return 1
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
        case .error:
            let cell: ErrorRow = tableView.dequeueRow(index: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (sections[indexPath.section]) {
        case .monster: return tableView.estimatedRowHeight
        case .banner: return tableView.estimatedRowHeight
        case .error: return tableView.bounds.height
        }
    }
    
    private func reloadTable() {
        mainThread { self.tableView.reloadData() }
    }
    
    private func bindBannerRow(cell: BannerRow, index: Int) {
        cell.bind(index: index)
    }
    
    private func bindPokeRow(cell: PokeRow, poke: Monster) {
        cell.bind(
            name: poke.name.japanese,
            imageUrl: poke.image.thumbnail,
            description: poke.monsterDescription,
            isFavorite: poke.isFavorite
        )
        
        cell.tapOnHeart = { _ in
            self.monsterService.toggleFavorite(monster: poke)
            self.reloadTable()
        }
        
        cell.tapOnSelf = { row in
            print("Send Clicklog")
        }
    }
}
