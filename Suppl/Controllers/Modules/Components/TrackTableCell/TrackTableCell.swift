import UIKit

class TrackTableCell: UITableViewCell {
    
    static let identifier = String(describing: TrackTableCell.self)
    
    private(set) var baseImage = true
    
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackPerformer: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadImageType()
        baseImage = true
        trackTitle.text = nil
        trackPerformer.text = nil
        trackDuration.text = nil
        trackImage.image = UIImage(named: "cd.png")
    }
    
    public func configure(title: String? = nil, performer: String? = nil, duration: Int? = nil, image: UIImage? = nil) -> Void {
        loadImageType()
        if let title = title {
            trackTitle.text = title
        }
        if let performer = performer {
            trackPerformer.text = performer
        }
        if let duration = duration {
            trackDuration.text = TrackTableCell.formatTime(sec: duration)
        }
        if let image = image {
            baseImage = false
            trackImage.image = image
        }
    }
    
    private func loadImageType() {
        if let round = SettingsManager.roundIcons, round {
            trackImage.layer.cornerRadius = trackImage.frame.size.width / 2
            trackImage.clipsToBounds = true
            return
        }
        trackImage.layer.cornerRadius = 0
        trackImage.clipsToBounds = false
    }
    
    public static func formatTime(sec: Int) -> String {
        let minSec = TrackTableCell.secondsToMinutesSeconds(seconds: sec)
        let min = String(minSec.0)
        let sec = (minSec.1 < 10 ? "0" : "") + String("\(minSec.1)")
        return String("\(min):\(sec)")
    }
    
    public static func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }

}
