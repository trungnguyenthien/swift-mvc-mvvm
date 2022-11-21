//
//  PokeRow.swift
//  MyApp
//
//  Created by Trung on 11/11/2022.
//

import UIKit
import Nuke

class PokeRow: UITableViewCell {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var tapOnHeart: (PokeRow) -> Void = {_ in }
    var tapOnSelf: (PokeRow) -> Void = {_ in }
    private var imageTask: ImageTask? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addTapGesture(to: heartImage, action: #selector(didTapOnHeart))
        addTapGesture(to: self, action: #selector(didTapOnSelf))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tapOnHeart = {_ in }
        tapOnSelf = {_ in }
        imageTask?.cancel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func didTapOnHeart() {
        tapOnHeart(self)
    }
    
    @objc func didTapOnSelf() {
        tapOnSelf(self)
    }
    
    func bind(
        name: String,
        imageUrl: String,
        description: String,
        isFavorite: Bool
    ) {
        nameLabel.text = name
        descriptionLabel.text = description
        set(isFavorite: isFavorite)
        imageTask = thumbImage.loadImageAsync(url: imageUrl)
    }
    
    func set(isFavorite: Bool) {
        switch(isFavorite) {
        case true: heartImage.tintColor = .red
        case false: heartImage.tintColor = .lightGray
        }
    }
}

extension UIImageView {
    func loadImageAsync(url: String, blankColor: UIColor = .lightGray) -> ImageTask? {
        image = blankColor.image(size: bounds.size)
        guard let url = URL(string: url) else { return nil }
        return ImagePipeline.shared.loadImage(with: url) { result in
            self.image = try? result.get().image
        }
    }
}

extension UIColor {
    func image(size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { rendererContext in
            setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UIView {
    /*
     tableView.register(
         PokeRow.nib,
         forCellReuseIdentifier: PokeRow.nibName
     )
     */
    class var nib: UINib {
        UINib(nibName: nibName, bundle: nil)
    }
    
    class var nibName: String {
        String(describing: Self.self)
    }
    
    func addTapGesture(to view: UIView, action: Selector?) {
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(tapGesture)
    }
}

extension UITableView {
    func registerRow(type: UITableViewCell.Type) {
        register(type.nib, forCellReuseIdentifier: type.nibName)
    }
    
    /// must register by `registerRow(type: UITableViewCell.Type)`
    func dequeueRow<T: UITableViewCell>(index: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: T.nibName, for: index) as! T
    }
}
