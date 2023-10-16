//
//  Task.swift
//  ToDoList
//
//  Created by Everett Brothers on 9/22/23.
//

import Foundation
import UIKit

struct Task: Codable {
    var name: String
    var priority: Double
    var date: Date
}

struct ToSave: Codable {
    var username: String
    var tasks: [Task]
}

struct Logins: Codable {
    var username: String
    var password: String
}
