//
//  BannerRow.swift
//  MyApp
//
//  Created by Trung on 13/11/2022.
//

import UIKit

class BannerRow: UITableViewCell {
    @IBOutlet weak var bannerLabel: UILabel!
    
    
    func bind(index: Int) {
        bannerLabel.text = "[BANNER \(index)]"
    }
    
}
