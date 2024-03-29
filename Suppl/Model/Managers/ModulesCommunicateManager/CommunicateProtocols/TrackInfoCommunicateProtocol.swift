import Foundation

protocol TrackInfoCommunicateProtocol: CommunicateManagerProtocol {
    func setSetup(light: Bool, downloadButton: Bool)
    func setNewData(id: String, title: String, performer: String, duration: Int)
    func setNewImage(imageData: Data)
    func needReset()
}
