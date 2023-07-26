import Foundation
import UIKit

protocol PickeySheetDelegate: AnyObject {
    func sheetClosed()
}

public class PickeySheet: UIViewController {
    
    private var contentsViewHeight: CGFloat = 300
    private var allowAnimation: Bool = true
    weak var delegate: PickeySheetDelegate?
    
    private lazy var dimmedView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor(named: "shadowColor")
        view.alpha = 0
        view.addGestureRecognizer(dimmedViewTap)
        return view
    }()
    
    private lazy var dimmedViewTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped))
    
    private let contentsView: UIView
    
    public init(view contentsView: UIView, withAnimation: Bool = true) {
        self.contentsView = contentsView
        self.allowAnimation = withAnimation
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        configureUI()
    }
    
    private func configureUI() {
        if let contentsViewHeight = contentsView.constraints.filter({ $0.firstAttribute == .height }).compactMap({ $0.constant }).first {
            self.contentsViewHeight = contentsViewHeight
        }
        
        contentsView.cornerRadius = 20
        contentsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(dimmedView)
        view.addSubview(contentsView)
        contentsView.translatesAutoresizingMaskIntoConstraints = false
        contentsView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 96).isActive = true
        contentsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        show(contentsViewHeight: contentsViewHeight)
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        contentsView.addGestureRecognizer(viewPan)
    }
    
    @objc private func dimmedViewTapped() {
        self.hide()
    }
    
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: self.view)
        let velocity = panGestureRecognizer.velocity(in: self.view)
        
        switch panGestureRecognizer.state {
        case .changed:
            if translation.y > 0 {
                contentsView.transform = .init(translationX: 0, y: translation.y)
            }
        case .ended:
            if translation.y > 200 || velocity.y > 1500 {
                self.hide()
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.contentsView.transform = .init(translationX: 0, y: 0)
                }
                
            }
        default: break
        }
    }
    
    private func show(contentsViewHeight: CGFloat) {
        self.contentsView.transform = .init(translationX: 0, y: contentsViewHeight)
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.allowAnimation ? 0.3 : 0) {
                self.dimmedView.alpha = 0.6
                self.contentsView.transform = .init(translationX: 0, y: 0)
            }
        }
    }
    
    public func hide() {
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
            self.contentsView.transform = .init(translationX: 0, y: self.contentsViewHeight)
        } completion: { _ in
            self.delegate?.sheetClosed()
            self.dismiss(animated: false)
        }
    }
}
