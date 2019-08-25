//
//  MGPLayerMusicViewModel.swift
//  MusicalGramophone
//
//  Created by Pavel Molodkin on 25/08/2019.
//

import Foundation
import UIKit
import AVFoundation

class MGPLayerMusicViewModel: NSObject, AVAudioPlayerDelegate {


    var peopleName = ""
    var albumName = ""
    var trackName = ""
    var trackId = ""
    var image: UIImage!


     var imageView: UIImageView!
     var playButton: UIBarButtonItem!
     var toolBar: UIToolbar!
     var playbackSlider: UISlider!
     var timeLabel: UILabel!
     var backgroundImage: UIImageView!
     var view: UIView!

     var musicPlayer = AVAudioPlayer()

    init(trackInfo: MGTrack, albumImage: UIImage) {
        peopleName = trackInfo.peopleName
        albumName = trackInfo.albumName
        trackName = trackInfo.trackName
        trackId = trackInfo.trackId
        image = albumImage
    }

    func loadModel(view: UIView) {
        self.view = view
        prepareSongAndSessionPlayer()
         musicPlayer.delegate = self
        playbackSlider.maximumValue = Float(musicPlayer.duration)
        playbackSlider.value = 0.0
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        playbackSlider.addGestureRecognizer(tapGestureRecognizer)
        self.imageView.image = image
    }

    func dismissViewController(viewController: UIViewController,_ gestureRecognizer: UIGestureRecognizer) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal

        if let swipeGesture = gestureRecognizer as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                transition.subtype = CATransitionSubtype.fromBottom
            case UISwipeGestureRecognizer.Direction.up:
                transition.subtype = CATransitionSubtype.fromTop
            default:
                break
            }
        } else {
            transition.subtype = CATransitionSubtype.fromBottom
        }
        viewController.navigationController?.view.layer.add(transition, forKey: nil)
        viewController.navigationController?.popViewController(animated: false)
        if #available(iOS 10.0, *) {
            musicPlayer.setVolume(0, fadeDuration: 1.0)
        } else {
            musicPlayer.stop()
        }
    }

    // MARK: AudioPlayer delegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        musicPlayer.stop()
        playButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(stopPlay))
        playButton.tintColor = UIColor.black
        toolBar.items![2] = playButton
        playbackSlider.value = 0
        backgroundImage.image = UIImage.init(named: "back-1")
    }

    // MARK: Slider methods
    @objc func updateTime(_ timer: Timer) {
        let currentTime = Int(musicPlayer.currentTime)
        let minutes = currentTime / 60
        let seconds = currentTime - minutes * 60
        timeLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        playbackSlider.value = Float(musicPlayer.currentTime)
    }

    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        let pointTapped: CGPoint = gestureRecognizer.location(in: view)
        let positionOfSlider: CGPoint = playbackSlider.frame.origin
        let widthOfSlider: CGFloat = playbackSlider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(playbackSlider.maximumValue) / widthOfSlider)
        playbackSlider.setValue(Float(newValue), animated: true)
        slidePlayback()
    }

    func slidePlayback() {
        musicPlayer.currentTime = TimeInterval(playbackSlider.value)
    }

    // MARK: Actions methods
    @objc func stopPlay() {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            playButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(stopPlay))
            playButton.tintColor = UIColor.black
            toolBar.items![2] = playButton
            backgroundImage.image = UIImage.init(named: "back-1")
        } else {
            musicPlayer.play()
            playButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.pause, target: self, action: #selector(stopPlay))
            playButton.tintColor = UIColor.black
            toolBar.items![2] = playButton
            backgroundImage.image = UIImage.animatedImageNamed("back-", duration: 1.5)
        }
    }

    func backwardTapped() {
        musicPlayer.currentTime -= 5
    }

    func forwardTapped() {
        musicPlayer.currentTime += 5
    }

    func prepareSongAndSessionPlayer() {
        do {
            //Insert song
            musicPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: self.trackId, ofType: "mp3")!))
            musicPlayer .prepareToPlay()

            //Create session
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback)
            } catch let sessionError {
                print(sessionError)
            }

        } catch let songPlayerError {
            print(songPlayerError)
        }
    }
}
