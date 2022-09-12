//
//  NoteViewController.swift
//  NotesCoreData
//
//  Created by Kiran on 12/09/22.
//

import Foundation
import UIKit

class NoteViewController: UIViewController {
    private var noteId: String!
    private var textView: UITextView!
    private var textField: UITextField!
    private var bodyHeaderLabel : UILabel!
    private var index: Int!
    var noteCell: NoteCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        index = HomeViewController.notes.firstIndex(where: {$0.id == noteId})!
        view.backgroundColor = .systemBackground
        self.navigationItem.largeTitleDisplayMode = .never
        setupNavigationBarItem()
        setupTextView()
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let note = HomeViewController.notes[index]
        textView.text = note.body.isEmpty ? "Type something..." : note.body
        textField.text = note.title
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let noteCell = noteCell else {
            return
        }
        noteCell.prepareNote()
        noteCell.configure(note: HomeViewController.notes[index])
        noteCell.configureLabels()
    }
    
    private func setupNavigationBarItem() {
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard)),UIBarButtonItem(image: UIImage(systemName: "link.badge.plus"), style: .plain, target: self, action: #selector(dismissKeyboard)), ]
    }
    
    private func setupTextView() {
        textView = CustomtextView(frame: .zero)
        view.addSubview(textView)
        textView.delegate = self
        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height * 0.09),
            textView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
    }
    
    private func setupTextField() {
        textField = CustomTextField(frame: .zero)
        view.addSubview(textField)
        textField.delegate = self
        
        NSLayoutConstraint.activate([
            textField.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -10),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])

    }
    
    func set(noteId: String) {
        self.noteId = noteId
    }
    
    func set(noteCell: NoteCell) {
        self.noteCell = noteCell
    }
}

extension NoteViewController: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Type something...") {
            textView.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        HomeViewController.notes[index].body = textView.text
        CoreDataManager.shared.save()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        HomeViewController.notes[index].title = textField.text!
        CoreDataManager.shared.save()
    }
    
}

extension NoteViewController {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        let alert = UIAlertController(title: "Note App", message: "Your Note has been saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true)
    }
    
}
