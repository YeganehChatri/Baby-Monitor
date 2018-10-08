//
//  UtilityForViewControllers.swift
//  babyMonitor
//
//  Created by yeganeh on 5/22/17.
//  Copyright © 2017 yeganeh. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    // Returns the amount of minutes from another date
    func minutesFrom(_ date: Date) -> Int{
        // Reference: stackoverflow.com/questions/27182023/getting-the-difference-between-two-nsdates-in-months-days-hours-minutes-seconds
        let currentDate = Date()
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: currentDate, options: []).minute!
    }
    
    // Returns the amount of days from another date
    func daysFrom(_ date: Date) -> Int{
        let currentDate = Date()
        return (Calendar.current as NSCalendar).components(.day, from: date, to: currentDate, options: []).day!
    }
    
    // Returns the amount of hours from another date
    func hoursFrom(_ date: Date) -> Int{
        let currentDate = Date()
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: currentDate, options: []).hour!
    }
    
    // Return the amount of hours from oldDate to newDate
    func minutesFromTwoDate(_ oldDate: Date, newDate: Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: oldDate, to: newDate, options: []).minute!
    }
    
    // Get date in text format
    func getDateText(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        return dateFormatter.string(from: date)
    }
    
    // Get date in text format
    func getDateShortText(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        return dateFormatter.string(from: date)
    }
    
    func showAlertWithDismiss(_ title:String, message:String) {
        //        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //        let alertDismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        //        alertController.addAction(alertDismissAction)
        //        self.presentViewController(alertController, animated: true, completion: nil)
        
        if UIApplication.shared.applicationState == .active {
            // App is active, show an alert
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            // App is inactive, show a notification
            let notification = UILocalNotification()
            notification.alertTitle = title
            notification.alertBody = message
            UIApplication.shared.presentLocalNotificationNow(notification)
        }
        
    }
    
    
}

struct Constants {
    // Temperature sensor server location
    static let temperatureUrl = "http://172.20.10.5:8088/"
    static let cameraUrl = "http://172.20.10.5/cameravideo.php"
    static let mositureUrl = "http://172.20.10.2:8087/"
    static let soundUrl = "http://172.20.10.5:8001/"
    
    static let cameraHideUrl = "http://172.20.10.5/cam.jpg"
}
