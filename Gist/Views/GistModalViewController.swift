import Foundation
import UIKit

class GistModalViewController: UIViewController, GistViewDelegate {
    var currentHeight: CGFloat = 0.0
    weak var gistView: GistView!
    var position: MessagePosition!
    var verticalConstraint,
        horizontalConstraint,
        widthConstraint,
        heightConstraint,
        bottomConstraint: NSLayoutConstraint!

    func setup(position: MessagePosition) {
        gistView.delegate = self
        self.position = position
        self.view.addSubview(gistView)
        setConstraints()
    }

    func setConstraints() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.gistView.translatesAutoresizingMaskIntoConstraints = false

        let maxWidthConstraint = gistView.widthAnchor.constraint(lessThanOrEqualToConstant: 414)
        widthConstraint = gistView.widthAnchor.constraint(equalToConstant: self.view.frame.width)
        heightConstraint = gistView.heightAnchor.constraint(equalToConstant: gistView.frame.height)
        horizontalConstraint = gistView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)

        switch position {
        case .top:
            verticalConstraint = gistView.topAnchor.constraint(equalTo: self.view.topAnchor)
        case .center:
            verticalConstraint = gistView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        case .bottom:
            verticalConstraint = gistView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        case .none:
            verticalConstraint = gistView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        }

        widthConstraint.priority = UILayoutPriority.defaultHigh
        maxWidthConstraint.priority = UILayoutPriority.required
        NSLayoutConstraint.activate([horizontalConstraint,
                                     verticalConstraint,
                                     maxWidthConstraint,
                                     widthConstraint,
                                     heightConstraint])
    }

    func sizeChanged(message: Message, width: CGFloat, height: CGFloat) {
        self.currentHeight = height
        self.updateViewConstraints()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.updateViewConstraints()
        super.traitCollectionDidChange(previousTraitCollection)
    }

    override func updateViewConstraints() {
        if self.currentHeight > self.view.frame.height {
            heightConstraint.constant = self.view.frame.height
        } else {
            heightConstraint.constant = self.currentHeight
        }
        widthConstraint.constant = self.view.frame.width
        super.updateViewConstraints()
    }

    func action(message: Message, currentRoute: String, action: String, name: String) {}
}
