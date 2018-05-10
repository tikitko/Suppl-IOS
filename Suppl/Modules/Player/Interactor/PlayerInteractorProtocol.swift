import Foundation

protocol PlayerInteractorProtocol: class {
    
    func load()
    func getCurrentTime() -> Double?
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func play()
    func navButtonClick(next: Bool)
    func rewindP()
    func rewindM()
    
}
