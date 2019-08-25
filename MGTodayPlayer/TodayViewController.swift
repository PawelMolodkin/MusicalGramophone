//
//  TodayViewController.swift
//  MGTodayPlayer
//
//  Created by Pavel Molodkin on 25/08/2019.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet var playButton: UIButton!
    var wormhole = MMWormhole()
    var play = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.wormhole = MMWormhole(applicationGroupIdentifier: "group.com.MusicGramophone", optionalDirectory: nil)
        // Do any additional setup after loading the view.
    }
        
    @IBAction func playTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.play = !self.play
            if self.play {
                self.playButton.setImage(UIImage.init(named: "pauseIcon.png"), for: UIControl.State.normal)
            } else {
                self.playButton.setImage(UIImage.init(named: "playIcon.png"), for: UIControl.State.normal)
            }

            self.wormhole.passMessageObject(nil, identifier: "togglePlayPause")
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
