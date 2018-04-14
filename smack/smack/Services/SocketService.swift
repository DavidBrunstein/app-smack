//
//  SocketService.swift
//  smack
//
//  Created by David Brunstein on 2018-04-13.
//  Copyright © 2018 David Brunstein. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    // Singleton
    static let instance = SocketService()

    private let manager: SocketManager
    private var socket: SocketIOClient

    private override init() {
        
        manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
        // socket = manager.socket(forNamespace: "/swift")
        socket = manager.defaultSocket
        
        super.init()
    }

    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func createChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHander) {
        // socketManager.defaultSocket.emit("newChannel", channelName, channelDescription)
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHander) {
        
//        socketManager.defaultSocket.on("channelCreated") { (dataArray, ack) in
//            guard let channelName = dataArray[0] as? String else { return }
//            guard let channelDescrition = dataArray[1] as? String else { return }
//            guard let channelId = dataArray[2] as? String else { return }
//
//            let newChannel:Channel = Channel(channelId: channelId, channelName: channelName, channelDescription: channelDescrition)
//            MessageService.instance.channels.append(newChannel)
//            completion(true)
//        }
//
        
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDescrition = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }

            let newChannel:Channel = Channel(channelId: channelId, channelName: channelName, channelDescription: channelDescrition)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
}
