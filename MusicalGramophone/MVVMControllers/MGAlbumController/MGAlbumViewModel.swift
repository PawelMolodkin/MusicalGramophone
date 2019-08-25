//
//  ViewModel.swift
//  MusicalGramophone
//
//  Created by Pavel Molodkin on 24/08/2019.
//

import Foundation
import UIKit

class MGAlbumViewModel {

    weak var dataSource : MGAlbumDataSource?
    var albumId: String = ""
    var albumName: String = ""
    var peopleName: String = ""
    var tracksArray: NSArray = []
    var imageView = UIImageView()


    init(id: String, dataSource : MGAlbumDataSource?) {
        self.albumId = id
        self.dataSource = dataSource
    }

    func loadAlbum(success successBlock: @escaping (() -> Void), failure failureBlock: @escaping (() -> Void)) {
        let loader = MGLoader.init()
        loader.loadAlbum(withId: self.albumId, { (album, tracks, people) in
            let imageUrl = album["cover"] as! String
            self.imageView.imageFromURL(urlString: "https://static-cdn.enazadev.ru/" + imageUrl)
            self.albumName = album["name"] as! String
            self.peopleName = people
            self.tracksArray = [tracks.allValues]
            self.dataSource?.nameAlbum = self.albumName
            self.dataSource?.peopleName = people
            (self.dataSource?.data.value = self.tracksArray as! [NSArray])!
            successBlock()
        }, failure: { error in
            failureBlock()
            print(error.localizedDescription)
        })
    }

    func showPlayerViewController(ownerViewController: UIViewController, count: NSInteger) {
        let viewController = MGPlayerMusicViewController.init(nibName: "MGPlayerMusicViewController", bundle: nil)

        var trackName = ""
        var trackId = ""
        if tracksArray.count > 0 {
            let tracksArray = self.tracksArray[0] as! NSArray
            let trackDict = tracksArray[count] as! NSDictionary
            trackName = trackDict["name"] as! String
            trackId = trackDict["id"] as! String
        }

        let trackInfo = MGTrack.init(peopleName: self.peopleName, albumName: self.albumName, trackName: trackName, trackId: trackId)
        viewController.viewModel = MGPLayerMusicViewModel.init(trackInfo: trackInfo, albumImage: self.imageView.image!)


        let backButton = UIBarButtonItem(title: "Close", style: .plain, target: viewController, action: #selector(viewController.dismissViewController(gestureRecognizer:)))
        backButton.tintColor = UIColor.black
        viewController.navigationItem.leftBarButtonItem = backButton

        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        ownerViewController.navigationController?.view.layer.add(transition, forKey: nil)
        ownerViewController.navigationController?.pushViewController(viewController, animated: false)
    }
}
