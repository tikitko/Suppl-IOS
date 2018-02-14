import Foundation
import UIKit
import SwiftTheme

class SettingsAccountViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var identifierField: UITextField!
    @IBOutlet weak var accountOutButton: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.title = "Аккаунт"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        getAccount()
    }
    
    @IBAction func accountOutButtonClick(_ sender: Any) {
        UserDefaultsManager.identifierKey = nil
        UserDefaultsManager.accessKey = nil
        AuthManager.setAuthWindow(noAuth: true)
    }

    @IBAction func emailButtonClick(_ sender: Any) {
        view.endEditing(true)
        guard let (ikey, akey) = AuthManager.getAuthKeys() else { return }
        guard let email = self.emailField.text else { return }
        let lastPlacehilderText = emailField.placeholder
        self.emailField.text = ""
        self.emailField.placeholder = "Установка..."
        APIManager.userUpdateEmail(ikey: ikey, akey: akey, email: email) { [weak self] error, data in
            guard let `self` = self else { return }
            if let error = error {
                self.emailField.placeholder = APIManager.errorHandler(error)
            } else {
                self.emailField.placeholder = "EMail установлен!"
            }
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
                guard let `self` = self else { return }
                self.emailField.placeholder = lastPlacehilderText
                self.emailField.text = email
            }
        }
    }
    
    func setTheme() {
        //emailButton.backgroundColor = AppData.getTheme(SettingsManager.theme).secondColor
        //accountOutButton.backgroundColor = AppData.getTheme(SettingsManager.theme).secondColor
        emailButton.theme_backgroundColor = "secondColor"
        accountOutButton.theme_backgroundColor = "secondColor"
    }
    
    private func getAccount() {
        let loadText = "Получение данных..."
        emailField.text = loadText
        identifierField.text = loadText
        guard let (ikey, akey) = AuthManager.getAuthKeys() else { return }
        APIManager.userGet(ikey: ikey, akey: akey) { [weak self] error, data in
            guard let `self` = self else { return }
            guard let data = data else {
                AuthManager.setAuthWindow()
                return
            }
            self.emailButton.isEnabled = true
            self.emailField.placeholder = "Ваш EMail"
            if let email = data.email {
                self.emailField.text = email
            }
            self.accountOutButton.isEnabled = true
            self.identifierField.text = String(ikey) + String(akey)
        }
    }
}

