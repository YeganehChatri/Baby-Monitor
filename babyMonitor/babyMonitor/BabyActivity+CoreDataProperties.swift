//
//  BabyActivity+CoreDataProperties.swift
//  babyMonitor
//
//  Created by yeganeh on 5/25/17.
//  Copyright © 2017 yeganeh. All rights reserved.
//

import Foundation
import CoreData


extension BabyActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BabyActivity> {
        return NSFetchRequest<BabyActivity>(entityName: "BabyActivity");
    }

    @NSManaged public var activityName: String?
    @NSManaged public var date: Date?
    @NSManaged public var icon: String?
    @NSManaged public var state: NSNumber?
    @NSManaged public var type: String?

}
