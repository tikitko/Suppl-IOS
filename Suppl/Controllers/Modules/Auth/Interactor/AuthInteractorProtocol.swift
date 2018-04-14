import Foundation

protocol AuthInteractorProtocol: class {
    var noAuthOnShow: Bool { get set }
    func getKeys() -> (i: Int, a: Int)?
    func endAuth()
    func auth(ikey: Int, akey: Int, report: @escaping (String?) -> ())
    func reg(report: @escaping (String?) -> ())
    func inputProcessing(input: String?) -> (ikey: Int, akey: Int)?
}
