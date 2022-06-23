

import UIKit

protocol AddToCartDelegate: AnyObject {
    func addToCart()
}


class AddToCartView: UIView {

    weak var delegate: AddToCartDelegate?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var grabberView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "111111")
        view.cornerRadius = 2.5
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Cappuccino"
        view.textColor = .white
        view.font = UIFont(name: "Cocogoose", size: 20)
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do euismod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim venia."
        view.textColor = UIColor(named: "coffeeGray")
        view.font = UIFont(name: "Cocogoose-light", size: 18)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    lazy var categoryStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 16
        view.distribution = .fillEqually
        return view
    }()
    
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 24
        view.distribution = .fill
        return view
    }()
    
    lazy var bottomContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.shadowColor = UIColor(named: "shadowColor")
        view.shadowOffset = CGSize(width: 0, height: -3)
        view.shadowOpacity = 0.7
        view.shadowRadius = 8
        view.backgroundColor = .black
        view.masksToBounds = false
        return view
    }()
    
    lazy var addToCartButton: HorizontalGradientView = {
        let view = HorizontalGradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.cornerRadius = 22
        return view
    }()
    
    lazy var cartLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add to cart"
        label.textColor = .black
        label.font = UIFont(name: "Cocogoose-light", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var numberStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 0
        view.distribution = .fill
        return view
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setLayout() {
        self.backgroundColor = .black
        self.containerView.backgroundColor = .black
        
        self.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.containerView.addSubview(grabberView)
        NSLayoutConstraint.activate([
            grabberView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 16),
            grabberView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            grabberView.widthAnchor.constraint(equalToConstant: 150),
            grabberView.heightAnchor.constraint(equalToConstant: 5)
        ])
        
        self.containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.grabberView.bottomAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor)
        ])
        
        self.containerView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            messageLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16),
            messageLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16),
            messageLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor)
        ])
        
        self.containerView.addSubview(categoryStackView)
        NSLayoutConstraint.activate([
            categoryStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            categoryStackView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 32),
            categoryStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -32)
        ])
        
        for i in 0..<3 {
            let view = CartCategoryView(frame: .zero)
            view.tag = i+1
            let tap = UITapGestureRecognizer(target: self, action: #selector(categorySelected(_:)))
            view.addGestureRecognizer(tap)
            if i == 0 {
                view.isSelected = true
            } else {
                view.isSelected = false
            }
            categoryStackView.addArrangedSubview(view)
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
        
        self.containerView.addSubview(bottomContainer)
        NSLayoutConstraint.activate([
            bottomContainer.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 32),
            bottomContainer.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0),
            bottomContainer.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0),
            bottomContainer.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        
        self.bottomContainer.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.bottomContainer.topAnchor, constant: 24),
            stackView.leftAnchor.constraint(equalTo: self.bottomContainer.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: self.bottomContainer.rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: self.bottomContainer.bottomAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        stackView.addArrangedSubview(numberStack)
        stackView.addArrangedSubview(addToCartButton)
        
        for i in 0..<3 {
            let view = CartConterItem(frame: .zero)
            switch i {
            case 0:
                view.type = .image
                view.imageView.image = UIImage(named: "MinusIcon")
                view.clickedAction = {[weak self] in
                    self?.onClickCounter(.negetive)
                }
            case 1:
                view.type = .label
            case 2:
                view.type = .image
                view.imageView.image = UIImage(named: "PlusIcon")
                view.clickedAction = {[weak self] in
                    self?.onClickCounter(.plus)
                }
            default:
                break
            }
            
            numberStack.addArrangedSubview(view)
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: 44),
                view.heightAnchor.constraint(equalToConstant: 44)
            ])
        }
        
        addToCartButton.addSubview(cartLabel)
        NSLayoutConstraint.activate([
            cartLabel.topAnchor.constraint(equalTo: addToCartButton.topAnchor),
            cartLabel.leftAnchor.constraint(equalTo: addToCartButton.leftAnchor),
            cartLabel.rightAnchor.constraint(equalTo: addToCartButton.rightAnchor),
            cartLabel.bottomAnchor.constraint(equalTo: addToCartButton.bottomAnchor)
        ])
        
        let cartTap = UITapGestureRecognizer(target: self, action: #selector(onClickAdd))
        addToCartButton.addGestureRecognizer(cartTap)
        
    }

    
    @objc func onClickAdd() {
        self.delegate?.addToCart()
    }
    
    @objc func categorySelected(_ gesture: UIGestureRecognizer) {
        if let index = gesture.view?.tag {
            self.categoryStackView.arrangedSubviews.forEach { view in
                if view.tag == index {
                    (view as? CartCategoryView)?.isSelected = true
                } else {
                    (view as? CartCategoryView)?.isSelected = false
                }
            }
        }
    }
    
    func onClickCounter(_ option: CounterOptions) {
        numberStack.arrangedSubviews.forEach { view in
            if let view = view as? CartConterItem, view.type == .label {
                switch option {
                case .plus:
                    view.label.text = "\(Int(view.label.text!)! + 1)"
                case .negetive:
                    if (Int(view.label.text!)!) > 1 {
                        view.label.text = "\(Int(view.label.text!)! - 1)"
                    }
                }
            }
        }
    }
    
}
