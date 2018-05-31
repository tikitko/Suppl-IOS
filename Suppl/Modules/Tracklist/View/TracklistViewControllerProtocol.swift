import Foundation
import UIKit

protocol TracklistViewControllerProtocol: class {
    func updateButtonIsEnabled(_ value: Bool)
    func setFilterThenPopover(filterController: UIViewController)
    func offButtons()
    func clearSearch()
    func onLabel(text: String)
    func offLabel()
    func reloadData()
}
