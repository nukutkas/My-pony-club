//
//  MainTableViewController.swift
//  My pony club
//
//  Created by Татьяна Кочетова on 19.03.2021.
//  Copyright © 2021 Nikita Kochetov. All rights reserved.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
    
    
    var ponies: Results<Pony>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ponies = realm.objects(Pony.self)
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ponies.isEmpty ? 0 : ponies.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let pony = ponies[indexPath.row]

        cell.nameLabel?.text = pony.name
        cell.locationLabel.text = pony.location
        cell.typeLabel.text = pony.type
        cell.imageOfPony.image = UIImage(data: pony.imageData!)
       
        cell.imageOfPony?.layer.cornerRadius = cell.imageOfPony.frame.size.height / 2
        cell.imageOfPony?.clipsToBounds = true

        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
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
            let pony = ponies[indexPath.row]
            let newPonyVC = segue.destination as! NewPonyTableViewController
            newPonyVC.currentPony = pony
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let NewPonyVC = segue.source as? NewPonyTableViewController else { return }
        NewPonyVC.savePony()
        tableView.reloadData()
        
    }
}
