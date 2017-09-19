//
//  ViewController.swift
//  newNotifications
//
//  Created by Luis  Costa on 19/09/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Request permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {granted, error in
            if granted {
                print("Notification access granted")
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    @IBAction func notifyButtonPressed(_ sender: Any) {
        scheduleNotification(inSeconds: 5, completion: {success in
            if success {
                print("Notification created")
            } else {
                print("It wasn't possible to create a new notification")
            }
        })
    }
    
    func scheduleNotification(inSeconds: TimeInterval, completion: @escaping (_ success: Bool) -> ()) {
        
        guard let imageURL = Bundle.main.url(forResource: "rick_grimes", withExtension: "gif") else {
            completion(false)
            return
        }
        
        let attachment = try! UNNotificationAttachment(identifier: "myNotification", url: imageURL, options: .none)
        
        // Create a notification content
        let notification = UNMutableNotificationContent()
        notification.title = "New notification"
        notification.sound = UNNotificationSound.default()
        notification.subtitle = "Some text as subtitle"
        notification.body = "The new notification options are wicked!"
        notification.attachments = [attachment]
        
        // Create  notification Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        // create notification request
        let requesNotification = UNNotificationRequest(identifier: "myNotification", content: notification, trigger: notificationTrigger)
        
        // Add new notification to qhe center od notifications
        UNUserNotificationCenter.current().add(requesNotification, withCompletionHandler: {error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        })
    }
}

