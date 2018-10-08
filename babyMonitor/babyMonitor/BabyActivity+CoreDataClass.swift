//
//  BabyActivity+CoreDataClass.swift
//  babyMonitor
//
//  Created by yeganeh on 5/25/17.
//  Copyright © 2017 yeganeh. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class BabyActivity: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    func initByType()->BabyActivity{
        //        let babyName = "Kevin "
        self.date = Date()
        // if the state = 1, meaning it's the activity in current monitoring phase [new]
        // if the state = 0, meaning it's the history activity in previous monitoring phase [history]
        self.state = 1
        switch self.type!{
        case BabyActityType.CRY.rawValue:
            self.activityName = "cried"
            return self
        case BabyActityType.WET.rawValue:
            self.activityName = "peed"
            return self
        case BabyActityType.COLD.rawValue:
            self.activityName = "kicked off quilt"
            return self
        case BabyActityType.OUTOFSIGHT.rawValue:
            self.activityName = "out of sight"
            return self
        case BabyActityType.START.rawValue:
            self.activityName = "Monitor started "
            return self
        case BabyActityType.END.rawValue:
            self.activityName = "Monitor end"
            return self
        default:
            self.activityName = "Error"
            return self
        }
    }
    
    func getIconForActivity()->UIImage{
        switch self.type!{
        case BabyActityType.CRY.rawValue:
            return UIImage(named:"Crying")!
        case BabyActityType.WET.rawValue:
            return UIImage(named: "Nappy")!
        case BabyActityType.COLD.rawValue:
            return UIImage(named: "Cold")!
        case BabyActityType.START.rawValue:
            return UIImage(named: "Start")!
        case BabyActityType.END.rawValue:
            return UIImage(named: "Stop")!
        case BabyActityType.OUTOFSIGHT.rawValue:
            return UIImage(named:"Footprints")!
        default:
            return UIImage(named:"Start")!
        }
    }

}
