//
//  NotesDetailViewController.swift
//  MyNotes
//
//  Created by Venkatesh Nyamagoudar on 1/19/23.
//

import UIKit
import CoreText

class NotesDetailViewController: UIViewController{

    @IBOutlet weak var textView: UITextView!
    var note: Note!
    var coreDataController: CoreDataController!
    var deleteNode: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        textView.delegate = self
        rightBarButtonSetUp()
        setupTextView()
        configureToolBar()
        configureTextViewInputAccessoryView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    fileprivate func rightBarButtonSetUp() {
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(deleteButtonPressed))
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareButtonTapped))
        navigationItem.rightBarButtonItems = [deleteButton, shareButton]
    }
    
    func setupTextView() {
        textView.font = UIFont(name: "TimesNewRomanPSMT",size: 22)
        textView.attributedText = note.attributedText
    }

    func saveToCoreData() {
        try? coreDataController.viewContext.save()
    }
    
    func configure(with sentCoreDataController: CoreDataController, tappedNote: Note ) {
        self.note = tappedNote
        self.coreDataController = sentCoreDataController
    }
}

extension NotesDetailViewController {
    
    func configureTextViewInputAccessoryView() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        toolbar.items = setToolBarButtons()
        textView.inputAccessoryView = toolbar
    }

    func configureToolBar() {
        toolbarItems = setToolBarButtons()
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    fileprivate func setToolBarButtons() -> [UIBarButtonItem] {
       
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let _ = UIBarButtonItem(image: UIImage(systemName: "textformat.alt"), style: .done, target: self, action: #selector(textFormatButtonTapped))
        let bold = UIBarButtonItem(image: UIImage(systemName: "bold"), style: .done, target: self, action: #selector(boldButtonTapped))
        let itallic = UIBarButtonItem(image: UIImage(systemName: "italic"), style: .done, target: self, action: #selector(itallicButtonButtonTapped))
        let underline = UIBarButtonItem(image: UIImage(systemName: "underline"), style: .done, target: self, action: #selector(underLineButtonTapped))
        return [space, bold, space, itallic, space, underline, space]
    }
    
    @objc func textFormatButtonTapped(_ sender: Any) {
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        customView.backgroundColor = .green
        self.textView.inputView = customView
        
    }
    
    @objc func boldButtonTapped(_ sender: Any) {
        let newText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        newText.addAttribute(.font, value: UIFont(name: "TimesNewRomanPS-BoldMT", size: 22) as Any, range: textView.selectedRange)
        guard let selectedTextRange = textView.selectedTextRange else { return }
        textView.attributedText = newText
        textView.selectedTextRange = selectedTextRange
        note.attributedText = textView.attributedText
        ((try? coreDataController?.viewContext.save()) as ()??)
    }
    
    @objc func itallicButtonButtonTapped(_ sender: Any) {
        let newText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        newText.addAttribute(.font, value: UIFont(name: "TimesNewRomanPS-ItalicMT", size: 22) as Any, range: textView.selectedRange)
        let selectedTextRange = textView.selectedTextRange
        textView.attributedText = newText
        textView.selectedTextRange = selectedTextRange
        note.attributedText = textView.attributedText
        ((try? coreDataController?.viewContext.save()) as ()??)
    }
    
    @objc func underLineButtonTapped(_ sender: Any) {
        let newText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .underlineStyle: 1,
            .underlineColor: UIColor.black
        ]
        newText.addAttributes(attributes, range: textView.selectedRange)
        let selectedTextRange = textView.selectedTextRange
        textView.attributedText = newText
        textView.selectedTextRange = selectedTextRange
        note.attributedText = textView.attributedText
        try? coreDataController?.viewContext.save()
    }
}

extension NotesDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note.attributedText = textView.attributedText
        saveToCoreData()
    }
    
    func updateTextView(notification: Notification) {
        let userinfo = notification.userInfo!
        let keyBoardEndFrameScreenCoordinates = (userinfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyBoardEndFrame = self.view.convert(keyBoardEndFrameScreenCoordinates, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardEndFrame.height, right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        textView.scrollRangeToVisible(textView.selectedRange)
    }
}


//MARK: Delete Button
extension NotesDetailViewController {
    
    @objc func deleteButtonPressed() {
        presentDeleteAlert()
    }
    
    fileprivate func presentDeleteAlert() {
        let alert = UIAlertController(title: "Delete", message: "Do you want to delete note?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler )
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true)
    }

    fileprivate func deleteHandler(sender: UIAlertAction) {
        deleteNode?()
    }
    
    @objc func shareButtonTapped(_ sender: UIBarButtonItem) {
        
    }
}
