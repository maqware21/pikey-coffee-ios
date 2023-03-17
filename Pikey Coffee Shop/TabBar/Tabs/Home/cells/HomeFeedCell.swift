//
//  HomeFeedCell.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 08/06/2022.
//

import UIKit
import Kingfisher

class HomeFeedCell: UITableViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var category: Category? {
        didSet {
            guard let category else {
                return
            }
            
            if let url = URL(string: category.images?.first?.path ?? "") {
                categoryImage.contentMode = .scaleToFill
                categoryImage.kf.setImage(with: url, placeholder: UIImage(named: "pikey-logo-black"))
            } else {
                categoryImage.contentMode = .scaleAspectFit
                categoryImage.image = UIImage(named: "pikey-logo-black")
            }
            titleLabel.text = category.name
        }
    }
    
}
