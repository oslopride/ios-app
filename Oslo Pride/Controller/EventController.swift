//
//  EventController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 12/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit
import WebKit

class EventController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        
        guard let url = URL(string: "https://2018.oslopride.no/arrangementer/fredagen-girls-club-og-dramaqueen/") else { return }
        let req = URLRequest(url: url)
        webView.load(req)
        
        
        view.addSubview(webView)
        [
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
        
        
    }
    
    
    
}
