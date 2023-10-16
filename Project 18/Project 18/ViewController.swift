//
//  ViewController.swift
//  Project 18
//
//  Created by Everett Brothers on 10/4/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("inside viewdidload")
        
        for num in 0...100 {
            print(num)
        }
        
        assert(1 == 1, "failed")
    }


}

