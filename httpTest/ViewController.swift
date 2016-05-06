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
    
        
        let url2 = "http://bigpi.info:500/weatherJson.php"
        
        let myUrl = NSURL(string: url2);
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        // Compose a query string
        let postString = "offset=" + String(offset);
      
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
  
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")
            
            // Print out response body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            //Let's convert response sent from a server side script to a NSDictionary object:
            self.tempDisplay.text = "0"
            

            
            var error: NSError? = nil;
            var jsonObject: AnyObject?
            do {
                jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
            } catch var error1 as NSError {
                error = error1
                jsonObject = nil
            } catch {
                fatalError()
            }
            
            var date = (jsonObject as! NSDictionary)["date"] as! String
            var outTemp = (jsonObject as! NSDictionary)["outTemp"]as! Double
            var windGust = (jsonObject as! NSDictionary)["windGust"] as! Double
            print("date: \(date)")
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tempDisplay.text = (NSString(format: "%.1f", outTemp) as String) + " º"
                self.windSpeed.text = (NSString(format: "%.0f", windGust) as String) + " mph"
                self.lastUpdated.text = date
            })
            
        }
        
        task.resume()

    }
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

