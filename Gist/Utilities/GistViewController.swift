import Foundation
import UIKit

class GistViewController: UIViewController {
    weak var engineViewController: UIViewController?

    func setup() {
        guard let engineViewController = engineViewController else { return }
        self.addChild(engineViewController)
        self.view.addSubview(engineViewController.view)
        engineViewController.didMove(toParent: self)
        engineViewController.view.translatesAutoresizingMaskIntoConstraints = false

        setConstraints()
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        setConstraints()
    }
    
    func setConstraints() {
        guard let engineViewController = engineViewController else { return }
        let horizontalConstraint = engineViewController.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let verticalConstraint = engineViewController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        let maxWidthConstraint = engineViewController.view.widthAnchor.constraint(lessThanOrEqualToConstant: 414)
        let widthConstraint = engineViewController.view.widthAnchor.constraint(greaterThanOrEqualTo: self.view.widthAnchor)
        let heightConstraint = engineViewController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor)

        widthConstraint.priority = UILayoutPriority.defaultHigh
        maxWidthConstraint.priority = UILayoutPriority.required
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, maxWidthConstraint, widthConstraint, heightConstraint])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.updateViewConstraints()
    }
}
