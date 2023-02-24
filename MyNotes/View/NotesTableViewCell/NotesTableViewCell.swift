//
//  NotesTableViewCell.swift
//  MyNotes
//
//  Created by Venkatesh Nyamagoudar on 1/19/23.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    static let identifier = "NotesTableViewCell"
    
    var notesNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(notesNameLabel)
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        notesNameLabel.frame = CGRect(x: 20, y: 15, width: 200, height: 30)
    }
    
    func configure(with note: Note) {
        self.notesNameLabel.text = note.name
    }
}
