import Foundation
import UIKit

class AuthRouter: AuthRouterProtocol {
    
    weak var viewController: UIViewController!
    
    func goToRootTabBar() {
        viewController.view.window?.rootViewController = RootTabBarController()
    }
    
    static func setup(noAuth noAuthOnShow: Bool = false) -> UIViewController {
        let router = AuthRouter()
        let interactor = AuthInteractor()
        interactor.noAuthOnShow = noAuthOnShow
        let presenter = AuthPresenter()
        let viewController = AuthViewController()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
}
