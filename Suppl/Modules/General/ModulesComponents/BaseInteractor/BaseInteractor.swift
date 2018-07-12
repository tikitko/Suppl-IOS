import Foundation

class BaseInteractor {

    func getLocaleString(_ expression: LocalesManager.Expression) -> String {
        return LocalesManager.shared.get(expression)
    }
    
    func getLocaleString(apiErrorCode code: Int) -> String {
        return LocalesManager.shared.get(apiErrorCode: code)
    }
    
}
