//
//  CreateTaskViewController.swift
//  ToDoList
//
//  Created by Everett Brothers on 9/22/23.
//

import UIKit

class CreateTaskViewController: UIViewController {

    @IBOutlet weak var prioritySlider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Task"
        datePicker.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchFlipped(_ sender: Any) {
        if notificationSwitch.isOn {
            datePicker.isHidden = false
            datePicker.contentHorizontalAlignment = .center
        } else {
            datePicker.isHidden = true
        }
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        sliderLabel.text = String(floor(Double(prioritySlider.value * 10)) / 10)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewController {
            vc.name = nameField.text ?? "Task"
            vc.priority = Double(prioritySlider.value)
            vc.date = datePicker.date
            vc.notification = notificationSwitch.isOn
        }
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
