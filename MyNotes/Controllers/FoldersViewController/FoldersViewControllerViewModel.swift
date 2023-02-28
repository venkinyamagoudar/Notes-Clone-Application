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
    
    var coreDataController: CoreDataController = CoreDataController()
    var fetchedResultController : NSFetchedResultsController<Folder>!
    
    init() {
        fetchedResultController = self.setUpFetchResultController()
    }
    
    /// Description: returns used to get the all the stored folder from persistent storage
    /// - Returns: NSFetchResultsController<Folder>
    /// func setUpFetchResultController() -> NSFetchedResultsController<Folder>
    func setUpFetchResultController() -> NSFetchedResultsController<Folder> {
        //while Usingfetch request with fetchedresultcontroller they must be sorted.
        let fetchRequest:NSFetchRequest<Folder> = Folder.fetchRequest()
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        self.fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }
        
    /// Description: Searches for the text in searchbar
    /// - Parameters:
    ///   - text: Text entered in the searchbar
    ///   - fetchedResult: FetchedResultController
    /// - Returns: return array of notes that have the text
    /// func fetchNotes(for text: String, using fetchedResultController: NSFetchedResultsController<Folder>) -> [Note]? {
    func fetchNotes(for text: String) -> [Note]? {
        //1.Get All notes from each folder and store them in a variable
        var notes = [Note]()
        guard let folders = fetchedResultController.fetchedObjects else {return nil}
        for folder in folders {
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
        coreDataController.save()
    }
    
    /// Description: Used to delete the folder from the core data
    /// - Parameters:
    ///   - indexPath: indexPath of the table where the data is deleted
    ///   - fetchedResultController: fetchedResults using fetchedResultController
    ///   func deleteFolder(at indexPath: IndexPath, using fetchedResultController: NSFetchedResultsController<Folder>) {

    func deleteFolder(at indexPath: IndexPath) {
        let folder = fetchedResultController.object(at: indexPath)
        coreDataController.viewContext.delete(folder)
        coreDataController.save()
    }    
}
