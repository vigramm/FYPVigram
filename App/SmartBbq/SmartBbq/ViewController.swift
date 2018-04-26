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


class ViewController: UIViewController {

    var ref: DatabaseReference?
    
    var counter: Int = 0
    
    var totalDataPoints: Int = 0
 
    var firebaseData = [Double]()
    
    var experimentNumber: Int = 0
    
    @IBOutlet weak var graphChart: LineChartView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.ref?.child("experiment1").child("information").child("totalDataPoints").observe(.value, with: { snapshot in
            
            if let data = snapshot.value as? Int
            {
                
                self.totalDataPoints=data
                print(data)
            }
            else
            {
                
            }
        }){ (error) in
            print(error.localizedDescription)
        }
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
    }
    
    func getDataFirebase(){
        
        let counterString=String(self.counter);
        self.ref?.child("experiment1").child(counterString).observe(.value, with: { snapshot in
            
            if let data = snapshot.value as? Double
            {
            self.firebaseData.append(data)
            print(data)
            }
            else
            {
                
            }
        }){ (error) in
                    print(error.localizedDescription)
        }
        

        self.counter=self.counter+1;
    }
    
    
    

    func updateGraph(){
    
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<self.firebaseData.count{
            let entry = ChartDataEntry(x: Double(i), y: self.firebaseData[i])
            lineChartEntry.append(entry)

        }
        
        // This works fine
//        for i in 0..<20 {
//            let value = ChartDataEntry(x: Double(i), y: Double(i))
//            lineChartEntry.append(value)
//        }
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number")
        
        line1.colors = [NSUIColor.blue]
        
        let data = LineChartData()
        
        data.addDataSet(line1)
        
        graphChart.data = data
        
        graphChart.chartDescription?.text = "Smart Barbeque"
        
        
    }
    
    

    


}

