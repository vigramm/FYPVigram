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
    var counter: Int = 0
    
    var mode: String=""
    
    
    @IBOutlet weak var ViewCurrentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      

        self.getExperimentNumber()

        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        //elf.ViewCurrentButton.isHidden=true
        self.getMode()
        
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

//        let stringExprimentNumberCopy: String = "experiment10"
//        let stringExprimentNumberPaste: String = "experiment4"
//
//
//
//        var totalValues: Int = 0
//        ref = Database.database().reference()
//        self.ref?.child(stringExprimentNumberCopy).child("totalExperimentValues").observeSingleEvent(of: .value, with: { snapshot in
//            if let data = snapshot.value as? Int
//            {
//                totalValues = data
//
//                print(totalValues)
//
//                for i in 0...totalValues
//                {
//
//                    self.ref?.child(stringExprimentNumberCopy).child("\(i)").child("Value").observeSingleEvent(of: .value, with: { snapshot in
//                        if let data = snapshot.value as? Double
//                        {
//                            self.ref?.child(stringExprimentNumberPaste).child("\(i)").child("Value").setValue(data)
//
//
//                        }
//                        else{
//                            print("not working")
//                        }
//
//                    }){ (error) in
//                        print(error.localizedDescription)
//                    }
//                    self.ref?.child(stringExprimentNumberCopy).child("\(i)").child("ImageURL").observeSingleEvent(of: .value, with: { snapshot in
//                        if let data = snapshot.value as? String
//                        {
//                            self.ref?.child(stringExprimentNumberPaste).child("\(i)").child("ImageURL").setValue(data)
//
//
//                        }
//                        else{
//                            print("not working")
//                        }
//
//                    }){ (error) in
//                        print(error.localizedDescription)
//                    }
//                    self.ref?.child(stringExprimentNumberCopy).child("\(i)").child("Notes").observeSingleEvent(of: .value, with: { snapshot in
//                        if let data = snapshot.value as? String
//                        {
//                            self.ref?.child(stringExprimentNumberPaste).child("\(i)").child("Notes").setValue(data)
//
//
//                        }
//                        else{
//                            print("not working")
//                        }
//
//                    }){ (error) in
//                        print(error.localizedDescription)
//                    }
//                    self.ref?.child(stringExprimentNumberCopy).child("\(i)").child("Time").observeSingleEvent(of: .value, with: { snapshot in
//                        if let data = snapshot.value as? String
//                        {
//                            self.ref?.child(stringExprimentNumberPaste).child("\(i)").child("Time").setValue(data)
//                            print(i+86);
//
//
//                        }
//                        else{
//                            print("not working")
//                        }
//
//                    }){ (error) in
//                        print(error.localizedDescription)
//                    }
//
//                }
//
//            }
//            else
//            {
//                print("not working")
//            }
//        }){ (error) in
//            print(error.localizedDescription)
//        }
//
//

    }
    
    
    @IBAction func ViewCurrentExperimentClick(_ sender: Any) {
    }
    
    
    
    @IBAction func ViewPreviousExperimentsClick(_ sender: Any) {
        
       
        let previousExperimentsVC = PreviousExperimentsViewController()
        
        previousExperimentsVC.experimentNumber=self.experimentNumber
        performSegue(withIdentifier: "previousExperiments_Segue", sender: self)
    }
    
    
    func getExperimentNumber()
    {
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
        print("experimentcheck\(self.experimentNumber)")

    }
    
    func getMode(){
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
    }
    
    
}
