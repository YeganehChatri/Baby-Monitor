//
//  ViewController.swift
//  babyMonitor
//
//  Created by yeganeh on 5/22/17.
//  Copyright © 2017 yeganeh. All rights reserved.
//

import UIKit
import CoreData
import CoreImage

class ViewController: UIViewController {

    @IBOutlet weak var lastActivityLabel: UILabel!
    @IBOutlet weak var babyPhone: UIImageView!
    @IBOutlet weak var latestUpdateTemp: UILabel!
    
    var managedObjectContext : NSManagedObjectContext?
    
    // Application settings stored in Core data
    var settings:Settings?
    
    
    // the activity list that is being displayed
    var babyActivities: [BabyActivity]!
    
    // Application theme color
    let themeColor = UIColor(red: 255/255, green: 80/255, blue: 80/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        let activityController = self.tabBarController?.viewControllers![1].childViewControllers[0] as! ActivityController
        activityController.scheduleJobReadSensor()
        // set home page photo
        //let image = UIImage(data: (settings?.homePagePhoto)!)
        //babyPhone.image = image
        babyPhone.image = UIImage(named: "baby_smile")
        
        // set navigation bar / status bar color
        self.navigationController!.navigationBar.barTintColor = themeColor
        self.navigationController!.navigationBar.isTranslucent = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        
        // Set home page background
        if (settings?.homePagePhoto == nil)
        {
            babyPhone.image = UIImage(named: "baby_smile")
        }
        else
        {
            let image = UIImage(data: (settings?.homePagePhoto)! as Data)
            babyPhone.image = image
        }
        
        // Set home page temperature
        if settings?.temperature ==  nil{
            latestUpdateTemp.text =  ""
            print("Have not read the temperature yet")
        }else{
            latestUpdateTemp.text =  "\(settings!.temperature!)°C"
        }
        latestUpdateTemp.textColor = themeColor
        
        // Get latest activity
        if babyActivities.count > 0 {
            lastActivityLabel.textColor = themeColor
            lastActivityLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
            let activity = babyActivities[babyActivities.count - 1]
            let miniAgo = minutesFrom(activity.date!)
            let hourAgo = hoursFrom(activity.date!)
            let dayAgo = daysFrom(activity.date!)
            let activityName = (settings!.babyName )! + " " + activity.activityName!
            if miniAgo <= 1 {
                lastActivityLabel.text = "\(activityName) just now."
                return
            }else if hourAgo < 1 {
                // Within an hour
                lastActivityLabel.text = "\(miniAgo) miniutes ago, \(activityName)"
                return
            }else if dayAgo < 1 {
                lastActivityLabel.text = "\(hourAgo) hours ago, \(activityName)"
                return
            }else if dayAgo < 7 {
                lastActivityLabel.text = "\(dayAgo) days ago, \(activityName)"
                return
            }else {
                lastActivityLabel.text = "Have not monitored your baby for a long time"
                return
            }
        }
    }
    
    required init?(coder aDecoder:NSCoder){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Reference to the managedObjectContext in AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Fetch data from core data
    func fetchData(){
        // Declare fetch entityName
        let fetchSettings = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        let fetchActivities = NSFetchRequest<NSFetchRequestResult>(entityName: "BabyActivity")
        // Declare the sort approach, sort by priority in ascending order
        let prioritySort  = NSSortDescriptor(key: "date", ascending: true)
        fetchActivities.sortDescriptors = [prioritySort]
        do{
            // Fetch request
            let fetchActivityResults = try managedObjectContext!.fetch(fetchActivities) as! [BabyActivity]
            // Initialise the babyActivities using fetch results
            babyActivities = fetchActivityResults
            // Fetch request
            let fetchSettingResults = try managedObjectContext!.fetch(fetchSettings) as! [Settings]
            if fetchSettingResults.count == 0 {
                settings = NSEntityDescription.insertNewObject(forEntityName: "Settings", into: managedObjectContext!) as? Settings
            }else{
                // Initialise the settings using fetch results
                settings = fetchSettingResults[0]
            }
        }catch{
            fatalError("Failed to fetch category information: \(error)")
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }



}

