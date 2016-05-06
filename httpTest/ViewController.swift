//
//  ViewController.swift
//  httpTest
//
//  Created by Dominik on 4/4/15.
//  Copyright (c) 2015 Dominik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet  var tempDisplay: UILabel!
    
    @IBOutlet var windSpeed: UILabel!
    
    @IBOutlet var lastUpdated: UILabel!
    
    @IBOutlet var slide: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        // Do any additional setup after loading the view, typically from a nib.
        getWeather(0)
        
    }
    

    

    @IBAction func get24Weather(sender: UIButton) {
        getWeather(144)
        slide.value = 48
    }

    
    @IBAction func refresh(sender: UIButton) {
        getWeather(0)
        slide.value = 0
    }
  
    
    @IBAction func slider(sender: UISlider) {
        let i = Int(sender.value)
        
        print("Slider valude = \(i)")
        getWeather(i*3)
        
    }
    
    func getWeather(offset : Int) {
        
        let myURL = NSURL(string: "http://bigpi.info:500/weatherJson.php")
        let request = NSMutableURLRequest(URL: myURL!)
        request.HTTPMethod = "POST"
        
        // Compose a query string
        let postString = "offset=" + String(offset);
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
    
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
    
            if let urlConent = data {
                do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlConent, options: NSJSONReadingOptions.MutableContainers)
 
                    let date = jsonResult["date"] as! String
                    let outTemp = jsonResult["outTemp"]as! Double
                    let windGust = jsonResult["windGust"] as! Double
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tempDisplay.text = (NSString(format: "%.1f", outTemp) as String) + " º"
                        self.windSpeed.text = (NSString(format: "%.0f", windGust) as String) + " mph"
                        self.lastUpdated.text = date
                    })

                } catch {
                    print("Error reading JSON")
                } //do
            } //let
        }//task

        task.resume()
        
    }

}

