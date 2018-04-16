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
    
    func createChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        // socketManager.defaultSocket.emit("newChannel", channelName, channelDescription)
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        
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
    
    func addMessage(messageText: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        
        socket.emit("newMessage", messageText, userId, channelId, user.userName, user.avatarImageName, user.backgroundColor)
        completion(true)
    }
    
    func getMessage(completion: @escaping CompletionHandler) {

        socket.on("messageCreated") { (dataArray, ack) in
            guard let messageText = dataArray[0] as? String else { return }
            // guard let userId = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let userAvatarImage = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let messageId = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }

            // Check if the channel where the message was created is the Selected Channel
            if channelId == MessageService.instance.selectedChannel?.channelId && AuthServices.instance.isLoggedIn {
                let newMessage:Message = Message(messageText: messageText, userName: userName, channelId: channelId,
                                                 userAvatar: userAvatarImage, userAvatarColor: userAvatarColor, messageId: messageId, timeStamp: timeStamp)
                MessageService.instance.messages.append(newMessage)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        
        socket.on("userTypingUpdate") { (dataArray, ack) in
            
            // The dictionary is key value pair:
            //      Key: user name
            //      Value: channel id
            guard let typingUsers = dataArray[0] as? [String: String] else { return }
            completionHandler(typingUsers)           
        }
        
    }
    
    func stopTyping() {
        guard let channelId = MessageService.instance.selectedChannel?.channelId else { return }
        
        socket.emit("stopType", UserDataService.instance.userName, channelId)
    }
    func startTyping() {
        guard let channelId = MessageService.instance.selectedChannel?.channelId else { return }

        socket.emit("startType", UserDataService.instance.userName, channelId)
    }

}
