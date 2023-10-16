//
//  ViewController.swift
//  ManageFinance
//
//  Created by Everett Brothers on 9/6/23.
//

import UIKit
import Foundation

class ViewController: UITableViewController {

    var expenses: [Expense] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadExpenses()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExpense))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(remove))
        navigationItem.leftBarButtonItem?.tintColor = .systemRed
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "Finance")
        
        tableView.allowsSelection = false
        
        tableView.reloadData()
    }
    
    @objc func remove() {
        if expenses.isEmpty {
            return
        } else {
            print("Item removed")
            expenses.remove(at: 0)
            saveExpenses()
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func saveExpenses() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(expenses)
            UserDefaults.standard.set(data, forKey: "expenses")
        } catch {
            print("Error Encoding")
        }
    }
    
    func loadExpenses() {
        if let data = UserDefaults.standard.data(forKey: "expenses") {
            do{
                let decoder = JSONDecoder()
                expenses = try decoder.decode([Expense].self, from: data)
            } catch {
                print("Error in decoding process")
            }
        }
    }
    
    @objc func addExpense() {
        let ac = UIAlertController(title: "Add Expense", message: nil, preferredStyle: .alert)
        let typeActionSheet = UIAlertController(title: "ExpenseType", message: nil, preferredStyle: .actionSheet)
        var name = ""
        var cost = 0.0
        
        ac.addTextField { textField in
            textField.placeholder = "Expense Name"
            textField.keyboardType = .default
        }
        ac.addTextField { textField in
            textField.placeholder = "Expense Cost"
            textField.keyboardType = .decimalPad
        }
        
        ac.addAction(UIAlertAction(title: "Select Type", style: .default) { [weak ac] _ in
            name = ac?.textFields?[0].text ?? ""
            cost = Double(ac?.textFields?[1].text ?? "0") ?? 0
            self.present(typeActionSheet, animated: true, completion: nil)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let personalAction = UIAlertAction(title: "Personal", style: .default) { [weak self] _ in
            self?.enter(name: name, cost: cost, type: "Personal")
        }
        
        let buisnessAction = UIAlertAction(title: "Buisness", style: .default) { [weak self] _ in
            self?.enter(name: name, cost: cost, type: "Business")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
        typeActionSheet.addAction(personalAction)
        typeActionSheet.addAction(buisnessAction)
        typeActionSheet.addAction(cancelAction)
        
        present(ac, animated: true)
    }
    
    func enter(name: String, cost: Double, type: String) {
        print("Item added")
        expenses.insert(Expense(name: name, cost: cost, type: type), at: 0)
        saveExpenses()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Finance", for: indexPath) as! MyCell
        let name = expenses[indexPath.row]
        cell.label.text = "\(expenses[indexPath.row].name):\t$\(expenses[indexPath.row].cost)"
        
        if expenses[indexPath.row].type == "Personal" {
            cell.button.setTitleColor(.systemBlue, for: .normal)
            cell.button.backgroundColor = .none
            cell.backgroundColor = .orange
        } else if expenses[indexPath.row].type == "Business" {
            cell.button.setTitleColor(.systemBlue, for: .normal)
            cell.button.backgroundColor = .none
            cell.backgroundColor = .systemGreen
        }
        
        cell.buttonTapCallback = {
            self.performSegue(withIdentifier: "toInfo", sender: name)
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let expenses = sender as? Expense {
            let name = expenses.name
            segue.destination.navigationItem.title = name
            if segue.destination is SecondViewController {
                let vc = segue.destination as? SecondViewController
                vc?.cost = expenses.cost
                vc?.type = expenses.type
                vc?.name = expenses.name
                vc?.id = expenses.id
            }
        } else {
            segue.destination.navigationItem.title = "Expense"
        }
        
    }
    
    
}

