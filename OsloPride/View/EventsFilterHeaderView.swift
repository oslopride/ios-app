import UIKit

class FilterStackView: UIStackView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.width + 20, height: frame.height + 20)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol EventsFilterHeaderViewDelegte {
    func updateFilter(_ filter: Filter, remove: Bool)
    func reloadTableview()
}

class EventsFilterHeaderView: UIView {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        scrollView.showsHorizontalScrollIndicator = false

        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.contentSize = CGSize(width: frame.width + 100, height: frame.height)
        setupLayout()
    }
    
    var delegate: EventsFilterHeaderViewDelegte?
    
    fileprivate func setupLayout() {
        addSubview(scrollView)
        [
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 60)
        ].forEach { $0.isActive = true }
        
        let categoryStack = FilterStackView()
        categoryStack.axis = .horizontal
        categoryStack.spacing = 10
        scrollView.addSubview(categoryStack)
        [
            categoryStack.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            categoryStack.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            categoryStack.topAnchor.constraint(equalTo: topAnchor),
            categoryStack.heightAnchor.constraint(equalToConstant: 60)
        ].forEach { $0.isActive = true }
        
        [
            Filter(name: "Pride House", category: "3", color: .prideBlue),
            Filter(name: "Pride Park", category: "2", color: .prideGreen),
            Filter(name: "Pride Art", category: "4", color: .pridePurple),
            Filter(name: "Ekstern Arena", category: "0", color: .prideYellow)
        ].forEach { filter in
            let butt = FilterButton(type: .system)
            butt.setTitle(" \(filter.name) ", for: .normal)
            
            butt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            
            butt.addTarget(self, action: #selector(updateFilter), for: .touchUpInside)
            butt.filter = filter
            
            categoryStack.addArrangedSubview(butt)
        }
        
        let miscFilterActions = FilterStackView()
        miscFilterActions.translatesAutoresizingMaskIntoConstraints = false
        miscFilterActions.distribution = .fillEqually
        miscFilterActions.axis = .horizontal
        miscFilterActions.backgroundColor = .red
        
        addSubview(miscFilterActions)
        [
            miscFilterActions.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            miscFilterActions.leftAnchor.constraint(equalTo: leftAnchor),
            miscFilterActions.rightAnchor.constraint(lessThanOrEqualTo: scrollView.rightAnchor, constant: -10),
            miscFilterActions.heightAnchor.constraint(equalToConstant: 50)
        ].forEach { $0.isActive = true }
    }
    
    @objc fileprivate func updateFilter(sender: FilterButton) {
        let feedback = UISelectionFeedbackGenerator()
        feedback.prepare()
        sender.isActivated = !sender.isActivated
        delegate?.updateFilter(sender.filter, remove: !sender.isActivated)
        feedback.selectionChanged()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Filter {
    var name: String
    var category: String
    var color: UIColor
}

class FilterButton: UIButton {
    var filter: Filter! {
        didSet {
            backgroundColor = filter.color
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }
    
    let bc = UIColor.prideGreen
    let tc = UIColor.white
    
    var isActivated = true {
        didSet {
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                if self.isActivated {
                    self.backgroundColor = self.filter.color
                    self.tintColor = self.tc
                } else {
                    self.backgroundColor = self.tc
                    self.tintColor = .graySuit
                }
            }, completion: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .white
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
