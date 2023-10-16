//
//  PersonCell.swift
//  Project 10
//
//  Created by Everett Brothers on 9/29/23.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    @IBOutlet var button: PersonButton!
    @IBOutlet var name: UILabel!
    
}

class PersonButton: UIButton {
    
    @IBOutlet var personImage: UIImageView!
    
}
