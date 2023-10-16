//
//  ViewController.swift
//  ToDoList
//
//  Created by Everett Brothers on 9/22/23.
//

import UIKit
import UserNotifications

class ViewController: UITableViewController {

    var titleString = ""
    var login: Logins = Logins(username: "", password: "")
    var tasks: [Task] = []
    var curTask: Task!
    var name = ""
    var priority = 0.0
    var notification = false
    var date = Date()
    var first = false
    var content = UNMutableNotificationContent()
    var trigger: UNTimeIntervalNotificationTrigger!
    
    @IBAction func unwindToTable(segue: UIStoryboardSegue) {
        
    }
    
    func createNotification(time: Double) {
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        let request = UNNotificationRequest(identifier: "task", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("Error creating notification")
            } else {
                print("Success creating notification")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        if titleString == "" {
            titleString = "To-Do"
        }
        navigationItem.title = "\(titleString)'s Tasks"
        
        load()
    }
    
    @objc func close() {
        save()
        performSegue(withIdentifier: "unwindToLogin", sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        first = true
    }
    
    func save() {
        let encoder = JSONEncoder()
        let toSave = ToSave(username: login.username, tasks: tasks)
        if let data = try? encoder.encode(toSave) {
            UserDefaults.standard.set(data, forKey: "\(login.username)")
        }
    }
    
    func load() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "\(login.username)") {
            if let loadedData = try? decoder.decode(ToSave.self, from: data) {
                tasks = loadedData.tasks
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if first == true {
            tasks.insert(Task(name: name, priority: priority, date: date), at: 0)
            save()
            let index = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [index], with: .automatic)
            tableView.reloadData()
        }
        if notification {
            content.title = "\(name)"
            content.body = "Your task is due"
            content.sound = .default
            let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
            let hr = ((components.hour ?? 0) * 60 * 60)
            let min = (components.minute ?? 0) * 60
            let interval = Double(hr + min + (components.second ?? 0))
            createNotification(time: interval)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LoginViewController {
            vc.tasks = self.tasks
        }
        if let dvc = segue.destination as? DataViewController {
            dvc.task = curTask
        }
    }
    
    @objc func addTask() {
        performSegue(withIdentifier: "createTask", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func remove(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tasks.remove(at: index)
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
        let currentTask = tasks[indexPath.row]
        cell.button.setTitle("\(currentTask.name)", for: .normal)
        cell.button.layer.cornerRadius = 20
        cell.backgroundColor = .darkGray
        switch currentTask.priority {
        case 0:
            cell.backgroundColor = .darkGray
            cell.button.backgroundColor = .darkGray
        case 0.01 ... 0.25:
            cell.button.backgroundColor = .lightGray
            cell.button.setTitleColor(.darkGray, for: .normal)
        case 0.25 ... 0.75:
            cell.button.backgroundColor = .orange
            cell.button.setTitleColor(.black, for: .normal)
        case 0.75 ... 1:
            cell.button.backgroundColor = .red
            cell.button.setTitleColor(.black, for: .normal)
        default:
            cell.button.backgroundColor = .darkGray
            cell.button.setTitleColor(.darkGray, for: .normal)
        }
        cell.buttonSwiped = { [weak self] in
            if self?.tasks.count ?? 0 > 0 {
                self?.remove(index: self?.tasks.firstIndex(where: {$0.name.contains(currentTask.name)}) ?? 0)
                self?.save()
            }
        }
        cell.buttonTapped = { [weak self] in
            self?.curTask = currentTask
            self?.performSegue(withIdentifier: "toData", sender: nil)
        }
        
        return cell
    }
}

