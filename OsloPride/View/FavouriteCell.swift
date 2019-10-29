import UIKit
import UserNotifications
import UserNotificationsUI

protocol FavouriteCellDelegate {
    func presentDeleteConfirmation(_ event: Event)
    func presentDirections(_ event: Event)
    func createNotification(_ event: Event, handler: @escaping (Error?) -> ())
}

class FavouriteCell: UICollectionViewCell {
    var event: Event! {
        didSet {
            setupUI()
        }
    }
    
    var delegate: FavouriteCellDelegate?
    
    let eventImageView: UIImageView = {
        let imv = UIImageView()
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.contentMode = .scaleAspectFill
        imv.tintColor = .graySuit
        imv.clipsToBounds = true
        
        return imv
    }()
    
    let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .black)
        label.numberOfLines = 0
        return label
    }()
    
    let eventCategoryLabel: EventCategoryLabel = {
        let label = EventCategoryLabel()
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        return label
    }()
    
    let countdownLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    lazy var deleteButton: UIButton = {
        let butt = UIButton(type: .system)
        butt.setImage(UIImage(named: "delete_twotone"), for: .normal)
        butt.tintColor = UIColor.prideRed
        butt.addTarget(self, action: #selector(displayDeleteConfirmation), for: .touchUpInside)
        
        return butt
    }()
    
    lazy var directionsButton: UIButton = {
        let butt = UIButton(type: .system)
        butt.setImage(UIImage(named: "directions_twotone"), for: .normal)
        butt.tintColor = UIColor.prideBlue
        butt.addTarget(self, action: #selector(displayDirections), for: .touchUpInside)
        
        return butt
    }()
    
    lazy var reminderButton: UIButton = {
        let butt = UIButton(type: .system)
        butt.setImage(UIImage(named: "alert_twotone"), for: .normal)
        butt.tintColor = UIColor.prideYellow
        butt.addTarget(self, action: #selector(createNotification), for: .touchUpInside)
        
        return butt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @objc fileprivate func displayDirections() {
        delegate?.presentDirections(event)
    }
    
    @objc fileprivate func displayDeleteConfirmation() {
        delegate?.presentDeleteConfirmation(event)
    }
    
    @objc fileprivate func createNotification() {
        delegate?.createNotification(event, handler: { err in
            if let err = err {
                print("Failed to create notification: ", err)
                return
            }
            DispatchQueue.main.async {
                self.reminderButton.isEnabled = false
            }
        })
    }
    
    fileprivate func setupLayout() {
        addSubview(eventImageView)
        [
            eventImageView.leftAnchor.constraint(equalTo: leftAnchor),
            eventImageView.topAnchor.constraint(equalTo: topAnchor),
            eventImageView.rightAnchor.constraint(equalTo: rightAnchor),
            eventImageView.heightAnchor.constraint(equalToConstant: (frame.width - 14 * 2) * 0.68)
        ].forEach { $0.isActive = true }
        
        addSubview(eventTitleLabel)
        [
            eventTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14),
            eventTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14),
            eventTitleLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 10)
        ].forEach { $0.isActive = true }
        addSubview(eventCategoryLabel)
        [
            eventCategoryLabel.leftAnchor.constraint(lessThanOrEqualTo: eventTitleLabel.leftAnchor),
            eventCategoryLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 10)
        ].forEach { $0.isActive = true }
        
        addSubview(dateLabel)
        [
            dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14),
            dateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14),
            dateLabel.topAnchor.constraint(equalTo: eventCategoryLabel.bottomAnchor, constant: 10)
        ].forEach { $0.isActive = true }
        
        addSubview(countdownLabel)
        [
            countdownLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14),
            countdownLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            countdownLabel.leftAnchor.constraint(equalTo: centerXAnchor)
        ].forEach { $0.isActive = true }
        
        let actionsStack = UIStackView(arrangedSubviews: [deleteButton, reminderButton, directionsButton])
        actionsStack.translatesAutoresizingMaskIntoConstraints = false
        actionsStack.distribution = .fillEqually
        addSubview(actionsStack)
        [
            actionsStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 14),
            actionsStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -14),
            actionsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        ].forEach { $0.isActive = true }
    }
    
    fileprivate func setupUI() {
        if let imageData = event.image {
            eventImageView.image = UIImage(data: imageData)
            eventImageView.contentMode = .scaleAspectFill
        } else {
            eventImageView.image = UIImage(named: "trekanter")
            eventImageView.contentMode = .scaleAspectFit
        }
        eventTitleLabel.text = event.title
        eventCategoryLabel.category = event.category
        
        guard let start = event?.startingTime, let end = event?.endingTime else { return }
        dateLabel.setupEventDateLabel(start: start, end: end)
        
        let countdown = Calendar.current.dateComponents([.day, .hour, .minute], from: Date(), to: start)
        let day = String(countdown.day ?? 0)
        let hours = String(countdown.hour ?? 0)
        let minutes = String(countdown.minute ?? 0)
        var attrString = NSMutableAttributedString()
        
        attrString.append(NSAttributedString(string: "<- Som Betyr Om\n", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.graySuit
        ]))
        
        if (countdown.day ?? 0) > 0 {
            attrString.append(NSAttributedString(string: "\(day) dager", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.kindaBlack
            ]))
        } else if (countdown.hour ?? 0) > 1 {
            attrString.append(NSAttributedString(string: "\(hours) timer", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.kindaBlack
            ]))
        } else if (countdown.hour ?? 0) > 0 {
            attrString.append(NSAttributedString(string: "\(hours) time og ", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.kindaBlack
            ]))
            attrString.append(NSAttributedString(string: "\(minutes) minutter", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.kindaBlack
            ]))
        } else if (countdown.minute ?? 0) > 1 {
            attrString.append(NSAttributedString(string: "\(minutes) minutter", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.kindaBlack
            ]))
        } else {
            attrString = NSMutableAttributedString(string: "Eventet har startet", attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.graySuit
            ])
        }
        
        countdownLabel.attributedText = attrString
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            requests.forEach { req in
                DispatchQueue.main.async {
                    self.reminderButton.isEnabled = !(req.identifier == self.event.id)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
