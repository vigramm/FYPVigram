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
    
    var totalDataPoints: Int = 20
 
    var firebaseData = [Double]()
    
    @IBOutlet weak var graphChart: LineChartView!
    
    @IBOutlet weak var username_Textfield: UITextField!
    
    
    @IBOutlet weak var password_TextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        

        
        // Do any additional setup after loading the view, typically from a nib.
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
    
    func getDataFirebase(){
        
        let counterString=String(self.counter);
//        self.ref?.child("Experiment1").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            self.firebaseData.append((snapshot.value as? Double)!)
//
//            for i in 0..<self.firebaseData.count
//            {
//                print(self.firebaseData[i])
//            }
//          self.counter=self.counter+1;
//        }) { (error) in
//            print(error.localizedDescription)
//        }
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
        self.ref?.child("experiment1").child("information").child("totalDataPoints").observe(.value, with: { snapshot in

            if let data = snapshot.value as? Double
            {
                

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
    
    
    
    @IBAction func getExperimentDetails(_ sender: Any)
    {
        while(self.counter<self.totalDataPoints)
        {
            getDataFirebase()
            
        }
        updateGraph()
//        let username: String=self.username_Textfield.text!
//        let password: String=self.password_TextField.text!
//        NSLog("%@",username )
//        NSLog("%@",password )
//        self.ref?.child("experiment1").child("information").child("credentials").setValue([username: password])
    }
    
    
    @IBOutlet weak var LedButton1: UIButton!
    
    @IBOutlet weak var LedButton2: UIButton!
    

}

