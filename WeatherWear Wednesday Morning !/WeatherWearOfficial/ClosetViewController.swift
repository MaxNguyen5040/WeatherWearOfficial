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
        var tankTop = ClothingItem(name: "Tank Top", warmness: 1)
        var tShirt = ClothingItem(name: "Grey CHANCE T-shirt", warmness: 2)
        var jacket = ClothingItem(name: "Jacket", warmness: 3)
        var lightCoat = ClothingItem(name: "Light Coat", warmness: 4)
        var hoodie = ClothingItem(name: "Hoodie", warmness: 5)
        var sweatShirt = ClothingItem(name: "Sweat Shirt", warmness: 6)
        var coat = ClothingItem(name: "Coat", warmness: 7)
        var trenchCoat = ClothingItem(name: "Trench Coat", warmness: 8)
        var thickSweater = ClothingItem(name: "Saturday Sweater", warmness: 9)
        var parka = ClothingItem(name: "Parka", warmness: 10)


        clothes = [trenchCoat,tShirt,hoodie,tankTop,lightCoat,parka,jacket,thickSweater,coat,sweatShirt]
        
        ClothingRack.rack.insert(sweatShirt, at: 0)
        ClothingRack.rack.insert(coat, at: 0)
        ClothingRack.rack.insert(thickSweater, at: 0)
        ClothingRack.rack.insert(jacket, at: 0)
        ClothingRack.rack.insert(parka, at: 0)
        ClothingRack.rack.insert(lightCoat, at: 0)
        ClothingRack.rack.insert(tankTop, at: 0)
        ClothingRack.rack.insert(hoodie, at: 0)
        ClothingRack.rack.insert(tShirt, at: 0)
        ClothingRack.rack.insert(trenchCoat, at: 0)
        
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
    
    @IBAction func unwindFromEditToCloset(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! EditclothingItemViewController
        let newClothingItem = ClothingItem(name: sourceViewController.clothingItemText, warmness: Int(sourceViewController.warmness))
        let index = closetTableView.indexPathForSelectedRow
        clothes[index!.row] = (newClothingItem)
        closetTableView.reloadData()
        // Use data from the view controller which initiated the unwind segue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editID"){
            let ecivc = segue.destination as! EditclothingItemViewController
            ecivc.index = closetTableView.indexPathForSelectedRow!.row
            let index = closetTableView.indexPathForSelectedRow!.row
            ecivc.clothingItemText = ClothingRack.rack[index].name
        }
    }
    

}
