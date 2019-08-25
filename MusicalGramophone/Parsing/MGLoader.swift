//
//  MGLoader.swift
//  MusicalGramophone
//
//  Created by Pavel Molodkin on 23/08/2019.
//

import Foundation

class MGLoader {

    var albumDict: NSDictionary = [:]
    var tracksDict: NSDictionary = [:]
    var peopleId: String = ""
    var peopleName: String = ""


    func loadAlbum(withId id: String, _ success: @escaping (_ album : NSDictionary,_ tracks: NSDictionary,_ people: String) -> Void, failure: @escaping (Error) -> Void) {

        let url = NSURL(string: "https://api.mobimusic.kz/?method=product.getCard&productId=" + id)

        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if error != nil {
                failure(error!)
                return
            }
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                if let collection = jsonObj.value(forKey: "collection") as? NSDictionary {
                    // Album parse
                    if (collection["album"] as? NSDictionary) != nil {
                        if let albumDictionary = collection["album"] as? NSDictionary {
                            let albumArray = albumDictionary.allValues
                            self.albumDict = albumArray[0] as! NSDictionary
                            if let album = albumDictionary[id] as? NSDictionary {
                                 let idArray = album["peopleIds"] as! NSArray
                                self.peopleId = idArray.firstObject as! String
                            }
                        }
                    }
                    // Tracks parse
                    if (collection["track"] as? NSDictionary) != nil {
                        if let trackDictionary = collection["track"] as? NSDictionary {
                            self.tracksDict = trackDictionary
                        }
                    }

                    if (collection["people"] as? NSDictionary) != nil {
                        if let peopleDictionary = collection["people"] as? NSDictionary {
                            if let people = peopleDictionary[self.peopleId] as? NSDictionary {
                               self.peopleName = people["name"] as! String
                            }
                        }
                    }

                    success(self.albumDict, self.tracksDict, self.peopleName)
                }
            }
        }).resume()
    }
}




