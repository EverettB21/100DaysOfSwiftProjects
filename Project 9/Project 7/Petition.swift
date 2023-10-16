//
//  Petition.swift
//  Project 7
//
//  Created by Everett Brothers on 9/28/23.
//

import Foundation


struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}
