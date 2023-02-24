//
//  FoldersViewControllerViewModel.swift
//  MyNotes
//
//  Created by Venkatesh Nyamagoudar on 2/16/23.
//

import Foundation
import UIKit
import CoreData

class FoldersViewControllerViewModel {
    
    var coreDataController: CoreDataController
    
    init(coreDataController: CoreDataController) {
        self.coreDataController = coreDataController
    }
    
    
    /// Description: returns used to get the all the stored folder from persistent storage
    /// - Returns: NSFetchResultsController<Folder>
    func setUpFetchResultController() -> NSFetchedResultsController<Folder> {
        //while Usingfetch request with fetchedresultcontroller they must be sorted.
        let fetchRequest:NSFetchRequest<Folder> = Folder.fetchRequest()
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }
        
    /// Description: Searches for the text in searchbar
    /// - Parameters:
    ///   - text: Text entered in the searchbar
    ///   - fetchedResult: FetchedResultController
    /// - Returns: return array of notes that have the text
    func fetchNotes(for text: String, using fetchedResultController: NSFetchedResultsController<Folder>) -> [Note]? {
        //1.Get All notes from each folder and store them in a variable
        var notes = [Note]()
        guard let folders = fetchedResultController.fetchedObjects else {return nil}
        for folder in folders {
            print(folder.creationDate)
            for note in folder.notes!.allObjects {
                notes.append(note as! Note)
            }
        }
        //2.now search name and attributedText of each note using the searchedtext
        var searchedNotes = [Note]()
        for note in notes {
            if let name = note.name, let textSearch = note.attributedText?.string, name.contains(text) || textSearch.contains(text) {
                searchedNotes.append(note)
            }
        }
        return searchedNotes
    }
    
    /// Description: To add a new Folder
    /// - Parameters:
    ///   - name: Name of the new folder
    func createFolder(with name: String) {
        let folder = Folder(context: coreDataController.viewContext)
        folder.name = name
        folder.creationDate = Date()
        save()
    }
    
    /// Description: To save the changes made
    func save() {
        do {
            try coreDataController.viewContext.save()
        } catch let error {
            fatalError("Error while saving data. Error: \(error)")
        }
    }
    
    /// Description: Used to delete the folder from the core data
    /// - Parameters:
    ///   - indexPath: indexPath of the table where the data is deleted
    ///   - fetchedResultController: fetchedResults using fetchedResultController
    func deleteFolder(at indexPath: IndexPath, using fetchedResultController: NSFetchedResultsController<Folder>) {
        let folder = fetchedResultController.object(at: indexPath)
        coreDataController.viewContext.delete(folder)
        save()
    }    
}
