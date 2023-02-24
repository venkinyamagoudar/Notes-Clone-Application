//
//  TableViewExtension.swift
//  MyNotes
//
//  Created by Venkatesh Nyamagoudar on 1/20/23.
//

import Foundation
import UIKit
import CoreData

extension UITableView {
    func deselctRowFromTable(animated: Bool) {
        if let selectedRow = self.indexPathForSelectedRow {
            self.deselectRow(at: selectedRow, animated: animated)
        }
    }
}

