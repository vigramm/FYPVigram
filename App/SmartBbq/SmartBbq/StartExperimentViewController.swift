//
//  StartExperimentViewController.swift
//  SmartBbq
//
//  Created by Vigram Mohan on 26/04/2018.
//  Copyright © 2018 Vigram. All rights reserved.
//

import UIKit
import Firebase

class StartExperimentViewController: UIViewController {

    var ref: DatabaseReference?
    var experimentNumber: Int = 0
    
    var mode: String=""
    
    
    @IBOutlet weak var ViewCurrentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        ref = Database.database().reference()
        self.ref?.child("TotalExperiments").observe(.value, with: { snapshot in
            if let data = snapshot.value as? Int
            {
                self.experimentNumber=data
                print(data)
                print(self.experimentNumber)
                
            }
            else
            {
                
            }
        }){ (error) in
            print(error.localizedDescription)
        }


        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.ViewCurrentButton.isHidden=true
        self.ref?.child("Mode").observe(.value, with: { snapshot in
            if let data = snapshot.value as? String
            {
                self.mode=data
                print(data)
                print(self.experimentNumber)
                
            }
            else
            {
                
            }
        }){ (error) in
            print(error.localizedDescription)
        }
        
        if(self.mode == "Start")
        {
            self.ViewCurrentButton.isHidden=false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButtonClick(_ sender: Any)
    {
    self.ref?.updateChildValues(["TotalExperiments":self.experimentNumber+1])
        self.ref?.updateChildValues(["Mode":"Start"])
    }
    
    
    @IBAction func ViewCurrentExperimentClick(_ sender: Any) {
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
