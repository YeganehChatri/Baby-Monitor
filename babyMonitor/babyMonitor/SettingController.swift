//
//  SettingController.swift
//  babyMonitor
//
//  Created by yeganeh on 5/25/17.
//  Copyright © 2017 yeganeh. All rights reserved.
//

import UIKit
import CoreData

class SettingController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SetBabyNameDelegate {
    
    var managedObjectContext : NSManagedObjectContext!
    // Application settings stored in Core data
    var settings:Settings!
    
    // Cells in the tableview
    var monitorCell : SettingCell!
    var monitorTimeCell : SettingTimePeriodCell!
    
    var cryCell : SettingCell!
    var volumeCell : SettingVolumeCell!
    var outOfSightCell : SettingCell!
    var diaperCell : SettingCell!
    var quiltCell : SettingCell!
    
    var resetHomeImgCell : SettingDefaultImgCell!
    
    // MARK: Time period settings
    // 10 seconds
    let realTime = 10
    // 5 miniutes
    let fiveMin = 300
    // 15 miniutes
    let fifteenMin = 900
    
    // Application theme color
    let themeColor = UIColor(red: 255/255, green: 80/255, blue: 80/255, alpha: 1.0)
    
    required init?(coder aDecoder:NSCoder){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Reference to the managedObjectContext in AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()// set navigation bar / status bar color
        self.navigationController!.navigationBar.barTintColor = themeColor
        self.navigationController!.navigationBar.isTranslucent = true
        // Remove blank rows
        tableView.tableFooterView = UIView()
        
        initCells()
        // Add target functions to different tableView Cells
        monitorCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffSubControls), for: UIControlEvents.valueChanged)
        cryCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffCryNotification), for: UIControlEvents.valueChanged)
        diaperCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffDiaperNotification), for: UIControlEvents.valueChanged)
        quiltCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffQuiltNotification), for: UIControlEvents.valueChanged)
        monitorTimeCell.timePeriod.addTarget(self, action: #selector(SettingController.changeTimePeriod), for: UIControlEvents.valueChanged)
        volumeCell.volumeSlider.addTarget(self, action: #selector(SettingController.changeVolume), for: UIControlEvents.valueChanged)
        resetHomeImgCell.resetHomeImg.addTarget(self, action: #selector(SettingController.resetHomeImge), for: UIControlEvents.touchDown)
        outOfSightCell.switchOnOff.addTarget(self, action: #selector(SettingController.turnOffOutSightNotification), for: UIControlEvents.valueChanged)
    }
    
    // Initialise tableView cells
    func initCells(){
        monitorCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SettingCell
        monitorTimeCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SettingTimePeriodCell
        
        cryCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! SettingCell
        volumeCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! SettingVolumeCell
        outOfSightCell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! SettingCell
        diaperCell = tableView.cellForRow(at: IndexPath(row: 3, section: 1)) as! SettingCell
        
        quiltCell = tableView.cellForRow(at: IndexPath(row: 0, section:2)) as! SettingCell
        
        resetHomeImgCell = tableView.cellForRow(at: IndexPath(row: 1, section: 3)) as! SettingDefaultImgCell
        
        // Initialise status of switches
        //        if monitorCell.switchOnOff.on {
        //            monitorTimeCell.timePeriod.enabled = true
        //            cryCell.switchOnOff.enabled = true
        //            quiltCell.switchOnOff.enabled = true
        //        }else{
        //            monitorTimeCell.timePeriod.enabled = false
        //            cryCell.switchOnOff.enabled = false
        //            quiltCell.switchOnOff.enabled = false
        //        }
        //
        //        if cryCell.switchOnOff.on && cryCell.switchOnOff.enabled{
        //            volumeCell.volumeSlider.enabled = true
        //            outOfSightCell.switchOnOff.enabled = true
        //            diaperCell.switchOnOff.enabled = true
        //        }else if !cryCell.switchOnOff.on || !cryCell.switchOnOff.enabled{
        //            volumeCell.volumeSlider.enabled = false
        //            outOfSightCell.switchOnOff.enabled = false
        //            diaperCell.switchOnOff.enabled = false
        //        }
        initSwitchState(monitorCell.switchOnOff)
    }
    
    func initSwitchState(_ toogle:UISwitch){
        // Initialise status of switches
        if toogle.isOn {
            monitorTimeCell.timePeriod.isEnabled = true
            cryCell.switchOnOff.isEnabled = true
            quiltCell.switchOnOff.isEnabled = true
        }else{
            monitorTimeCell.timePeriod.isEnabled = false
            cryCell.switchOnOff.isEnabled = false
            quiltCell.switchOnOff.isEnabled = false
        }
        
        if cryCell.switchOnOff.isOn && cryCell.switchOnOff.isEnabled{
            volumeCell.volumeSlider.isEnabled = true
            outOfSightCell.switchOnOff.isEnabled = true
            diaperCell.switchOnOff.isEnabled = true
        }else if !cryCell.switchOnOff.isOn || !cryCell.switchOnOff.isEnabled{
            volumeCell.volumeSlider.isEnabled = false
            outOfSightCell.switchOnOff.isEnabled = false
            diaperCell.switchOnOff.isEnabled = false
        }
    }
    
    // Fetch current dataset
    func fetchData(){
        // Declare fetch entityName
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        do{
            // Fetch request
            let fetchResults = try managedObjectContext!.fetch(fetch) as! [Settings]
            if fetchResults.count == 0 {
                settings = NSEntityDescription.insertNewObject(forEntityName: "Settings", into: managedObjectContext!) as! Settings
            }else{
                settings = fetchResults[0]
            }
        }catch{
            fatalError("Failed to fetch Settings information: \(error)")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Two section in this tableView
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // first section: monitor control
        if section == 0{
            return 2
        }else if section == 1 {
            // second section: sub controls: baby cry, diaper wet,
            return 4
        }else if section == 2{
            // third section: sub control: temperature
            return 1
        }else if section == 3{
            // fourth section: choose picture from ablum
            return 2
        }else{
            return 1
        }
    }
    
    // All sub monitors are controlled by the top monitor
    func turnOffSubControls(_ toggle: UISwitch){
        if toggle.isOn {
            settings?.monitor = true
            //            cryCell.switchOnOff.enabled = true
            //            diaperCell.switchOnOff.enabled = true
            //            quiltCell.switchOnOff.enabled = true
            //            monitorTimeCell.timePeriod.enabled = true
            //            volumeCell.volumeSlider.enabled = true
            //            outOfSightCell.switchOnOff.enabled = true
        }else{
            settings?.monitor = false
            //            cryCell.switchOnOff.enabled = false
            //            diaperCell.switchOnOff.enabled = false
            //            quiltCell.switchOnOff.enabled = false
            //            monitorTimeCell.timePeriod.enabled = false
            //            volumeCell.volumeSlider.enabled = false
            //            outOfSightCell.switchOnOff.enabled = false
        }
        
        // Initialise status of switches
        initSwitchState(toggle)
        
        // Set activity state to history state
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setHistoryActivity"), object: nil)
        // Reset settings
        NotificationCenter.default.post(name: Notification.Name(rawValue: "resetSettingsId"), object: settings)
        // Add START/END activity log
        NotificationCenter.default.post(name: Notification.Name(rawValue: "addActivityStartOrEndId"), object: toggle)
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
    }
    
    // Save status of cry notification to core data entity
    func turnOffCryNotification(_ toggle: UISwitch){
        if toggle.isOn {
            settings.babyCryOn = true
            settings.diaperWetOn = true
            settings.sightOn = true
            volumeCell.volumeSlider.isEnabled = true
            diaperCell.switchOnOff.isEnabled = true
            diaperCell.switchOnOff.isOn = true
            outOfSightCell.switchOnOff.isEnabled = true
            outOfSightCell.switchOnOff.isOn = true
        }else{
            settings.babyCryOn = false
            settings.diaperWetOn = false
            settings.sightOn = false
            volumeCell.volumeSlider.isEnabled = false
            diaperCell.switchOnOff.isEnabled = false
            diaperCell.switchOnOff.isOn = false
            outOfSightCell.switchOnOff.isEnabled = false
            outOfSightCell.switchOnOff.isOn = false
        }
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save contect: \(error)")
        }
    }
    
    // Save status of diaper wet to core data entity
    func turnOffDiaperNotification(_ toggle: UISwitch){
        if toggle.isOn {
            settings.diaperWetOn = true
        }else{
            settings.diaperWetOn = false
        }
    }
    
    // Save status of kick off quilt to core data entity
    func turnOffQuiltNotification(_ toggle: UISwitch){
        if toggle.isOn {
            settings.tempAnomaly = true
        }else{
            settings.tempAnomaly = false
        }
    }
    
    // Save time period to core data entity
    func changeTimePeriod(){
        switch  monitorTimeCell.timePeriod.selectedSegmentIndex {
        case 0:
            settings.timePeriod = realTime as NSNumber?
            break
        case 1:
            settings.timePeriod = fiveMin as NSNumber?
            break
        default:
            settings.timePeriod = fifteenMin as NSNumber?
            break
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "resetSettingsId"), object: settings)
    }
    
    // User can change the sensetivity of baby cry notification
    // If the sensitivity is high, parents will get notified at a low volume when baby cry
    // If the sensitivity is low, parents will only get notified when baby cry severe
    func changeVolume(){
        let volume = 2200 - volumeCell.volumeSlider.value * 50
        let str = NSString(format: "%.f", volumeCell.volumeSlider.value)
        volumeCell.textLabel?.text = "Sensitive level  \(str)"
        settings.babyCryVolume = volume as NSNumber?
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save contect: \(error)")
        }
        
    }
    
    // Reset home page's image
    func resetHomeImge(){
        let homeController = self.tabBarController?.viewControllers![0].childViewControllers[0] as! ViewController
        homeController.babyPhone.image = UIImage(named: "baby_smile")
        let imageData = UIImageJPEGRepresentation(homeController.babyPhone.image!, 1)
        settings.homePagePhoto = imageData
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save contect: \(error)")
        }
        showAlertWithDismiss("Done", message: "Reset successfully")
    }
    
    // Save status of out of sight to core data entity
    func turnOffOutSightNotification(_ toggle: UISwitch){
        if toggle.isOn {
            settings.sightOn = true
        }else{
            settings.sightOn = false
        }
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save contect: \(error)")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row{
            case 0:
                let settingCell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingCell
                // Configure the cell
                settingCell.textLabel?.text = "Monitor"
                settingCell.switchOnOff.isOn = Bool(settings.monitor!)
                // set none select style
                settingCell.selectionStyle = UITableViewCellSelectionStyle.none
                settingCell.contentView.bringSubview(toFront: settingCell.switchOnOff)
                return settingCell
            default:
                let monitorTimeCell = tableView.dequeueReusableCell(withIdentifier: "monitorTimeCell", for: indexPath) as! SettingTimePeriodCell
                monitorTimeCell.textLabel?.text = "Monitor interval"
                monitorTimeCell.selectionStyle = UITableViewCellSelectionStyle.none
                monitorTimeCell.contentView.bringSubview(toFront: monitorTimeCell.timePeriod)
                monitorTimeCell.timePeriod.selectedSegmentIndex = getIndexForTimePeriod()
                return monitorTimeCell
            }
        }else if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                let settingCell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingCell
                // set none select style
                settingCell.selectionStyle = UITableViewCellSelectionStyle.none
                settingCell.contentView.bringSubview(toFront: settingCell.switchOnOff)
                settingCell.textLabel?.text = "Baby cry"
                settingCell.switchOnOff.isOn = Bool(settings.babyCryOn!)
                return settingCell
            case 1:
                let volumeCell = tableView.dequeueReusableCell(withIdentifier: "volumeCell", for: indexPath) as! SettingVolumeCell
                volumeCell.textLabel!.text = "Sensitive level"
                volumeCell.selectionStyle = UITableViewCellSelectionStyle.none
                volumeCell.volumeSlider.value = (2200 - Float(settings.babyCryVolume!) ) / 50
                volumeCell.contentView.bringSubview(toFront: volumeCell.volumeSlider)
                return volumeCell
            case 2:
                let settingCell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingCell
                // set none select style
                settingCell.selectionStyle = UITableViewCellSelectionStyle.none
                settingCell.contentView.bringSubview(toFront: settingCell.switchOnOff)
                
                settingCell.textLabel?.text = "Out of sight"
                settingCell.switchOnOff.isOn = Bool(settings.sightOn!)
                return settingCell
            default:
                let settingCell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingCell
                // set none select style
                settingCell.selectionStyle = UITableViewCellSelectionStyle.none
                settingCell.contentView.bringSubview(toFront: settingCell.switchOnOff)
                
                settingCell.textLabel?.text = "Diaper wet"
                settingCell.switchOnOff.isOn = Bool(settings.diaperWetOn!)
                return settingCell
                
            }
        }else if indexPath.section == 2 {
            let settingCell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingCell
            // set none select style
            settingCell.selectionStyle = UITableViewCellSelectionStyle.none
            settingCell.contentView.bringSubview(toFront: settingCell.switchOnOff)
            
            settingCell.textLabel?.text = "Temperature anomaly"
            settingCell.switchOnOff.isOn = Bool(settings.tempAnomaly!)
            return settingCell
            
        }
            
        else if indexPath.section == 3{
            switch indexPath.row{
            case 0:
                let choosePhotoCell = tableView.dequeueReusableCell(withIdentifier: "choosePhotoCell", for: indexPath) as UITableViewCell
                choosePhotoCell.textLabel?.text = "Choose from Photos"
                return choosePhotoCell
            default:
                let defaultImgCell = tableView.dequeueReusableCell(withIdentifier: "defaultImgCell", for: indexPath) as! SettingDefaultImgCell
                defaultImgCell.textLabel?.text = "Use default home page"
                // set none select style
                defaultImgCell.selectionStyle = UITableViewCellSelectionStyle.none
                defaultImgCell.contentView.bringSubview(toFront: defaultImgCell.resetHomeImg)
                return defaultImgCell
                
            }
        }else{
            let babyNameCell = tableView.dequeueReusableCell(withIdentifier: "babyNameCell", for: indexPath) as! SettingNameCell
            
            babyNameCell.textLabel?.text = "Baby's name"
            babyNameCell.babyNameLabel.text = settings.babyName
            babyNameCell.contentView.bringSubview(toFront: babyNameCell.babyNameLabel)
            //            babyNameCell.textLabel.text = "Bab"
            return babyNameCell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If the user click to select a photo
        if indexPath.section == 3 && indexPath.row == 0{
            // Reference: www.youtube.com/watch?v=leyk3QOYJF0
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .photoLibrary
            self.present(photoPicker, animated: true, completion: nil)
        }
    }
    
    // execute after picking a picutre
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let imageData = UIImageJPEGRepresentation((info[UIImagePickerControllerOriginalImage] as? UIImage)!, 1)
        settings.homePagePhoto = imageData
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save contect: \(error)")
        }
        
        //let homeController = self.tabBarController?.viewControllers![0].childViewControllers[0] as! HomeController
        //homeController.babyPhone.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !monitorCell.switchOnOff.isOn {
            volumeCell.volumeSlider.isEnabled = false
        }
        // reload data
        self.tableView.reloadData()
    }
    
    func getIndexForTimePeriod() -> Int{
        let timeSetting = Int(settings.timePeriod!)
        switch timeSetting{
        // Real time
        case realTime:return 0
        // 5 miniutes
        case fiveMin: return 1
        // 15 miniutes
        default: return 2
        }
    }
    
    // Delegate
    func setBabyName(_ name: String) {
        settings.babyName = name
        do{
            try managedObjectContext.save()
        }catch{
            fatalError("Failure to save contect: \(error)")
        }
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "babyNameSeg" {
            let controller = segue.destination as! BabyNameController
            controller.setBabyNameDelegate = self
            controller.name = settings.babyName
        }
    }

}
