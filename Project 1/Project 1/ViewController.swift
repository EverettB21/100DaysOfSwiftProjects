//
//  ViewController.swift
//  Project 1
//
//  Created by Everett Brothers on 9/27/23.
//

import UIKit

class ViewController: UITableViewController {

    var pictures: [String] = []
    var currentImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "pics")
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            vc.image = currentImage
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pics", for: indexPath) as! MyCell
        cell.image.setImage( UIImage(named: pictures[indexPath.row]), for: .normal)
        cell.buttonTapped = { [weak self] in
            self?.currentImage = self?.pictures[indexPath.row] ?? ""
            self?.performSegue(withIdentifier: "toImage", sender: nil)
        }
        return cell
    }


}

