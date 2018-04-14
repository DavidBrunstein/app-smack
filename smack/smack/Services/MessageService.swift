//
//  MessageService.swift
//  smack
//
//  Created by David Brunstein on 2018-04-13.
//  Copyright © 2018 David Brunstein. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    // Singleton
    static let instance = MessageService()
    
    var channels = [Channel]()
    var selectedChannel: Channel?
    
    func findAllChannels(completion: @escaping CompletionHander) {
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: API_BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else { return }
                if let jsonArray = JSON(data).array {
                    for jsonItem in jsonArray {
                        let name = jsonItem["name"].stringValue
                        let description = jsonItem["description"].stringValue
                        let id = jsonItem["_id"].stringValue
                        
                        let channel = Channel(channelId: id, channelName: name, channelDescription: description)
                        self.channels.append(channel)
                    }
                    
                    // Post the notification that the channels were loaded
                    NotificationCenter.default.post(name: NOTIFICATION_CHANNELS_LOADED, object: nil)
                    
                    completion(true)
                }
                print(self.channels)

            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
    
}
