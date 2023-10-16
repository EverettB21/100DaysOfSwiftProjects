//
//  ViewController.swift
//  Project 4
//
//  Created by Everett Brothers on 9/27/23.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var urlText: UITextField!
    var webView: WKWebView!
    var midview: UIView!
    @IBOutlet weak var exitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        midview = view
        webView.navigationDelegate = self
        exitButton.isHidden = true
        
    }

    @IBAction func closeTapped(_ sender: Any) {
        view = midview
        exitButton.isHidden = true
    }
    
    @IBAction func goTapped(_ sender: Any) {
        guard var text = urlText.text else {
            return
        }
        if !text.hasPrefix("https://") {
            text = "https://\(text)"
        }
        if !text.hasSuffix(".com") {
            text = "\(text).com"
        }
        exitButton.isHidden = false
        let url = URL(string: text) ?? URL(string: "Error")
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
        exitButton?.topAnchor.constraint(equalTo: exitButton!.topAnchor, constant: 5).isActive = true
        exitButton?.trailingAnchor.constraint(equalTo: exitButton!.trailingAnchor, constant: -5).isActive = true
        webView.addSubview(exitButton)
        view = webView
    }
    
}

