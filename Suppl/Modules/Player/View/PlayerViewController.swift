import Foundation
import UIKit
import SwiftTheme

class PlayerViewController: UIViewController, PlayerViewControllerProtocol {
    
    var presenter: PlayerPresenterProtocol!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var performerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var rewindMButton: UIButton!
    @IBOutlet weak var rewindPButton: UIButton!
    
    @IBOutlet weak var goneLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        presenter.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.show()
    }
    
    func setTheme() {
        view.theme_backgroundColor = "thirdColor"
    }
    
    func setNavTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func setTrackInfo(title: String, performer: String) {
        titleLabel.text = title
        performerLabel.text = performer
    }
    
    func setTrackImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func openPlayer(duration: Double) {
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = Float(duration)
        progressSlider.value = 0
        
        goneLabel.text = TrackTime(sec: Int(progressSlider.minimumValue)).formatted
        leftLabel.text = TrackTime(sec: Int(progressSlider.maximumValue)).formatted
        
        presenter.addPlayerTimeObserver()
        
        playButton.isEnabled = true
        rewindMButton.isEnabled = true
        rewindPButton.isEnabled = true
        progressSlider.isEnabled = true
    }
    
    func updatePlayerProgress(currentTime: Double) {
        progressSlider.value = Float(currentTime)
        goneLabel.text = TrackTime(sec: Int(progressSlider.value)).formatted
        leftLabel.text = TrackTime(sec: Int(progressSlider.maximumValue - progressSlider.value)).formatted
    }
    
    
    func clearPlayerForm() {
        imageView.image = nil
        performerLabel.text = nil
        titleLabel.text = nil
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 1
        progressSlider.value = 0
        goneLabel.text = TrackTime.zeroTime
        leftLabel.text = TrackTime.zeroTime
        
        playButton.isEnabled = false
        rewindMButton.isEnabled = false
        rewindPButton.isEnabled = false
        progressSlider.isEnabled = false
    }
    
    func setPlayButtonImage(_ image: UIImage) {
        playButton.setImage(image, for: .normal)
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        presenter.setPlayerCurrentTime(Double(progressSlider.value), withCurrentTime: false)
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        presenter.play()
    }
    
    @IBAction func rewindPClicked(_ sender: Any) {
        presenter.setPlayerCurrentTime(15, withCurrentTime: true)
    }
    
    @IBAction func rewindMClicked(_ sender: Any) {
        presenter.setPlayerCurrentTime(-15, withCurrentTime: true)
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        presenter.navButtonClick(next: false)
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        presenter.navButtonClick(next: true)
    }
    
    deinit {
        presenter.stopObservers()
    }
    
}
