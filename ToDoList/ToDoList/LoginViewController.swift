//
//  LoginViewController.swift
//  ToDoList
//
//  Created by Everett Brothers on 9/22/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var checkLabel: UILabel!
    
    var logins: [Logins] = []
    var login: Logins = Logins(username: "", password: "")
    var message = ""
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLogin()
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func createClicked(_ sender: Any) {
        performSegue(withIdentifier: "createUser", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateViewController {
            vc.logins = self.logins
        }
        if let nc = segue.destination as? UINavigationController {
            if let vc = nc.viewControllers.first as? ViewController {
                vc.titleString = login.username
                vc.login = login
            }
        }
    }
    
    func loadLogin() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "Logins") {
            if let loaded = try? decoder.decode([Logins].self, from: data) {
                logins = loaded
            }
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        guard let pass = passField.text else {
            invalid()
            return }
        guard let user = userField.text else {
            invalid()
            return }
        for login in logins {
            if user == login.username && pass == login.password {
                self.login = Logins(username: login.username, password: login.password)
                performSegue(withIdentifier: "login", sender: nil)
                return
            }
        }
        invalid()
    }
        func invalid() {
            message = "Invalid Username or Password"
            checkLabel.text = message
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
