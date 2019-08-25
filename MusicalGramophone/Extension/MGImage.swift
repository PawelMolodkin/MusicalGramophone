//
//  MGImage.swift
//  MusicalGramophone
//
//  Created by Pavel Molodkin on 25/08/2019.
//

import UIKit
import Foundation

extension UIImageView {
    public func imageFromURL(urlString: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }
}
