//
//  MGAlbumDataSource.swift
//  MusicalGramophone
//
//  Created by Pavel Molodkin on 24/08/2019.
//

import Foundation
import UIKit

class MGGenericDataSource<T> : NSObject {
    var data: MGDynamicValue<[T]> = MGDynamicValue([])
    var nameAlbum = ""
    var peopleName = ""
}

class MGAlbumDataSource : MGGenericDataSource<NSArray>, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var trackList: NSArray = []
        var countRows = 0
        if data.value.count > 0 {
            trackList = self.data.value[0]
            countRows = trackList.count
            countRows += 1
        }
        return countRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.row == 0) {
            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "MGDescriptionCell", for: indexPath) as! MGDescriptionCell
            descriptionCell.backgroundColor = UIColor.clear
            descriptionCell.albumNameLabel.text = self.nameAlbum
            descriptionCell.peoplenameLabel.text = self.peopleName
            descriptionCell.isUserInteractionEnabled = false
            return descriptionCell
        } else {
            let trackList = self.data.value[0]
            let track = trackList[indexPath.row - 1] as! NSDictionary
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ??
                UITableViewCell(style: .default, reuseIdentifier: "cell")
            let selectedView = UIView()
            selectedView.backgroundColor = UIColor.init(red: 100/255, green: 100/255, blue: 250/255, alpha: 0.3)
            cell.selectedBackgroundView =  selectedView;
            cell.textLabel!.text = track["name"] as? String
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.textColor = UIColor.white
            cell.imageView?.image = UIImage(named: "playImage")
            return cell
        }
    }
}
