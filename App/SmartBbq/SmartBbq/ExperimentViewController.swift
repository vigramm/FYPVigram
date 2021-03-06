//
//  BatteryViewController.swift
//  SmartBbq
//
//  Created by Vigram Mohan on 19/04/2018.
//  Copyright © 2018 Vigram. All rights reserved.
//

import UIKit
import Firebase



class ExperimentViewController: UIViewController {
    

    
    
    var experimentNumber: Int = 0
    
    var ref: DatabaseReference?

//    var batteryPercent:Float = 0 {
//        didSet {
//            let fractionalProgress = batteryPercent / 100.0
//            let animated = batteryPercent != 0
//            print("123")
//            batteryView.setProgress(fractionalProgress, animated: animated)
//            batteryLabel.text = ("\(batteryPercent)%")
//        }
//    }
//
      override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.title="Control Panel"
        
        self.totalExperiments()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
 
    
    
    
    
    
//    func getBatteryInfo(){
//
//    self.ref?.child("batteryPercent").observe(.value, with: { snapshot in
//
//            if let data = snapshot.value as? Float
//            {
//                self.batteryPercent=data;
//
//                print(self.batteryPercent)
//            }
//            else
//            {
//
//            }
//        }){ (error) in
//            print(error.localizedDescription)
//        }
//
//
//    }
    
    
//    @IBAction func BatteryStatusButtonClick(_ sender: Any) {
//        getBatteryInfo()
//
//    }

    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }// This works fine
    
    
   
    @IBAction func takePictureButton_onClick(_ sender: Any) {
        
        performSegue(withIdentifier: "showCamera_Segue", sender: self)
    }
    
    
    
    
    @IBAction func viewGraphClick(_ sender: Any)
    {
        performSegue(withIdentifier: "viewGraph_Segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewGraph_Segue" {
         
                let controller = segue.destination as! GraphViewController
            controller.experimentNumber = self.experimentNumber
            
        }
        print("123")
    }
    
    @IBAction func AddNotesButtonClick(_ sender: Any)
    {
        performSegue(withIdentifier: "addNotes_Segue", sender: self)
    }
    
    
    
    
    @IBAction func AddTemperatureButtonOnClick(_ sender: Any)
    {
        performSegue(withIdentifier: "AddTemperatureVC_segue", sender: self)
    }
    
    
    
    @IBAction func VentSettingsButtonOnClick(_ sender: Any) {
        performSegue(withIdentifier: "ventSettings_segue", sender: self)
    }
    
    
    
    func totalExperiments()
    {
        ref = Database.database().reference()
        self.ref?.child("TotalExperiments").observeSingleEvent(of : .value, with: { snapshot in
            if let data = snapshot.value as? Int
            {
                self.experimentNumber=data
            }
            else
            {
                
            }
        }){ (error) in
            print(error.localizedDescription)
        }
        
        
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
