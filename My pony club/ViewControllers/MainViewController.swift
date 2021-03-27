//
//  MainTableViewController.swift
//  My pony club
//
//  Created by Татьяна Кочетова on 19.03.2021.
//  Copyright © 2021 Nikita Kochetov. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var ponies: Results<Pony>!
    private var filteredPonies: Results<Pony>!
    private var ascendingSorting = true
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
     
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var reversedSortingButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ponies = realm.objects(Pony.self)
        
        //Setup th search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }

    // MARK: - Table view data source


     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPonies.count
        }
        return ponies.isEmpty ? 0 : ponies.count
    }


     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        var pony = Pony()
        
        if isFiltering {
            pony = filteredPonies[indexPath.row]
        } else {
            pony = ponies[indexPath.row]
        }

        cell.nameLabel?.text = pony.name
        cell.locationLabel.text = pony.location
        cell.typeLabel.text = pony.type
        cell.imageOfPony.image = UIImage(data: pony.imageData!)
       
        cell.imageOfPony?.layer.cornerRadius = cell.imageOfPony.frame.size.height / 2
        cell.imageOfPony?.clipsToBounds = true

        return cell
    }
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let pony = ponies[indexPath.row]
            StorageManager.deleteObject(pony)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    

    
  //   MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let pony: Pony
            if isFiltering {
                pony = filteredPonies[indexPath.row]
            } else {
                pony = ponies[indexPath.row]
            }
            
            let newPonyVC = segue.destination as! NewPonyTableViewController
            newPonyVC.currentPony = pony
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let NewPonyVC = segue.source as? NewPonyTableViewController else { return }
        NewPonyVC.savePony()
        tableView.reloadData()
        
    }
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        
        sorting()
    }
    private func sorting() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            ponies = ponies.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            ponies = ponies.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        tableView.reloadData()
    }
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredPonies = ponies.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        
        tableView.reloadData()
    }
    
}
