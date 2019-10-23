//
//  EventregistrationController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 03/06/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import SafariServices
import UIKit

class EventregistrationController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Lukk", style: .plain, target: self, action:
            #selector(handleDismiss))
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        
        let attrText = NSMutableAttributedString()
        attrText.append(NSAttributedString(string: "Legg til Event\n", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.kindaBlack
        ]))
        
        attrText.append(NSAttributedString(string: "Alle eventer på lista er lagt til fra tredje part eller Oslo Pride gjennom Eventregistration", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.graySuit
        ]))
        
        label.attributedText = attrText
        view.addSubview(label)
        [
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 6)
        ].forEach { $0.isActive = true }
        
        let butt = UIButton(type: .system)
        butt.translatesAutoresizingMaskIntoConstraints = false
        butt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        butt.layer.borderColor = UIColor.prideDeepPurple.cgColor
        butt.layer.cornerRadius = 5
        butt.layer.borderWidth = 2
        butt.tintColor = .prideDeepPurple
        butt.addTarget(self, action: #selector(presentEventregistration), for: .touchUpInside)
        butt.setTitle("  Gå til registreringen  ", for: .normal)
        
        view.addSubview(butt)
        [
            butt.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            butt.centerXAnchor.constraint(equalTo: label.centerXAnchor)
        ].forEach { $0.isActive = true }
    }
    
    @objc fileprivate func presentEventregistration() {
        guard let url = URL(string: "https://www.oslopride.no/a/registrering-av-arrangement") else { return }
        let sf = SFSafariViewController(url: url)
        present(sf, animated: true) {
            // self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
}
