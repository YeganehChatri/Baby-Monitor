//
//  LiveStreamingController.swift
//  babyMonitor
//
//  Created by yeganeh on 5/22/17.
//  Copyright © 2017 yeganeh. All rights reserved.
//

import UIKit
import CoreData

class LiveStreamingController: UIViewController , UIWebViewDelegate {

    @IBOutlet weak var babyWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        babyWebView.delegate = self
        // Configure webView
        babyWebView.scrollView.isScrollEnabled = false
        babyWebView.scrollView.bounces = false
        babyWebView.isOpaque = true
        babyWebView.backgroundColor = UIColor.clear
        // Webpage file location in server: /var/www/html/
        let videoUrl = Constants.cameraUrl
        babyWebView.allowsInlineMediaPlayback = true
        babyWebView.loadHTMLString(
            "<iframe width=\"\(self.babyWebView.frame.width)\" height=\"\(self.babyWebView.frame.height)\" src=\"\(videoUrl)?playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // stackoverflow.com/questions/3936041/how-to-determine-the-content-size-of-a-uiwebview
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(CGSize.zero)
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
