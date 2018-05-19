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
    
    
    @IBOutlet weak var batteryView: UIProgressView!
    
    @IBOutlet weak var batteryLabel: UILabel!
    
    var ref: DatabaseReference?

    var batteryPercent:Float = 0 {
        didSet {
            let fractionalProgress = batteryPercent / 100.0
            let animated = batteryPercent != 0
            
            batteryView.setProgress(fractionalProgress, animated: animated)
            batteryLabel.text = ("\(batteryPercent)%")
        }
    }
    
      override func viewDidLoad() {
        super.viewDidLoad()
         ref = Database.database().reference()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func getDataFirebase(){

    self.ref?.child("experiment1").child("information").child("batteryPercent").observe(.value, with: { snapshot in
            
            if let data = snapshot.value as? Float
            {
                self.batteryPercent=data;
                
                print(data)
            }
            else
            {
                
            }
        }){ (error) in
            print(error.localizedDescription)
        }
            
    
    }
    
    
    @IBAction func BatteryStatusButtonClick(_ sender: Any) {
        getDataFirebase()
    }

    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }// This works fine
    
    
   
    @IBAction func takePictureButton_onClick(_ sender: Any) {
        
        performSegue(withIdentifier: "showCamera_Segue", sender: nil)
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
