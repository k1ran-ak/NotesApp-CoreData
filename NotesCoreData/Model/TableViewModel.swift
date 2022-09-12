//
//  TableViewModel.swift
//  NotesCoreData
//
//  Created by Kiran on 12/09/22.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
    private var isSearching: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    internal func setupTableView() {
        let tableView = UITableView(frame: .zero)
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.separatorColor = .systemGray3
        self.tableView = tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            label.isHidden = true
            return searchedNotes.count
        } else {
            label.isHidden = false
            HomeViewController.notes.count == 0 ? label.animateIn() : label.animateOut()
            return HomeViewController.notes.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 85 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.id, for: indexPath) as? NoteCell else {
            return UITableViewCell()
        }
        if isSearching {
            cell.configure(note: searchedNotes[indexPath.row])
        } else {
            cell.configure(note: HomeViewController.notes[indexPath.row])
        }
        
        cell.configureLabels()
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteVC = NoteViewController()
        if isSearching {
            noteVC.set(noteId: searchedNotes[indexPath.row].id)
        } else {
            noteVC.set(noteId: HomeViewController.notes[indexPath.row].id)
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? NoteCell else {
            return
        }
        noteVC.set(noteCell: cell)
        navigationController?.pushViewController(noteVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        removeNote(row: indexPath.row, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isSearching {
            return false
        }
        return true
    }
    
    internal func removeNote(row: Int, tableView: UITableView) {
        deleteNoteFromStorage(at: row)
        HomeViewController.notes.remove(at: row)
        let path = IndexPath(row: row, section: 0)
        tableView.deleteRows(at: [path], with: .top)
    }
    
    internal func removeCellIfEmpty() {
        guard let firstNoteCell = HomeViewController.notes.first else {
            return
        }
        if firstNoteCell.title.trimmingCharacters(in: .whitespaces).isEmpty &&
            firstNoteCell.body.trimmingCharacters(in: .whitespaces).isEmpty {
            removeNote(row: 0, tableView: tableView!)
        }
    }
    
}

// MARK:- Helper to handle data (Note) manipulation
extension HomeViewController {
    
    func fetchNotesFromStorage() {
        HomeViewController.notes = CoreDataManager.shared.fetchNotes()
    }
    
    private func deleteNoteFromStorage(at index: Int) {
        CoreDataManager.shared.deleteNote(HomeViewController.notes[index])
    }
    
    func searchNotesFromStorage(_ text: String) {
        searchedNotes = CoreDataManager.shared.fetchNotes(filter: text)
        tableView?.reloadData()
    }
    
}
