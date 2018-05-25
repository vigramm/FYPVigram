//
//  ViewController.swift
//  SmartBbq
//
//  Created by Vigram Mohan on 28/11/2017.
//  Copyright © 2017 Vigram. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Charts


class GraphViewController: UIViewController {

    var ref: DatabaseReference?
    
    var firebaseData = [Double]()
    
    var experimentNumber: Int!
    
    var counter: Int = 0
    
    @IBOutlet weak var graphChart: LineChartView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //getExperimentNumber()

        

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ref = Database.database().reference()
        getDataFirebase()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // IBAction connected to the "LED1 ON" button
    @IBAction func led1_Button(_ sender: Any)
    {
        getDataFirebase()

    }
    @IBAction func led2_Button(_ sender: Any)
    {
        updateGraph()
        
    }
    
    
 
    @IBAction func ENDButtonClick(_ sender: Any)
    {
        self.ref?.updateChildValues(["Mode":"End"])
        self.navigationController?.popViewController(animated: true)
    }
    
    func getDataFirebase(){

        print(self.experimentNumber!)
        let experimentName="experiment\(self.experimentNumber!)"
        print(experimentName)
        print("\(self.counter)")
        
       
        
        var totalValues: Int = 0
        
        self.ref?.child("experiment\(self.experimentNumber!)").child("totalExperimentValues").observeSingleEvent(of: .value, with: { snapshot in
            
            if let data = snapshot.value as? Int
            {
                totalValues = data
                self.getAllValues(totalValues: totalValues)
            }
            else
            {
                print("not working")
            }
        }){ (error) in
            print(error.localizedDescription)
        }
        print("totalValues\(totalValues)")

        
        
    }
    
    func getAllValues(totalValues: Int)
    {
        for i in 0...totalValues
        {
            
            self.ref?.child("experiment\(self.experimentNumber!)").child("\(i)").child("Value").observeSingleEvent(of: .value, with: { snapshot in
                
                if let data = snapshot.value as? Double
                {
                    self.firebaseData.append(data)
                    self.updateGraph()
                    print(data)
                }
                else
                {
                    print("not working")
                }
            }){ (error) in
                print(error.localizedDescription)
            }
        }
    }
    

    
    

    func updateGraph(){
    
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<self.firebaseData.count{
            let entry = ChartDataEntry(x: Double(i), y: self.firebaseData[i])
            lineChartEntry.append(entry)

        }
  
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number")
        
        line1.colors = [NSUIColor.blue]
        
        let data = LineChartData()
        
        data.addDataSet(line1)
        
        graphChart.data = data
        graphChart.chartDescription?.text = "Smart Barbeque"
        
        
    }
    



}

