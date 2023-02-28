//
//  SearchSelectionTableViewCell.swift
//  MyNotes
//
//  Created by Venkatesh Nyamagoudar on 2/14/23.
//

import UIKit

class SearchSelectionTableViewCell: UITableViewCell {
    
    static var identifier = "SearchCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SearchCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
