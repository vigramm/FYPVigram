//
//  NotesViewController.swift
//  SmartBbq
//
//  Created by Vigram Mohan on 21/05/2018.
//  Copyright © 2018 Vigram. All rights reserved.
//

import UIKit
import Firebase


class NotesViewController: UIViewController {

    var ref: DatabaseReference?
    
    
    var experimentNumber: Int = 0
    var counterNumber: Int = 0
    @IBOutlet weak var notesTextView: UITextView!
    
    
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
    

    @IBAction func addNotesButton_onClick(_ sender: Any)
    {
        self.getCounterNumber()
        let notes=self.notesTextView.text
        self.ref?.child("experiment\(self.experimentNumber)").child("\(self.counterNumber)").child("Notes").setValue(notes)
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
        
        ref = Database.database().reference()
        self.ref?.child("CurrentExperimentCounter").observe(.value, with: { snapshot in
            if let data = snapshot.value as? Int
            {
                self.counterNumber=data
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

}
