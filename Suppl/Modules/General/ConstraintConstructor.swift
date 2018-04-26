import Foundation
import UIKit

class ConstraintConstructor {
    
    public static func includeView(child: UIView, parent: UIView) {
        parent.addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        child.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        child.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        child.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        child.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        child.heightAnchor.constraint(equalTo: parent.heightAnchor, multiplier: 1, constant: 1).isActive = true
        child.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 1, constant: 1).isActive = true
    }
    
}
