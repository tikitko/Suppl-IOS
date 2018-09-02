import Foundation

class TrackFilterInteractor: BaseInteractor, TrackFilterInteractorProtocol {
    
    weak var presenter: TrackFilterPresenterProtocolInteractor!
    
    let parentModuleNameId: String
    init(parentModuleNameId: String) {
        self.parentModuleNameId = parentModuleNameId
    }
    
    var communicateDelegate: TrackFilterCommunicateProtocol? {
        get { return ModulesCommunicateManager.shared.getListener(name: parentModuleNameId) as? TrackFilterCommunicateProtocol }
    }

}