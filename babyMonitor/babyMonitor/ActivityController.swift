//
//  ActivityController.swift
//  babyMonitor
//
//  Created by yeganeh on 5/22/17.
//  Copyright © 2017 yeganeh. All rights reserved.
//

import UIKit
import CoreData

// Baby activity type
enum BabyActityType : String {
    case CRY, WET, COLD, OUTOFSIGHT, START, END
}

class ActivityController: UITableViewController {
    
    var managedObjectContext : NSManagedObjectContext?
    
    // the activity list that is being displayed
    var babyActivities: [BabyActivity]!
    
    // Application settings stored in Core data
    var settings: Settings!
    
    // Theme color
    let themeColor = UIColor(red: 255/255, green: 80/255, blue: 80/255, alpha: 1.0)
    
    var timer:Timer!
    
    required init?(coder aDecoder:NSCoder){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Reference to the managedObjectContext in AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
        fetchData()
        //        scheduleJobReadSensor()
        // Add notificatioin for reset settings
        NotificationCenter.default.addObserver(self, selector: #selector(resetSettings), name: NSNotification.Name(rawValue: "resetSettingsId"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addActivityStartOrEnd), name: NSNotification.Name(rawValue: "addActivityStartOrEndId"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setHistoryActivity), name: NSNotification.Name(rawValue: "setHistoryActivity"), object: nil)
        
        // Mockup: new BabyActivity object
        
        //             let activity = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
        //                activity.type = BabyActityType.CRY.rawValue
        //                activity.initByType()
        //
        //                let activity2 = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
        //                activity2.type = BabyActityType.WET.rawValue
        //                activity2.initByType()
        //
        //                let activity3 = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
        //                activity3.type = BabyActityType.COLD.rawValue
        //                activity3.initByType()
        //
        //
        //                let activity0 = NSEntityDescription.insertNewObjectForEntityForName("BabyActivity", inManagedObjectContext: managedObjectContext!) as! BabyActivity
        //                activity0.type = BabyActityType.START.rawValue
        //                activity0.initByType()
        //
        //
        //                babyActivities.append(activity0)
        //                babyActivities.append(activity)
        //                babyActivities.append(activity2)
        //                babyActivities.append(activity3)
    }
    
    // If user turn on the monitor switch, add a START activity
    // If user turn off the monitor switch, add a END activity
    func addActivityStartOrEnd(_ notification: Notification){
        let toogle = notification.object as! UISwitch
        if toogle.isOn{
            addBabyActivityInApp(BabyActityType.START.rawValue)
        }else{
            addBabyActivityInApp(BabyActityType.END.rawValue)
        }
    }
    
    // Set activity to history state
    func setHistoryActivity(){
        for a in babyActivities {
            if a.state == 1 {
                a.state = 0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // reload data
        self.tableView.reloadData()
    }
    
    // Reset all the settings
    func resetSettings(_ notification: Notification){
        settings = notification.object as! Settings
        // Reset the timer
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        scheduleJobReadSensor()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController!.navigationBar.barTintColor = themeColor
        self.navigationController!.navigationBar.isTranslucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    // Fetch current dataset
    func fetchData(){
        // Declare fetch entityName
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "BabyActivity")
        // Declare the sort approach, sort by priority in ascending order
        let prioritySort  = NSSortDescriptor(key: "date", ascending: true)
        fetch.sortDescriptors = [prioritySort]
        
        // Fetch for settings
        let fetchSettings = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        do{
            // Fetch request
            let fetchResults = try managedObjectContext!.fetch(fetch) as! [BabyActivity]
            // Initialise the babyActivities using fetch results
            babyActivities = fetchResults
            if babyActivities.count == 0 {
                addBabyActivity(BabyActityType.START.rawValue)
            }
            // Fetch request for settings
            let fetchSettingResults = try managedObjectContext!.fetch(fetchSettings) as! [Settings]
            if fetchSettingResults.count == 0 {
                settings = NSEntityDescription.insertNewObject(forEntityName: "Settings", into: managedObjectContext!) as! Settings
                settings.babyCryVolume = 1700
            }else{
                // Initialise the babyActivities using fetch results
                settings = fetchSettingResults[0]
            }
            
        }catch{
            fatalError("Failed to fetch category information: \(error)")
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Number of monitors is the section number in this tableView
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of activities is the rows number in the section
        return babyActivities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityCell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityLogCell
        let babyActivity = babyActivities[babyActivities.count - 1 - indexPath.row]
        activityCell.time.text = String(describing: babyActivity.date)
        // Set tableViewCell activityName
        if babyActivity.type == BabyActityType.START.rawValue || babyActivity.type == BabyActityType.END.rawValue{
            activityCell.activityName.text = babyActivity.activityName!
        }else{
            activityCell.activityName.text = settings.babyName! + " " + babyActivity.activityName!
        }
        if babyActivity.type == BabyActityType.START.rawValue {
            let dateTxt = getDateText(babyActivity.date!)
            let appendStr = "on \(dateTxt)" as String
            activityCell.activityName.text? += appendStr
        }
        // set font color based on activity state
        if babyActivity.state == 0 {
            activityCell.activityName?.textColor = UIColor.gray
            activityCell.time.textColor = UIColor.gray
        }else if babyActivity.state == 1{
            activityCell.activityName?.textColor = UIColor.black
            activityCell.time.textColor = UIColor.black
        }
        activityCell.icon.image =  babyActivity.getIconForActivity()
        activityCell.time.text = getTimeText(babyActivity.date! as Date)
        activityCell.selectionStyle = UITableViewCellSelectionStyle.none
        return activityCell
    }
    
    
    // Get time in a format text
    func getTimeText(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        // dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = DateFormatter.Style.short
        return dateFormatter.string(from: date)
    }
    
    // set the height of cell.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    // MARK: Timely job to read sensors
    func scheduleJobReadSensor(){
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        if Bool(settings.monitor!) {
            timer = Timer.scheduledTimer(timeInterval: Double(settings.timePeriod!), target: self, selector: #selector(ActivityController.readSensors), userInfo: nil, repeats: true)
        }
    }
    
    // MARK: read from sensors
    // Read data from different sensors
    func readSensors(){
        // Read from sound sensor
        if settings.babyCryOn == 1 {
            readSoundData()
        }
        // Read from mositure sensor
        if settings.diaperWetOn == 1 {
            // Get mositure data or not is based on the sound sensor, see in readSensorData()
            // readMositureData()
        }
        // Read from the temperature sensor
        if settings.tempAnomaly == 1 {
            //Read from the temperature sensor
            readTempData()
            let homeController = self.tabBarController?.viewControllers![0].childViewControllers[0] as! ViewController
            homeController.viewWillAppear(true)
        }
        
    }
    
    // Read temperature data
    func readTempData(){
        let url = URL(string: Constants.temperatureUrl)!
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let result = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            // Async request, write code inside this handler once data has been processed
            do {
                // if no data is being received
                if data == nil {
                    self.showAlertWithDismiss("Error", message: "Server connection error!")
                    return
                }
                // If there is only one group of data sent, which is not a NSArray, this would cause exception
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                // use anyObj here
                //let newObj = anyObj.reverse()
                let sensorData = anyObj
                let temp = sensorData["celsiusData"] as! Double
                self.settings.temperature = temp as NSNumber?
                // If the temperature is below than 25, alert will prompt up
                if temp < 27 {
                    if !self.ifSameActivityIn2Min(BabyActityType.COLD.rawValue){
                        self.showAlertWithDismiss("Warning", message: self.settings.babyName! + " kicked off quilt.")
                        self.addBabyActivityInApp(BabyActityType.COLD.rawValue)
                    }
                }
            } catch {
                print("json error: \(error)")
            }
        })
        result.resume()
    }
    
    // Read mositure data
    func readMositureData(){
        let url = URL(string: Constants.mositureUrl)!
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let result = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            // Async request, write code inside this handler once data has been processed
            do {
                // if no data is being received
                if data == nil {
                    self.showAlertWithDismiss("Error", message: "Server connection error!")
                    return
                }
                // If there is only one group of data sent, which is not a NSArray, this would cause exception
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                // use anyObj here
                //let newObj = anyObj.reverse()
                let sensorData = anyObj
                let mositure = sensorData["moisture"] as! Double
                // If the baby cry
                if mositure >= 700 {
                    // Add the peed activity
                    if !self.ifSameActivityIn2Min(BabyActityType.WET.rawValue){
                        print("Baby peed...")
                        self.showAlertWithDismiss("Warning", message: self.settings.babyName! + " peed.")
                        self.addBabyActivityInApp(BabyActityType.WET.rawValue)
                    }
                }else{
                    if !self.ifSameActivityIn2Min(BabyActityType.CRY.rawValue) && !self.ifSameActivityIn2Min(BabyActityType.WET.rawValue){
                        self.showAlertWithDismiss("Warning", message: self.settings.babyName! + " cried, was missing you")
                        self.addBabyActivityInApp(BabyActityType.CRY.rawValue)
                        print("Baby's diaper is dry")
                    }
                }
                
            } catch {
                print("json error: \(error)")
            }
        })
        result.resume()
    }
    
    
    
    // Read data from sound server
    func readSoundData(){
        let url = URL(string: Constants.soundUrl)!
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let result = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            // Async request, write code inside this handler once data has been processed
            do {
                // if no data is being received
                if data == nil {
                    self.showAlertWithDismiss("Error", message: "Server connection error!")
                    return
                }
                // If there is only one group of data sent, which is not a NSArray, this would cause exception
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                // use anyObj here
                //let newObj = anyObj.reverse()
                let sensorData = anyObj
                if sensorData["frequency"] == nil{
                    return
                }
                let volume = sensorData["frequency"] as! Double
                // If the baby cry
                if volume >= Double(self.settings.babyCryVolume!){
                    let babyName = self.settings.babyName!
                    let warning = "Warning"
                    print("------------Start--------------")
                    
                    var result = "Detected"
                    // If the notification of out of sight is turned on
                    if self.settings.sightOn == 1 {
                        // Detect if the baby is in sight or not
                        result = self.detect()
                    }
                    // If the baby is out of sight
                    if result == "OutOfSight" {
                        print("Baby was out of sight...")
                        if !self.ifSameActivityIn2Min(BabyActityType.OUTOFSIGHT.rawValue){
                            self.showAlertWithDismiss(warning, message: babyName + " was out of sight.")
                            self.addBabyActivityInApp(BabyActityType.OUTOFSIGHT.rawValue)
                        }
                    }else if result == "Detected"{
                        // If baby is in sight and peed
                        if self.settings.diaperWetOn == 1 {
                            print("Face detected, then detect if baby peed or not")
                            self.readMositureData()
                        }else {
                            print("Diaper wet switch is turned off")
                            if !self.ifSameActivityIn2Min(BabyActityType.CRY.rawValue) {
                                self.showAlertWithDismiss("Warning", message: self.settings.babyName! + " cried, was missing you")
                                self.addBabyActivityInApp(BabyActityType.CRY.rawValue)
                            }
                            
                        }
                    }
                    // Add the cry activity
                    //                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3000 * Int64(NSEC_PER_MSEC))
                    //                        dispatch_after(time, dispatch_get_main_queue()) {
                    //                            self.showAlertWithDismiss(warning, message: babyName + " cried, was missing you")
                    //                            print("Baby cried, was missing you...")
                    //                            print("------------------End----------\n")
                    //                    }
                }
            } catch {
                print("json error: \(error)")
            }
        })
        result.resume()
    }
    
    // Detect if the baby is out of sight
    func detect() -> String{
        let url:URL = URL(string: Constants.cameraHideUrl)!
        let data = try? Data(contentsOf: url)
        if data == nil{
            return "NoData"
        }
        let hideBabyPhoto = UIImage(data:data!)
        guard let personciImage = CIImage(image: hideBabyPhoto!)
            else {
                return "Unknown"
        }
        // Using core image here
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector!.features(in: personciImage) as! [CIFaceFeature]
        if faces.count == 0 {
            return "OutOfSight"
        }
        return "Detected"
    }
    
    // detect if the activity is same inside 2 miniutes
    func ifSameActivityIn2Min(_ type:String) -> Bool{
        if babyActivities.count == 0 {
            return false
        }
        let activities : [BabyActivity] = babyActivities.reversed()
        for activity in activities {
            // If the time interval between the two activities with same type is less than 5 miniutes
            // Then the APP will not record this activity as well as not sending notifications
            if activity.type == type {
                //                print(minutesFrom(activity.date!))
                if minutesFrom(activity.date!) < 2 {
                    return true
                }else{
                    return false
                }
                //                return minutesFrom(activity.date!) < 2
            }
        }
        return false
    }
    
    // Add a baby activity with checkings and reloading
    func addBabyActivityInApp(_ type:String){
        // If the activity is starting monitor or ending monitor, it is not the same activity
        if type != BabyActityType.START.rawValue && type != BabyActityType.END.rawValue {
            // If the activity is the same in 5 miniutes, do not append
            if ifSameActivityIn2Min(type){
                //                print("Activity in 2 miniutes, return")
                return
            }
        }
        addBabyActivity(type)
        self.tableView.reloadData()
        // Refresh home page
        let homeController = self.tabBarController?.viewControllers![0].childViewControllers[0] as! ViewController
        homeController.viewWillAppear(true)
        viewWillAppear(true)
    }
    
    // Only add a baby activity
    func addBabyActivity(_ type:String){
        let newActivity = NSEntityDescription.insertNewObject(forEntityName: "BabyActivity", into: managedObjectContext!) as! BabyActivity
        newActivity.type = type
        newActivity.initByType()
        babyActivities.append(newActivity)
        do{
            try managedObjectContext!.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    // Show different alert based on different baby activities
    //    func showAlertForActivities(type:String){
    //        let babyName : String = settings.babyName!
    //        var warningInfo :String = ""
    //        if type == BabyActityType.COLD.rawValue {
    //        }else if type == BabyActityType.WET.rawValue{
    //        }else if type == BabyActityType.Cry
    //        switch type{
    //        case BabyActityType.COLD.rawValue:
    //            print("Baby kicked off quilt...")
    //            warningInfo = babyName + " kicked off quilt!"
    //            break
    ////        case BabyActityType.CRY.rawValue:
    ////            warningInfo = babyName + " cried, was missing you!"
    ////            break
    //        case BabyActityType.WET.rawValue:
    //            warningInfo = babyName + " peed!"
    //            break
    //        default:
    //            warningInfo = babyName + " was out of sight!"
    //            break
    //        }
    //        showAlertWithDismiss("Warning", message: warningInfo)
    //    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    // The data is prepared for chart controller
    var pieChartData :  Dictionary<String, Int>!
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "chartSeg"{
            pieChartData  =  Dictionary<String, Int>()
            for i in 0 ..< babyActivities.count {
                let activity = babyActivities[i]
                if activity.type != BabyActityType.START.rawValue && activity.type != BabyActityType.END.rawValue
                {
                    // Analysis  the activities except START and END activity
                    let key = activity.type!
                    if  pieChartData.index(forKey: key) == nil {
                        pieChartData.updateValue(1, forKey: key)
                    }else{
                        let v = pieChartData[key]! + 1
                        pieChartData.updateValue(v, forKey: key)
                    }
                }
            }
            // If the piechart has no data, it will not allowed to view the chart
            if pieChartData.count == 0{
                self.showAlertWithDismiss("Reminder", message: "No activity yet.")
                return false
            }
            //Continue with the segue
        }
        return true
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chartSeg" {
          //  let cont = segue.destination as! ShinobiChartController
         //   cont.babyActivities = self.babyActivities
         //   cont.babyName = settings.babyName
         //   cont.pieChartData = pieChartData
        }
    }
}
