//
//  MGTrackViewController.swift
//  MusicalGramophone
//
//  Created by Pavel Molodkin on 22/08/2019.
//

import UIKit
import AVFoundation

class MGPlayerMusicViewController: UIViewController {

    var viewModel: MGPLayerMusicViewModel?
    var trackId: String!
    @IBOutlet var trackName: UILabel!
    @IBOutlet var albumName: UILabel!
    @IBOutlet var peopleName: UILabel!

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var playButton: UIBarButtonItem!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var playbackSlider: UISlider!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var imageViewWidth: NSLayoutConstraint!
    @IBOutlet var backgroundImage: UIImageView!

    var wormhole = MMWormhole()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewModel()
        loadLabels()
        imageView.layer.cornerRadius = 10.0
        let topSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(gesture:)))
        let bottomSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(gesture:)))
        topSwipe.direction = .up
        bottomSwipe.direction = .down
        view.addGestureRecognizer(topSwipe)
        view.addGestureRecognizer(bottomSwipe)
        tappedPlay(Any.self)

       self.wormhole = MMWormhole(applicationGroupIdentifier: "group.com.MusicGramophone", optionalDirectory: nil)
        wormhole.listenForMessage(withIdentifier: "togglePlayPause") { (message) in
            self.tappedPlay(Any.self)
        }
    }


    // MARK: Layout methods
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIApplication.shared.statusBarOrientation.isLandscape {
                imageViewWidth.constant = self.view.frame.size.width / 6
            } else {
                imageViewWidth.constant = self.view.frame.size.width / 2
            }
        }
    }

    // MARK: ViewModel fill methods
    func loadViewModel() {
        viewModel?.playButton = playButton
        viewModel?.playbackSlider = playbackSlider
        viewModel?.timeLabel = timeLabel
        viewModel?.backgroundImage = backgroundImage
        viewModel?.toolBar = toolBar
        viewModel?.imageView = imageView
        viewModel?.loadModel(view: self.view)
    }

    func loadLabels() {
        if let viewModel = viewModel {
            peopleName.text = viewModel.peopleName
            albumName.text = viewModel.albumName
            trackName.text = viewModel.trackName
            trackId = viewModel.trackId
        }
    }

    // MARK: Swipes methods
    @objc func handleSwipes(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            dismissViewController(gestureRecognizer: swipeGesture)
        }
    }

    // MARK: ViewController methods
    @objc func dismissViewController(gestureRecognizer : UIGestureRecognizer) {
        viewModel?.dismissViewController(viewController: self, gestureRecognizer)
    }

    // MARK: Actions

    @IBAction func slidePlayback(_ sender: Any) {
        viewModel?.slidePlayback()
    }

    @IBAction func tappedPlay(_ sender: Any) {
        viewModel?.stopPlay()
    }
    @IBAction func backwardTapped(_ sender: Any) {
        viewModel?.backwardTapped()
    }

    @IBAction func forwardTapped(_ sender: Any) {
        viewModel?.forwardTapped()
    }
}

