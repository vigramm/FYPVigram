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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButtonClick(_ sender: Any)
    {
    
        self.ref?.child("TotalExperiments").observe(.value, with: { snapshot in

            if let data = snapshot.value as? Int
            {
                self.experimentNumber=data+1
                print(data)
                
            }
            else
            {

            }
        }){ (error) in
            print(error.localizedDescription)
        }
    self.ref?.updateChildValues(["TotalExperiments":self.experimentNumber])
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
