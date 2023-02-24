//
//  NotesListViewController.swift
//  MyNotes
//
//  Created by Venkatesh Nyamagoudar on 1/19/23.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController {

    @IBOutlet weak var notesListTableView: UITableView!
    
    var coreDataController: CoreDataController!
    var fetchedResultController: NSFetchedResultsController<Note>!
    var searchController: UISearchController!
    lazy var searchSelectionViewController: SearchSelectionViewController = {
        SearchSelectionViewController()
    }()
    var folder: Folder!
    var viewModel: NotesListViewControllerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = folder.name
        view.backgroundColor = .secondarySystemBackground
        viewModel = NotesListViewControllerViewModel(coreDataController: coreDataController, folder: folder)
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .systemYellow
        setUpSearchController()
        setUPTableView()
        setUpToolBarItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchedResultController = viewModel.setUPFetchedResultsControllerForNotes()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch let error {
            fatalError("Error while fetching data. Error: \(error)")
        }
        navigationController?.toolbar.backgroundColor = .secondarySystemBackground
        notesListTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultController = nil
        try! coreDataController.viewContext.save()
        navigationController?.toolbar.backgroundColor = .systemBackground
    }
    
    fileprivate func setUpSearchController() {
        //MARK: Search Controller
        searchController = UISearchController(searchResultsController: searchSelectionViewController)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchSelectionViewController.searchControllerdelegate = self
    }
    
    fileprivate func setUPTableView() {
        notesListTableView.delegate = self
        notesListTableView.dataSource = self
        notesListTableView.layer.masksToBounds = true
        notesListTableView.layer.cornerRadius = 20.0
        notesListTableView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.identifier)
    }
    
    fileprivate func setUpToolBarItems() {
        self.navigationController?.isToolbarHidden = false
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let title = folder.notes!.count > 1 ? "\(folder.notes!.count) notes" : "\(folder.notes!.count) note"
        let titleButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNotesButtonTapped))
        self.toolbarItems = [space,titleButton,space,addButton]
        
    }
    
    func updatingEditButtonItem() {
        if let section = fetchedResultController.sections {
            navigationItem.rightBarButtonItem?.isEnabled = section[0].numberOfObjects > 0
        }
    }
    
    @objc func addNotesButtonTapped() {
        presentNotesListAlertController()
    }
    
    func presentNotesListAlertController() {
        let ac = UIAlertController(title: "Creat a new note", message: "Enter the name of the note", preferredStyle: .alert)
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { save in
            if let text = ac.textFields?.first?.text {
                self.viewModel.createNote(with: text)
            }
        }
        saveButton.isEnabled = false
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addTextField { textfield in
            textfield.placeholder = "Note Name"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textfield, queue: .main) { notification in
                if let noteName = textfield.text, !noteName.isEmpty {
                    saveButton.isEnabled = true
                } else {
                    saveButton.isEnabled = false
                }
            }
        }
        ac.addAction(cancelButton)
        ac.addAction(saveButton)
        present(ac, animated: true)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NotesDetail",
           let destination = segue.destination as? NotesDetailViewController,
           let notesIndex = notesListTableView.indexPathForSelectedRow {
            let note  = fetchedResultController.object(at: notesIndex)
            destination.note = note
            destination.coreDataController = coreDataController
        }
    }
}

extension NotesListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        setUpToolBarItems()
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = fetchedResultController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as! NotesTableViewCell
        cell.notesNameLabel.text = note.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "NotesDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteNote(at: indexPath, using: fetchedResultController)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        notesListTableView.setEditing(editing, animated: animated)
    }
}

extension NotesListViewController:  NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notesListTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notesListTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                notesListTableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                notesListTableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                notesListTableView.moveRow(at: indexPath, to: newIndexPath)
            }
        case .update:
            if let indexPath = indexPath {
                notesListTableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            notesListTableView.insertSections(indexSet, with: .fade)
        case .delete:
            notesListTableView.deleteSections(indexSet, with: .fade)
        case .move:
            print("Not written yet")
            break
        case .update:
            print("Not written yet")
            break
        }
    }
}

extension NotesListViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text != "" else {
            return
        }
        let fetchResults = viewModel.setUpFetchResultControllerForFolder()
        do {
            try fetchResults.performFetch()
        } catch let error {
            fatalError("Error while initialising FetchedController. Error: \(error)")
        }
        
        guard let searchedNotes = viewModel.fetchNotes(for: text, using: fetchResults) else {return}
        
        // send the resulting Notes to search controllerall
        searchSelectionViewController.configure(model: searchedNotes)
    }
}

extension NotesListViewController: SearchResultTableViewControllerDelegate {
    
    func didSelectResult(tappedNote: Note) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotesDetailViewController") as! NotesDetailViewController
        vc.configure(with: coreDataController, tappedNote: tappedNote)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
