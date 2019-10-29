import UIKit

class EventCategoryLabel: UILabel {
    var category: String? {
        didSet {
            setupUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    fileprivate func setupUI() {
        guard let category = category else { return }
        switch category {
        case "0":
            text = "Ekstern Arena"
            textColor = .prideYellow
        case "1":
            text = "Pride Parade"
            textColor = .prideRed
        case "2":
            text = "Pride Park"
            textColor = .prideGreen
        case "3":
            text = "Pride House"
            textColor = .prideBlue
        case "4":
            text = "Pride Art"
            textColor = .pridePurple
        default:
            text = "Event"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
