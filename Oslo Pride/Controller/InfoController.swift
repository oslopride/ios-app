//
//  InfoController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 10/06/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit
import SafariServices

class InfoController: UIViewController {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        //stackView.distribution = .fillEqually
        
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 1000)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        [
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
        
        let image = UIImageView(image: UIImage(named: "prideheart"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        scrollView.addSubview(image)
        [
            image.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 200),
            image.widthAnchor.constraint(equalToConstant: 200),
            ].forEach { $0.isActive = true }
        
        let descLabel = UILabel()
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.numberOfLines = 0
        descLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descLabel.textAlignment = .center
        scrollView.addSubview(descLabel)
        descLabel.text = "Oslo Pride er Norges største feiring av skeiv kjærlighet og mangfold. En ti-dagers festival hvor alle har lov til å være akkurat den de er."
        [
            descLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            descLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            descLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 24),
            ].forEach { $0.isActive = true }
        
        let fLabel = UILabel()
        fLabel.translatesAutoresizingMaskIntoConstraints = false
        fLabel.numberOfLines = 0
        fLabel.font = UIFont.boldSystemFont(ofSize: 16)
        fLabel.textAlignment = .center
        fLabel.text = "Oslo Pride er drevet av frivillige."
        scrollView.addSubview(fLabel)
        [
            fLabel.leftAnchor.constraint(equalTo: descLabel.leftAnchor),
            fLabel.rightAnchor.constraint(equalTo: descLabel.rightAnchor),
            fLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 24),
            ].forEach { $0.isActive = true }

        let butt = UIButton(type: .system)
        butt.translatesAutoresizingMaskIntoConstraints = false
        butt.setTitle("Bli Frivillig", for: .normal)
        butt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        butt.addTarget(self, action: #selector(presentFrivillig), for: .touchUpInside)
        scrollView.addSubview(butt)
        [
            butt.leftAnchor.constraint(equalTo: fLabel.leftAnchor),
            butt.rightAnchor.constraint(equalTo: fLabel.rightAnchor),
            butt.topAnchor.constraint(equalTo: fLabel.bottomAnchor, constant: 10),
            
            ].forEach { $0.isActive = true }
        
        let mainSponsorLabel = UILabel()
        mainSponsorLabel.translatesAutoresizingMaskIntoConstraints = false
        mainSponsorLabel.numberOfLines = 0
        mainSponsorLabel.font = UIFont.boldSystemFont(ofSize: 16)
        //mainSponsorLabel.textAlignment = .center
        mainSponsorLabel.text = "Hovedpartnere"
        scrollView.addSubview(mainSponsorLabel)
        [
            mainSponsorLabel.leftAnchor.constraint(equalTo: descLabel.leftAnchor),
            mainSponsorLabel.rightAnchor.constraint(equalTo: descLabel.rightAnchor),
            mainSponsorLabel.topAnchor.constraint(equalTo: butt.bottomAnchor, constant: 54),
            ].forEach { $0.isActive = true }
        let mainSponsor = UIStackView()
        mainSponsor.translatesAutoresizingMaskIntoConstraints = false
        mainSponsor.distribution = .fillEqually
        scrollView.addSubview(mainSponsor)
        [
            mainSponsor.leftAnchor.constraint(equalTo: butt.leftAnchor),
            mainSponsor.rightAnchor.constraint(equalTo: butt.rightAnchor),
            mainSponsor.topAnchor.constraint(equalTo: mainSponsorLabel.bottomAnchor, constant: 10),
            mainSponsor.heightAnchor.constraint(equalToConstant: 100)
            ].forEach { $0.isActive = true }
        
        [UIImage(named: "choice"), UIImage(named: "nordea")].forEach { (img) in
            let imgView = UIImageView(image: img)
            imgView.contentMode = .scaleAspectFit
            mainSponsor.addArrangedSubview(imgView)
        }
        
        
        let sponsorLabel = UILabel()
        sponsorLabel.translatesAutoresizingMaskIntoConstraints = false
        sponsorLabel.numberOfLines = 0
        sponsorLabel.font = UIFont.boldSystemFont(ofSize: 16)
        //mainSponsorLabel.textAlignment = .center
        sponsorLabel.text = "Partnere"
        scrollView.addSubview(sponsorLabel)
        [
            sponsorLabel.leftAnchor.constraint(equalTo: descLabel.leftAnchor),
            sponsorLabel.rightAnchor.constraint(equalTo: descLabel.rightAnchor),
            sponsorLabel.topAnchor.constraint(equalTo: mainSponsor.bottomAnchor, constant: 54),
            ].forEach { $0.isActive = true }
        let sponsor = UIStackView()
        sponsor.translatesAutoresizingMaskIntoConstraints = false
        sponsor.distribution = .fillEqually
        scrollView.addSubview(sponsor)
        [
            sponsor.leftAnchor.constraint(equalTo: butt.leftAnchor),
            sponsor.rightAnchor.constraint(equalTo: butt.rightAnchor),
            sponsor.topAnchor.constraint(equalTo: sponsorLabel.bottomAnchor, constant: 10),
            sponsor.heightAnchor.constraint(equalToConstant: 100),
            sponsor.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -100)
            ].forEach { $0.isActive = true }
        
        [UIImage(named: "oslo"), UIImage(named: "skittles"), UIImage(named: "mobile")].forEach { (img) in
            let imgView = UIImageView(image: img)
            imgView.contentMode = .scaleAspectFit
            sponsor.addArrangedSubview(imgView)
        }
        
        
    }
    
    @objc fileprivate func presentFrivillig() {
        guard let url = URL(string: "https://www.oslopride.no/a/engasjer-deg-i-oslo-pride") else { return }
        let safari = SFSafariViewController(url: url)
        present(safari, animated: true, completion: nil)
    }
    
    func label(_ here: @escaping (UILabel) -> ()) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(label)
        here(label)
        //stackView.addArrangedSubview(label)
    }
    
    
}
