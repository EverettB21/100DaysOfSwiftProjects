//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Everett Brothers on 9/27/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var countries: [String] = []
    var score = 0
    var correct = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries.append("estonia")
        countries.append("france")
        countries.append("germany")
        countries.append("ireland")
        countries.append("italy")
        countries.append("monaco")
        countries.append("nigeria")
        countries.append("poland")
        countries.append("russia")
        countries.append("spain")
        countries.append("uk")
        countries.append("us")
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        countries.shuffle()
        newGame()
    }

    func newGame() {
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        correct = Int.random(in: 0...2)
        flagLabel.text = countries[correct].uppercased()
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        if sender.tag == correct {
            flagLabel.text = "Correct!"
            score += 5
            scoreLabel.text = "Score: \(score)"
        } else {
            flagLabel.text = "Wrong!"
            score -= 3
            scoreLabel.text = "Score: \(score)"
        }
        let ac = UIAlertController(title: flagLabel.text, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default))
        present(ac, animated: true)
        countries.shuffle()
        newGame()
    }
    
}

