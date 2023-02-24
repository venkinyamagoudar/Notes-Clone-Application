//
//  ViewController.swift
//  MyNotes
//
//  Created by Venkatesh Nyamagoudar on 1/19/23.
//
//

import UIKit
import CoreData

class FoldersViewController: UIViewController {

    lazy var searchSelectionViewController: SearchSelectionViewController = {
        SearchSelectionViewController()
    }()
    var coreDataController: CoreDataController!
    var fetchedResultController : NSFetchedResultsController<Folder>!
    var searchController: UISearchController!
    var viewModel: FoldersViewControllerViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Folders"
        view.backgroundColor = .systemBackground
        viewModel = FoldersViewControllerViewModel(coreDataController: coreDataController)
        setUpSearchController()
        setUpNavigationController()
        setUpTableView()
        setUpToolbarButtons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.deselctRowFromTable(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchedResultController = viewModel.setUpFetchResultController()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch let error {
            fatalError("Error while initialising FetchedController. Error: \(error)")
        }
        tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultController = nil
    }
    
    fileprivate func setUpSearchController() {
        //MARK: Search Controller
        searchController = UISearchController(searchResultsController: searchSelectionViewController)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search notes"
        searchController.delegate = self
        definesPresentationContext = true
        searchSelectionViewController.searchControllerdelegate = self
    }
    
    fileprivate func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 20.0
        tableView.backgroundColor = .systemBackground
        tableView.register(FoldersTableViewCell.self, forCellReuseIdentifier: FoldersTableViewCell.identifier)
    }
    
    fileprivate func setUpNavigationController() {
        navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.layer.cornerRadius = 20.0
        navigationController?.navigationBar.clipsToBounds = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        navigationItem.rightBarButtonItem = editButtonItem
        navigationController?.isToolbarHidden = false
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationController?.toolbar.tintColor = .systemYellow
//        navigationController?.toolbar.backgroundColor = .systemBackground
    }
    
    fileprivate func setUpToolbarButtons() {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFolderButtonTapped))
        self.toolbarItems = [space,addButton]
    }
    
    func updatingEditButtonItem() {
        if let section = fetchedResultController.sections {
            navigationItem.rightBarButtonItem?.isEnabled =  section[0].numberOfObjects > 0
        }
    }
    
    @objc func addFolderButtonTapped(){
        presentAlertController()
    }
    
    func presentAlertController() {
        let ac = UIAlertController(title: "creating a New Folder?", message: "Enter the name of the folder", preferredStyle: .alert)
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { save in
            if let name = ac.textFields?.first?.text {
                self.viewModel.createFolder(with: name)
            }
        }
        saveButton.isEnabled = false
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addTextField { (textfield) in
            textfield.placeholder = "Folder Name"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textfield, queue: .main) { notifyFolderName in
                if let folderName = textfield.text, !folderName.isEmpty {
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
    
    //    MARK: NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "NotesList",
            let destination = segue.destination as? NotesListViewController,
            let folderIndex = tableView.indexPathForSelectedRow {
            let folder = fetchedResultController.object(at: folderIndex)
            destination.folder = folder
            destination.coreDataController = self.coreDataController
        }
    }
}

extension FoldersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let section = fetchedResultController.sections {
            return section.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let folder = fetchedResultController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: FoldersTableViewCell.identifier, for: indexPath) as! FoldersTableViewCell
        cell.folderNameLabel.text = folder.name
        cell.isUserInteractionEnabled = true
        cell.numberOfNotesLabel.text = "\(folder.notes!.count)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "NotesList", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteFolder(at: indexPath, using: fetchedResultController)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
}

extension FoldersViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    /// Description
    /// - Parameters:
    ///   - controller: FolderViewController
    ///   - anObject: Folder
    ///   - indexPath: row number where the change is made
    ///   - type: NSFetchedResultsChangeType
    ///   - newIndexPath: If the chnge requires any new indexpath
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                if let indexPath = newIndexPath {
                    tableView.insertRows(at: [indexPath], with: .fade)
                }
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            case .move:
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
            case .update:
                tableView.reloadRows(at: [indexPath!], with: .fade)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
        case .move:
            print("Not written yet")
            break
        case .update:
            print("Not written yet")
            break
        }
    }
}

extension FoldersViewController : UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text != "" else {
            return
        }
        guard let searchedNotes = viewModel.fetchNotes(for: text, using: self.fetchedResultController) else {return}
        
        // send the resulting Notes to searchResultsController
        searchSelectionViewController.configure(model: searchedNotes)
    }
}

extension FoldersViewController : SearchResultTableViewControllerDelegate {
    
    func didSelectResult(tappedNote: Note) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotesDetailViewController") as! NotesDetailViewController
        vc.configure(with: coreDataController, tappedNote: tappedNote)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
