//
//  SearchSelectionViewController.swift
//  MyNotes
//
//  Created by Venkatesh Nyamagoudar on 2/14/23.
//

import Foundation
import UIKit
import CoreData

protocol SearchResultTableViewControllerDelegate {
    func didSelectResult(tappedNote: Note)
}

class SearchSelectionViewController: UIViewController {
    
    
    // read dependency injection
    // You should not create objects inside viewController
    var tableView: UITableView!
    var notes : [Note]!
    var searchControllerdelegate: SearchResultTableViewControllerDelegate?
    
    fileprivate func setUpTableView() {
        tableView = UITableView(frame: CGRect(x: 16, y: 103, width: view.frame.width - 32, height: 666))
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 20.0
        tableView.backgroundColor = .systemBackground
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setUpTableView()
        
    }
    
    func configure(model notes: [Note]){
        setUpTableView()
        self.notes = notes
        tableView.reloadData()
    }

}

extension SearchSelectionViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchControllerdelegate?.didSelectResult(tappedNote: notes[indexPath.row])
//        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as! NotesTableViewCell
        cell.notesNameLabel.text = notes[indexPath.row].name
        return cell
    }
}
