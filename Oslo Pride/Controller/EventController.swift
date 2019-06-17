//
//  EventController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 12/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit
import WebKit
import SafariServices
import MapKit
import CoreLocation

class EventController: UIViewController {
    
    var event: Event? {
        didSet {
            setupUI()
        }
    }
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "trekanter")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 9
        imageView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        //imageView.layer.cornerCurve = .continuous
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .darkGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return descriptionLabel
    }()
    
    let toggleFavouriteButton: UIButton = {
        let toggleFavouriteButton = UIButton(type: .system)
        toggleFavouriteButton.setImage(UIImage(named: "star_twotone_large"), for: .normal)
        toggleFavouriteButton.translatesAutoresizingMaskIntoConstraints = false
        toggleFavouriteButton.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
        toggleFavouriteButton.tintColor = .prideGreen
        
        return toggleFavouriteButton
    }()
    
    let presentSalesWebpageButton: UIButton = {
        let webpageButton = UIButton(type: .system)
        //webpageButton.setImage(UIImage(named: "store"), for: .normal)
        webpageButton.titleLabel?.numberOfLines = 2
        webpageButton.setTitle("🎟\nSkaff Billett", for: .normal)
        webpageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        webpageButton.titleLabel?.textAlignment = .center
        webpageButton.tintColor = .prideRed
        //webpageButton.tintColor = .pridePurple
        webpageButton.addTarget(self, action: #selector(displaySalesWebpage), for: .touchUpInside)
        
        return webpageButton
    }()
    
    let actionsStackView : UIStackView = {
        let actionsStack = UIStackView()
        actionsStack.translatesAutoresizingMaskIntoConstraints = false
        actionsStack.distribution = .fillEqually
        actionsStack.axis = .vertical
        
        return actionsStack
    }()
    
    let detailsStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()

    let descriptionStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var mapView : MKMapView = {

        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.layer.cornerRadius = 5
        mv.clipsToBounds = true
        //mv.isUserInteractionEnabled = false
        mv.userTrackingMode = .follow
        mv.showsUserLocation = true
        mv.delegate = self
        
        return mv
    }()

    var showDismissButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationItems()
        setupLayout()
        print("Event Venue: ", event?.venue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    lazy var favoriteBarButtonItem = UIBarButtonItem(image: (event?.isFavourite ?? false) ? UIImage(named: "star_cross") : UIImage(named: "star_border"), style: .plain, target: self, action: #selector(toggleFavourite))
    
    fileprivate func setupNavigationItems() {
        var right = [
            UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareEvent)),
            favoriteBarButtonItem
            //UIBarButtonItem(image: (event?.isFavourite ?? false) ? UIImage(named: "star_cross") : UIImage(named: "star_border"), style: .plain, target: self, action: #selector(toggleFavourite))
        ]
        
        if let _ = event?.ticketSaleWebpage {
            let ticket = UIBarButtonItem(title: "🎟 Billett", style: .plain, target: self, action: #selector(displaySalesWebpage))
            ticket.tintColor = .prideRed
            right.append(ticket)
        }
        
        navigationItem.rightBarButtonItems = right
        if showDismissButton {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Lukk", style: .plain, target: self, action: #selector(handleDismiss))
        }
    }
    
    @objc fileprivate func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func shareEvent() {
        guard let id = event?.id else { return }
        guard let eventURLString = URL(string: "https://www.oslopride.no/events/\(id)") else { return }
        let shareController = UIActivityViewController(activityItems: [eventURLString], applicationActivities: [])
        present(shareController, animated: true, completion: nil)
    }
    
    var eventLocation: CLLocationCoordinate2D? {
        didSet {
            guard let eventLocation = eventLocation else { return }
            setCamera(to: eventLocation)
        }
    }
    
    var distanceDetail = UILabel()
    
    fileprivate func setupUI() {
        distanceDetail = createDetail(main: "Distanse", secondary: "-")
        
        guard let event = event else { return }
        
        titleLabel.text = event.title
        
        // Display description
        descriptionLabel.text = event.eventDescription

        // Display Image if present
        if let imageData = event.image, let image = UIImage(data: imageData) {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
        
        let categoryLabel = UILabel()
        categoryLabel.numberOfLines = 2
        let categoryAttrText = NSMutableAttributedString()
        categoryAttrText.append(event.categoryName())
        if let venue = event.venue {
            categoryAttrText.append(NSAttributedString(string: "\n\(venue)", attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.graySuit
                ]))
        }
        
        categoryLabel.attributedText = categoryAttrText//event.categoryName()
        categoryLabel.textAlignment = .right
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        actionsStackView.addArrangedSubview(categoryLabel)
        
        let placeLabel = UILabel()
        placeLabel.text = event.locationName
        placeLabel.textAlignment = .right
        placeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        placeLabel.textColor = .graySuit
        placeLabel.numberOfLines = 0

        // Setup details stackview
        if let start = event.startingTime, let end = event.endingTime {
            let dateLabel = UILabel()
            dateLabel.numberOfLines = 0
            dateLabel.setupEventDateLabel(start: start, end: end)
            detailsStackView.addArrangedSubview(dateLabel)
        }

        let freeDetail = createDetail(main: "Gratis", secondary: event.free ? "Ja" : "Nei")
        descriptionStackView.addArrangedSubview(freeDetail)
        
        let organizerDetail = createDetail(main: "Arrangør", secondary: event.organizer ?? "Ikke Oppgitt")
        descriptionStackView.addArrangedSubview(organizerDetail)
    
        let deafInterpretationDetail = createDetail(main: "Tegnspråktolket", secondary: (event.deafInterpretation ? "Ja" : "Nei"))
        descriptionStackView.addArrangedSubview(deafInterpretationDetail)
        
        let ageLimitDetail = createDetail(main: "Aldersgrense", secondary: event.ageLimitString())
        descriptionStackView.addArrangedSubview(ageLimitDetail)
        
        let accessability = createDetail(main: "Rullestolvennlig", secondary: event.accessible ? "Ja" : "Nei")
        descriptionStackView.addArrangedSubview(accessability)
        
        let placeDetail = createDetail(main: "Sted", secondary: "\(event.locationName ?? "")\n\(event.locationAddress ?? "")")
        descriptionStackView.addArrangedSubview(placeDetail)
        descriptionStackView.addArrangedSubview(distanceDetail)
        
        
        if let coordinate = event.coordinates() {
            eventLocation = coordinate
            updateDistance(userLocation: mapView.userLocation)
        } else {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(event.locationAddress ?? "") { (placemark, err) in
                if let err = err {
                    print("Failed to find location: ", err)
                    return
                }
                if let coordinate = placemark?.first?.location?.coordinate {
                    self.eventLocation = coordinate
                    self.updateDistance(userLocation: self.mapView.userLocation)
                    CoreDataManager.shared.updateCoordinates(event: event, lat: coordinate.latitude, long: coordinate.longitude) { (err) in
                        if let err = err {
                            print("Oh no: ", err)
                            return
                        }
                        print("Did update coordinate")
                    }
                }
            }
        }
        
    }
    
    fileprivate func setCamera(to: CLLocationCoordinate2D) {
        let camera = MKMapCamera(lookingAtCenter: to, fromDistance: 5000, pitch: 0, heading: 0)
        self.mapView.setCamera(camera, animated: false)
        let notation = PrideAnnotation(title: event?.title ?? "", lat: to.latitude, long: to.longitude)
        self.mapView.addAnnotation(notation)
    }
    
    fileprivate func updateDistance(userLocation: MKUserLocation) {
        if let userLocation = userLocation.location, let eventLocation = eventLocation {
            let distance = userLocation.distance(from: CLLocation(latitude: eventLocation.latitude, longitude: eventLocation.longitude))
            
            let request = MKDirections.Request()
            let toPlacemark = MKPlacemark(coordinate: eventLocation)
            let toItem = MKMapItem(placemark: toPlacemark)
            request.destination = toItem
            
            let fromPlacemark = MKPlacemark(coordinate: userLocation.coordinate)
            let fromItem = MKMapItem(placemark: fromPlacemark)
            request.source = fromItem
            request.transportType = .walking
            
            let directions = MKDirections(request: request)
            directions.calculateETA { (eta, err) in
                if let err = err {
                    print("Failed to get directions: ", err)
                    self.distanceDetail.attributedText = self.createDetail(main: "Distanse", secondary: "\(Int(distance)) meter").attributedText
                    return
                }
                self.distanceDetail.attributedText = self.createDetail(main: "Distanse", secondary: "\(Int(eta?.distance ?? 0)) meter\n\(Int((eta?.expectedTravelTime ?? 0) / 60)) minutter i ganghastighet").attributedText
            }
        }
    }

    fileprivate func createDetail(main: String, secondary: String) -> UILabel {
        let accessLabel = UILabel()
        accessLabel.font = UIFont.boldSystemFont(ofSize: 16)
        accessLabel.numberOfLines = 0
        let accessAttrLabel = NSMutableAttributedString()
        accessAttrLabel.append(NSAttributedString(string: "\(main)" + "\n", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.kindaBlack,
            //NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
            ]))
        
        accessAttrLabel.append(NSAttributedString(string: secondary, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.graySuit,
            //NSAttributedString.Key.paragraphStyle : rightParagraph
            //NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
            ]))
        accessLabel.attributedText = accessAttrLabel
        
        return accessLabel
    }
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        [
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }

        scrollView.addSubview(imageView)
        [
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalToConstant: (view.frame.width*0.618033989) - 20)
            ].forEach { $0.isActive = true }
        
        scrollView.addSubview(titleLabel)
        [
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 18),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            ].forEach { $0.isActive = true }
        
        scrollView.addSubview(detailsStackView)
        [
            detailsStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            detailsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            detailsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            detailsStackView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -24)
            ].forEach { $0.isActive = true }

        scrollView.addSubview(actionsStackView)
        [
            actionsStackView.centerYAnchor.constraint(equalTo: detailsStackView.centerYAnchor),
            actionsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            //actionsStackView.heightAnchor.constraint(equalToConstant: 55),
            actionsStackView.leftAnchor.constraint(equalTo: view.centerXAnchor)
            ].forEach { $0.isActive = true }
        
        scrollView.addSubview(descriptionLabel)
        [
            descriptionLabel.leftAnchor.constraint(equalTo: detailsStackView.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            descriptionLabel.topAnchor.constraint(equalTo: actionsStackView.bottomAnchor, constant: 24),
            //descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24)
            ].forEach { $0.isActive = true }
        
        let seperator = UIView()
        seperator.backgroundColor = .graySuit
        seperator.alpha = 0.5
        seperator.clipsToBounds = true
        seperator.layer.cornerRadius = 1
        
        seperator.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(seperator)
        [
            seperator.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            seperator.leftAnchor.constraint(equalTo: descriptionLabel.leftAnchor),
            seperator.rightAnchor.constraint(equalTo: descriptionLabel.rightAnchor),
            seperator.heightAnchor.constraint(equalToConstant: 2)
            ].forEach { $0.isActive = true }
        

        //detailsStackView.distribution = .fillEqually
        scrollView.addSubview(descriptionStackView)
        [
            descriptionStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            descriptionStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            descriptionStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
           // descriptionStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24)
            ].forEach { $0.isActive = true }
        
        scrollView.addSubview(mapView)
        [
            mapView.leftAnchor.constraint(equalTo: descriptionStackView.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: descriptionStackView.rightAnchor),
            mapView.topAnchor.constraint(equalTo: descriptionStackView.bottomAnchor, constant: 24),
            mapView.heightAnchor.constraint(equalToConstant: 250),
            mapView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -46)
            ].forEach { $0.isActive = true }

        
    }

    
    @objc fileprivate func displaySalesWebpage() {
        guard let url = event?.ticketSaleWebpage else { return }
        let controller = SFSafariViewController(url: url)
        present(controller, animated: true, completion: nil)
    }
    
    @objc fileprivate func toggleFavourite() {
        guard let event = event else { return }
        let feedback = UINotificationFeedbackGenerator()
        feedback.prepare()
        CoreDataManager.shared.toggleFavourite(event: event) { (err) in
            if let err = err {
                print("failed to save event: ", err)
                feedback.notificationOccurred(.error)
                return
            }
            DispatchQueue.main.async {
                feedback.notificationOccurred(.success)
                self.favoriteBarButtonItem.image = event.isFavourite ? UIImage(named: "star_cross") : UIImage(named: "star_border")
                NotificationCenter.default.post(name: .didToggleFavourite, object: nil, userInfo: [
                    "id"     : event.id,
                    "toggle" : event.isFavourite
                    ])
            }
        }
    }
    
    fileprivate func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
 
        
        return stackView
    }
    
    
    
}

extension EventController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("user location did update")
        //guard let eventLocation = eventLocation else { return }
        //setCamera(to: eventLocation)
        updateDistance(userLocation: userLocation)
    }
    
}
