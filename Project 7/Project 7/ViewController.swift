//
//  ViewController.swift
//  Project 7
//
//  Created by Everett Brothers on 9/28/23.
//

import UIKit

class ViewController: UITableViewController {

    var petitions: [Petition] = []
    var filtered: [Petition] = []
    var urlString = ""
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        resetButton.isHidden = true
        
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            } else {
                showError()
            }
        } else {
            showError()
        }
        
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        filtered = petitions
        tableView.reloadData()
        resetButton.isHidden = true
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        ac.addTextField { text in
            text.placeholder = "type here"
            text.keyboardType = .alphabet
        }
        
        let submit = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            let text = ac?.textFields?.first?.text
            self?.submit(search: text ?? "")
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(submit)
        present(ac, animated: true)
    }
    
    func submit(search: String) {
        resetButton.isHidden = false
        filtered = []
        let searchString = search.lowercased()
        for petition in petitions {
            let titleString = petition.title.lowercased()
            let bodyString = petition.body.lowercased()
            if  titleString.contains(searchString) || bodyString.contains(searchString) {
                filtered.append(petition)
            }
        }
        if filtered.isEmpty {
            let pet = Petition(title: "No Items Found", body: "Could not find \(search) in any Petitions", signatureCount: 0)
            filtered.append(pet)
        }
        tableView.reloadData()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was an error loading the feed; Check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filtered = petitions
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let petition = filtered[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filtered[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}

