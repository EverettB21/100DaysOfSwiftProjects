//
//  MyCell.swift
//  ToDoList
//
//  Created by Everett Brothers on 9/25/23.
//

import Foundation
import UIKit

class MyCell: UITableViewCell {
    var buttonSwiped: () -> () = { }
    var buttonTapped: () -> () = { }
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        return btn
    }()
    
    @objc func didSwipeButton() {
        buttonSwiped()
    }
    
    @objc func didTapButton() {
        buttonTapped()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didSwipeButton), for: .touchDragInside)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

