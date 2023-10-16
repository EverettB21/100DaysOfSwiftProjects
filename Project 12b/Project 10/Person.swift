//
//  Person.swift
//  Project 10
//
//  Created by Everett Brothers on 9/29/23.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
