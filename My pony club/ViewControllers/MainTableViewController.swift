//
//  MainTableViewController.swift
//  My pony club
//
//  Created by Татьяна Кочетова on 19.03.2021.
//  Copyright © 2021 Nikita Kochetov. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    
    var ponies = Pony.getPonies()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ponies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let pony = ponies[indexPath.row]

        cell.nameLabel?.text = pony.name
        cell.locationLabel.text = pony.location
        cell.typeLabel.text = pony.type
        
        if pony.image == nil {
            cell.imageOfPony.image = UIImage(named: pony.ponyImage!)
        } else {
            cell.imageOfPony.image = pony.image
        }
        
        cell.imageOfPony?.layer.cornerRadius = cell.imageOfPony.frame.size.height / 2
        cell.imageOfPony?.clipsToBounds = true
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let NewPonyVC = segue.source as? NewPonyTableViewController else { return }
        NewPonyVC.saveNewPony()
        ponies.append(NewPonyVC.newPony!)
        tableView.reloadData()
        
    }
}
