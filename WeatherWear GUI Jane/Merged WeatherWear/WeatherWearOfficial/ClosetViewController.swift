//
//  ClosetViewController.swift
//  WeatherWearOfficial
//
//  Created by Jane Bazzell on 7/26/21.
//

import UIKit

class ClosetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var closetTableView: UITableView!
    var clothes = [ClothingItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var sweater = ClothingItem(name: "Ugly Sweater", warmness: 9)
        var tShirt = ClothingItem(name: "Grey CHANCE T-shirt", warmness: 1)
        var jeans = ClothingItem(name: "Jeans", warmness: 5)
        clothes = [sweater, tShirt, jeans]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clothes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let clothing = clothes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "clothingID", for: indexPath)
        cell.textLabel!.text = clothing.name
        cell.textLabel!.font = UIFont(name: "Plain", size: 15)
        cell.detailTextLabel!.text =
            "Warmness: \(clothing.warmness.description)"
        cell.detailTextLabel!.font = UIFont(name: "Plain", size: 15)
        
        return cell
    }
    
    @IBAction func unwindToCloset(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! AddClothingItemViewController
        let newClothingItem = ClothingItem(name: sourceViewController.clothingItemText, warmness: Int(sourceViewController.warmness))
        clothes.append(newClothingItem)
        closetTableView.reloadData()
        // Use data from the view controller which initiated the unwind segue
    }
}
