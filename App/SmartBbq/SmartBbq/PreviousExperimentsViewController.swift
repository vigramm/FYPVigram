//
//  PreviousExperimentsViewController.swift
//  SmartBbq
//
//  Created by Vigram Mohan on 24/05/2018.
//  Copyright © 2018 Vigram. All rights reserved.
//

import UIKit
import Firebase

class PreviousExperimentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var ref: DatabaseReference?
    
    var experimentNumber: Int = 0
    
    var experimentList: Array<String> = Array()


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.totalExperiments()
    
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(self.experimentList.count)//number of rows in list
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell =  UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.experimentList[indexPath.row]
        return(cell)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        
        let graphVC = GraphViewController()
        graphVC.experimentNumber = indexPath!.row
        
        print("1234")
        print(indexPath!.row as Any)
        
        performSegue(withIdentifier: "ViewExperimentGraph_Segue", sender: self)
        

        //getting the text of that cell
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewExperimentGraph_Segue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! GraphViewController
                controller.experimentNumber = indexPath.row
            }
        }
        print("123")
    }
    
    func totalExperiments()
    {
        ref = Database.database().reference()
        self.ref?.child("TotalExperiments").observeSingleEvent(of : .value, with: { snapshot in
            if let data = snapshot.value as? Int
            {
                self.experimentNumber=data
                self.populateCells()
                self.tableView.reloadData()
            }
            else
            {
                
            }
        }){ (error) in
            print(error.localizedDescription)
        }
     
        
    }
    
    func populateCells()
    {
        print(self.experimentNumber)
        for i in 0...self.experimentNumber
        {
            print("Experiment \(i)")
            self.experimentList.append("Experiment \(i)")
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
