import Foundation
import UIKit

class GistModalViewController: UIViewController {
    weak var engineView: UIView!
    var position: MessagePosition!
    var verticalConstraint,
        horizontalConstraint,
        widthConstraint,
        heightConstraint,
        bottomConstraint: NSLayoutConstraint!

    func setup(position: MessagePosition) {
        self.position = position
        self.view.addSubview(engineView)
        setConstraints()
    }

    func updateGistViewConstraints(width: CGFloat, height: CGFloat) {
        heightConstraint.constant = height
        widthConstraint.constant = self.view.frame.width
        updateViewConstraints()
    }

    func setConstraints() {
        let maxWidthConstraint = engineView.widthAnchor.constraint(lessThanOrEqualToConstant: 414)

        widthConstraint = engineView.widthAnchor.constraint(equalToConstant: self.view.frame.width)
        heightConstraint = engineView.heightAnchor.constraint(equalToConstant: engineView.frame.height)

        bottomConstraint = engineView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor)
        bottomConstraint.priority = .required

        horizontalConstraint = engineView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)

        switch position {
        case .top:
            verticalConstraint = engineView.topAnchor.constraint(equalTo: self.view.topAnchor)
        case .center:
            verticalConstraint = engineView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        case .bottom:
            verticalConstraint = engineView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        case .none:
            verticalConstraint = engineView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        }

        widthConstraint.priority = UILayoutPriority.defaultHigh
        maxWidthConstraint.priority = UILayoutPriority.required
        NSLayoutConstraint.activate([horizontalConstraint,
                                     verticalConstraint,
                                     maxWidthConstraint,
                                     widthConstraint,
                                     heightConstraint,
                                     bottomConstraint])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.updateViewConstraints()
    }
}
