//
//  FoldersTableViewCell.swift
//  MyNotes
//
//  Created by Venkatesh Nyamagoudar on 1/19/23.
//

import UIKit

class FoldersTableViewCell: UITableViewCell {
    
    static let identifier = "FoldersTableViewCell"
    
    var folderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "folder.fill")
        imageView.tintColor = .systemYellow
        return imageView
    }()
    
    var folderNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 21, weight: .regular)
        return label
    }()
    
    var numberOfNotesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(numberOfNotesLabel)
        contentView.addSubview(folderNameLabel)
        contentView.addSubview(folderImage)
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        folderNameLabel.frame = CGRect(x: 68, y: 15, width: 140, height: 30)
        numberOfNotesLabel.frame = CGRect(x: 280, y: 15, width: 45, height: 30)
        folderImage.frame = CGRect(x: 20, y: 15, width: 40, height: 30)
    }    
}
