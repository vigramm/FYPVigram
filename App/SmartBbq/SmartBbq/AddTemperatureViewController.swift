//
//  AddTemperatureViewController.swift
//  SmartBbq
//
//  Created by Vigram Mohan on 07/06/2018.
//  Copyright © 2018 Vigram. All rights reserved.
//

import UIKit
import Firebase

class AddTemperatureViewController: UIViewController {

    var ref: DatabaseReference?
    
    var experimentNumber: Int = 0
    var counterNumber: Int = 0
    
    @IBOutlet weak var outsideTemperature: UITextField!
    
    
    @IBOutlet weak var insideTemperature: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getExperimentNumber()
        self.getCounterNumber()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func SendReadingsButtonOnClick(_ sender: Any)
    {
        self.getCounterNumber()

        
    }
    
    
    func getExperimentNumber()
    {
        ref = Database.database().reference()
        self.ref?.child("TotalExperiments").observe(.value, with: { snapshot in
            if let data = snapshot.value as? Int
            {
                self.experimentNumber=data
                print("Experiment")
                print(data)
                
                
            }
            else
            {
                
            }
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    func getCounterNumber(){
        
        self.ref?.child("experiment\(self.experimentNumber)").child("totalExperimentValues").observeSingleEvent(of: .value, with: { snapshot in
            if let data = snapshot.value as? Int
            {
                self.counterNumber=data
                self.setDataOnFirebase()
                print("Counter")
                print(data)

            }
            else
            {
                
            }
        }){ (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func setDataOnFirebase()
    {
        let outsideTemp = Double(self.outsideTemperature.text!)
        let insideTemp = Double(self.insideTemperature.text!)
        self.ref?.child("experiment\(self.experimentNumber)").child("\(self.counterNumber)").child("InsideTemp").setValue(insideTemp)
        self.ref?.child("experiment\(self.experimentNumber)").child("\(self.counterNumber)").child("OutsideTemp").setValue(outsideTemp)
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
