//
//  BabyNameController.swift
//  babyMonitor
//
//  Created by yeganeh on 5/25/17.
//  Copyright © 2017 yeganeh. All rights reserved.
//

import UIKit

protocol  SetBabyNameDelegate {
    func setBabyName(_ name:String)
}

class BabyNameController: UIViewController {
    
    var setBabyNameDelegate : SetBabyNameDelegate?

    @IBOutlet weak var babyNameText: UITextField!
    var name:String!
    
    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //        babyNameText = UITextField()
    //    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        babyNameText.text = name
    }

    @IBAction func setBabyName(_ sender: Any) {
        setBabyNameDelegate!.setBabyName(babyNameText.text!)
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
