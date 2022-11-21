//
//  ViewController.swift
//  MyApp
//
//  Created by Trung on 01/10/2022.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {    
    var sections = [ViewModel.Section]()
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerRow(type: PokeRow.self)
        tableView.registerRow(type: BannerRow.self)
        
        viewModel.$sections.sink { sections in
            self.sections = sections
            mainThread {
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        super.viewDidAppear(animated)
        viewModel.firstLoad()
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
        cell.bind(
            name: poke.name.japanese,
            imageUrl: poke.image.thumbnail,
            description: poke.monsterDescription,
            isFavorite: poke.isFavorite
        )
        
        cell.tapOnHeart = { row in
            self.viewModel.toggleFavorite(monster: poke)
        }
        
        cell.tapOnSelf = { row in
            print("Send Clicklog")
        }
    }
}
