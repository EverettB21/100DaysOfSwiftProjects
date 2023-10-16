//
//  SecondViewController.swift
//  ManageFinance
//
//  Created by Everett Brothers on 9/7/23.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var subscriptionButton: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    var cost = 0.0
    var type = ""
    var name = ""
    var id: UUID!
    var subSave = Text(text: "")
    var dateSave = Text(text: "")
    var saves = Texts(texts: [Text(text: ""), Text(text: "")])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saves.id = id
        costLabel.text = "$\(cost)"
        typeLabel.text = type
        
        load()
        
        subSave.text = saves.texts[0].text
        dateSave.text = saves.texts[1].text
        
        dateButton.setTitle(dateSave.text, for: .normal)
        subscriptionButton.setTitle(subSave.text, for: .normal)
        if dateButton.currentTitle == "" {
            dateButton.setTitle("Set Date", for: .normal)
        }
        if subscriptionButton.currentTitle == "" {
            subscriptionButton.setTitle("Set Subscription", for: .normal)
        }
    }
    
    
    @IBAction func dateTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Set Date", message: "\n\n\n", preferredStyle: .alert)
        
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "en_US")
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        ac.view.addSubview(datePicker)
        datePicker.center.y += 50
        datePicker.center.x += 23
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let select = UIAlertAction(title: "Select", style: .default) { [weak self] _ in
            let selectedDate = datePicker.date
            self?.handleSelectedDate(selectedDate)
        }
        
        ac.addAction(cancel)
        ac.addAction(select)
        
        present(ac, animated: true)
    }
    
    func handleSelectedDate(_ date: Date) {
        let formattedDate = date.formatted()
        
        dateButton.setTitle(formattedDate, for: .normal)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
    }
    
    @IBAction func subscriptionTapped(_ sender: Any) {
        let acs = UIAlertController(title: "Set Subscription", message: nil, preferredStyle: .actionSheet)
        let ac = UIAlertController(title: "Other", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let enter = UIAlertAction(title: "Enter", style: .default) { [weak self, weak ac] _ in
            self?.setSub(type: ac?.textFields?[0].text ?? "Error")
        }
        ac.addAction(enter)
        
        let none = UIAlertAction(title: "None", style: .default) { [weak self] _ in
            self?.setSub(type: "None")
        }
        
        let weekly = UIAlertAction(title: "Weekly", style: .default) { [weak self] _ in
            self?.setSub(type: "Weekly")
        }
        
        let monthly = UIAlertAction(title: "Monthly", style: .default) { [weak self] _ in
            self?.setSub(type: "Monthly")
        }
        
        let yearly = UIAlertAction(title: "Annual", style: .default) { [weak self] _ in
            self?.setSub(type: "Annual")
        }
        
        let other = UIAlertAction(title: "Other", style: .default) { _ in
            self.present(ac, animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        acs.addAction(none)
        acs.addAction(weekly)
        acs.addAction(monthly)
        acs.addAction(yearly)
        acs.addAction(other)
        acs.addAction(cancel)
        
        present(acs, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        subSave.text = subscriptionButton.currentTitle ?? "Error"
        dateSave.text = dateButton.currentTitle ?? "Error"
        saves = Texts(texts: [subSave, dateSave], id: id)
        save()
    }
    
    func save() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(saves)
            UserDefaults.standard.set(data, forKey: "\(saves.id)")
            print("Saved Sucessfully")
        } catch {
            print("Error Encoding")
        }
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: "\(saves.id)") {
            do{
                let decoder = JSONDecoder()
                saves = try decoder.decode(Texts.self, from: data)
                print(saves)
            } catch {
                print("Error in decoding process")
            }
        }
    }
    
    func setSub(type: String) {
        subscriptionButton.setTitle(type, for: .normal)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
