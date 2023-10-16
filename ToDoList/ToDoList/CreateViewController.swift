//
//  CreateViewController.swift
//  ToDoList
//
//  Created by Everett Brothers on 9/22/23.
//

import UIKit

class CreateViewController: UIViewController {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    var logins: [Logins] = []
    var newLogin = Logins(username: "", password: "")
    var message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkLabel.text = "Password requires:\nSpecial Character\nUppercase Letter\nLowercase Letter\nNumber\n>8 in Length"
    }
    
    @IBAction func createClicked(_ sender: Any) {
        if checkUser() && checkPass() {
            newLogin = Logins(username: userField.text!, password: passField.text!)
            logins.append(newLogin)
            save()
            performSegue(withIdentifier: "createLogin", sender: nil)
        } else {
            invalid()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewController {
            vc.titleString = userField.text ?? ""
            vc.login = newLogin
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(logins) {
            UserDefaults.standard.set(data, forKey: "Logins")
        }
    }
    
    func checkUser() -> Bool {
        if let user = userField.text {
            if !user.isEmpty {
                for login in logins {
                    if user == login.username {
                        return false
                    }
                }
                return true
            } else {
                message = "Enter a username"
            }
        }
        return false
    }
    
    func invalid() {
        errorLabel.text = message
    }
    
    func checkPass() -> Bool {
        if let pass = passField.text {
            if !(pass.isEmpty) {
                if (pass.contains("!") || pass.contains("@") || pass.contains("#") || pass.contains("$") || pass.contains("%") || pass.contains("&") || pass.contains("?") || pass.contains("~")) {
                    if (pass.contains("1") || pass.contains("2") || pass.contains("3") || pass.contains("4") || pass.contains("5") || pass.contains("6") || pass.contains("7") || pass.contains("8") || pass.contains("9") || pass.contains("0")) {
                        if pass.count > 8 {
                            if pass.lowercased() != pass {
                                return true
                            } else {
                                message = "Use Capital letter"
                            }
                        } else {
                            message = "Make password longer"
                        }
                    } else {
                        message = "Use a number"
                    }
                } else {
                    message = "Use a special character"
                }
            } else {
                message = "Enter a Password"
            }
        }
        return false
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
