//
//  MyCell.swift
//  Project 1
//
//  Created by Everett Brothers on 9/27/23.
//

import Foundation
import UIKit

class MyCell: UITableViewCell{
    var image = UIButton()
    var buttonTapped: () -> () = { }
    
    @objc func didTap() {
        buttonTapped()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(image)
        image.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("Failed to init")
    }
}
