//
//  ViewController.swift
//  P21_Local_Notifications
//
//  Created by Laura on 29.08.2022..
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()                         // access the current version of user Notification centre which lets us post msg on home screen
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted { print("YAY")} else { print("sheit")}
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title              = "Late wake up call"
        content.body               = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo           = ["customData": "fizzbuzz"]
        content.sound              = .default
        
        var dateComponents    = DateComponents()
        dateComponents.hour   = 10
        dateComponents.minute = 30
//        let trigger           = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger           = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)    // foreground - when this btn is tapped, launch this app imediately
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    // @escaping - can escape current method and be used later on
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out buried user info dict
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {         // read custom data key inside userInfo dict
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("default identifier")                            // user swiped to unlock
                
            case "show":
                print("Show more info.")
                
            default:
                break
            }
        }
        
        completionHandler()
    }

}

