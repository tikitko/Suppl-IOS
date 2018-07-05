import Foundation
import UIKit

final class RemoteDataManager {
    
    static public let s = RemoteDataManager()
    private init() {
        thumbsCacheDirPath = baseCacheDirPath.appendingPathComponent("thumbs")
    }
    
    private var cache = NSCache<NSString, NSData>()
    private let session = CommonRequest()
    public let baseCacheDirPath = RemoteDataManager.getDocumentsDirectory().appendingPathComponent(AppStaticData.cacheDir)
    private let thumbsCacheDirPath: URL
    
    public func getData(link: String, noCache: Bool = false, inMainQueue: Bool = true, callbackData: @escaping (Data) -> ()) {
        if !noCache, let cachedVersion = getFromCache(link: link) {
            callbackData(cachedVersion)
            return
        }
        session.request(url: link, inMainQueue: inMainQueue) { [weak self] error, response, data in
            guard let data = data else { return }
            self?.setToCache(link: link, data: data)
            callbackData(data)
        }
    }
    
    private func getFromCache(link: String) -> Data? {
        if let cachedVersion = cache.object(forKey: link as NSString) {
            return cachedVersion as Data
        }
        return nil
    }
    
    private func setToCache(link: String, data: Data) {
        cache.setObject(data as NSData, forKey: link as NSString)
    }
    
    public func getCachedImage(link: String, imagesLifetime: Int = 6, callbackImage: @escaping (UIImage) -> ()) {
        if let cachedVersion = self.getFromCache(link: link), let image = UIImage(data: cachedVersion as Data) {
            callbackImage(image)
            return
        }
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let `self` = self else { return }
            guard let imageName = URL(string: link)?.path else { return }
            let filename = self.thumbsCacheDirPath.appendingPathComponent(imageName)
            if FileManager.default.fileExists(atPath: filename.path), let imageData = try? Data(contentsOf: filename), let image = UIImage(data: imageData) {
                var imageAlive = false
                if let dateAny = try? FileManager.default.attributesOfItem(atPath: filename.path)[FileAttributeKey.modificationDate],
                    let editDate = dateAny as? Date,
                    let hours = Calendar.current.dateComponents([.hour], from: editDate, to: Date()).hour,
                    hours < imagesLifetime
                {
                    imageAlive = true
                } else {
                    imageAlive = OfflineModeManager.s.offlineMode ? true : false
                }
                if imageAlive {
                    self.setToCache(link: link, data: imageData)
                    DispatchQueue.main.async { callbackImage(image) }
                    return
                } else {
                    try? FileManager.default.removeItem(atPath: filename.path)
                }
            }
            if OfflineModeManager.s.offlineMode { return }
            self.getData(link: link, noCache: true, inMainQueue: false) { data in
                guard let image = UIImage(data: data as Data), let data = UIImageJPEGRepresentation(image, 1.0) else { return }
                try? FileManager.default.createDirectory(at: filename.deletingLastPathComponent(), withIntermediateDirectories: true)
                try? data.write(to: filename, options: [.atomic])
                DispatchQueue.main.async { callbackImage(image) }
            }
        }
    }
    
    public func getCachedImageAsData(link: String, imagesLifetime: Int = 6, callbackImageData: @escaping (Data) -> ()) {
        getCachedImage(link: link, imagesLifetime: imagesLifetime) {
            guard let imageData = UIImageJPEGRepresentation($0, 1.0) else { return }
            callbackImageData(imageData)
        }
    }
    
    public func resetAllCachedImages() {
        try? FileManager.default.removeItem(atPath: thumbsCacheDirPath.path)
        clearCache()
    }
    
    public func resetOldCachedImages(imagesLifetime: Int = 6) {
        if OfflineModeManager.s.offlineMode { return }
        let imagesPaths = searchJPGImages(pathURL: thumbsCacheDirPath)
        for imagePath in imagesPaths {
            if FileManager.default.fileExists(atPath: imagePath),
                let dateAny = try? FileManager.default.attributesOfItem(atPath: imagePath)[FileAttributeKey.modificationDate],
                let editDate = dateAny as? Date,
                let hours = Calendar.current.dateComponents([.hour], from: editDate, to: Date()).hour,
                hours < imagesLifetime { return }
            try? FileManager.default.removeItem(atPath: imagePath)
        }
    }
    
    private func searchJPGImages(pathURL: URL) -> [String] {
        var imageURLs = [String]()
        let fileManager = FileManager.default
        let keys = [URLResourceKey.isDirectoryKey, URLResourceKey.localizedNameKey]
        let options: FileManager.DirectoryEnumerationOptions = [.skipsPackageDescendants, .skipsSubdirectoryDescendants, .skipsHiddenFiles]
        
        let enumerator = fileManager.enumerator(
            at: pathURL,
            includingPropertiesForKeys: keys,
            options: options,
            errorHandler: {(url, error) -> Bool in
                return true
        })
        
        if enumerator != nil {
            while let file = enumerator!.nextObject() {
                let filePathURL = file as! URL
                if filePathURL.path.hasSuffix(".jpg"){
                    imageURLs.append(filePathURL.path)
                } else {
                    imageURLs += searchJPGImages(pathURL: filePathURL)
                }
            }
        }
        
        return imageURLs
    }
 
    public func clearCache() {
        cache.removeAllObjects()
    }
    
    public func removeFromCache(link: String) {
        cache.removeObject(forKey: link as NSString)
    }
    
    public static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    public static func directoryExistsAtPath(_ path: URL) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path.path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    public static func saveFile(data: Data, name: String, path: URL) -> Bool {
        do {
            if !RemoteDataManager.directoryExistsAtPath(path) {
                try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
            }
            try data.write(to: path.appendingPathComponent(name), options: [.atomic])
            return true
        } catch {
            return false
        }
    }
    
}
