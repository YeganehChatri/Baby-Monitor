//
//  Settings+CoreDataProperties.swift
//  babyMonitor
//
//  Created by yeganeh on 5/25/17.
//  Copyright © 2017 yeganeh. All rights reserved.
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings");
    }

    @NSManaged public var babyCryOn: NSNumber?
    @NSManaged public var babyCryVolume: NSNumber?
    @NSManaged public var babyName: String?
    @NSManaged public var diaperWetOn: NSNumber?
    @NSManaged public var homePageInfo: String?
    @NSManaged public var homePagePhoto: Data?
    @NSManaged public var monitor: NSNumber?
    @NSManaged public var sightOn: NSNumber?
    @NSManaged public var tempAnomaly: NSNumber?
    @NSManaged public var temperature: NSNumber?
    @NSManaged public var timePeriod: NSNumber?
    @NSManaged public var useDefaultHomePage: NSNumber?

}
