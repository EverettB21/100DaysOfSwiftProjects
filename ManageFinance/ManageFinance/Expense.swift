//
//  Expense.swift
//  ManageFinance
//
//  Created by Everett Brothers on 9/6/23.
//

import Foundation


struct Expense: Identifiable, Codable {
    var name: String
    var cost: Double
    var type: String
    var id = UUID()
}

struct Text: Codable {
    var text: String
}

struct Texts: Codable {
    var texts: [Text]
    var id = UUID()
}
