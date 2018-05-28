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
    
    var firebaseDataNotes = [String]()
    
    var experimentNumber: Int!
    
    var counter: Int = 0
    
    @IBOutlet weak var graphChart: LineChartView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //getExperimentNumber()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(BackButtonOnClick))
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ref = Database.database().reference()
        totalExperimentNumber()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    
    
    
 
   @objc func BackButtonOnClick(_ sender: Any)
    {
//        self.ref?.updateChildValues(["Mode":"End"])
        self.navigationController?.popViewController(animated: true)
    }
    
    func totalExperimentNumber(){

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
  
        let chartDataSet = LineChartDataSet(values: lineChartEntry, label: "Temperature")
        
        
        
        let data = LineChartData()
        
    
        let gradientColor=[UIColor.orange.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColor, locations:colorLocations) else { print("gradient error"); return}
        
        
        
        data.addDataSet(chartDataSet)
        data.setDrawValues(false)
        
        
        chartDataSet.colors = [NSUIColor.orange]
        chartDataSet.circleRadius = 2.0
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        chartDataSet.drawFilledEnabled = true;
       
        graphChart.xAxis.labelPosition = .bottom
        graphChart.xAxis.drawGridLinesEnabled = false
        graphChart.legend.enabled = true
        
        //Balloon Marker that appears on hovering
        let marker: BalloonMarker = BalloonMarker(color: UIColor.lightGray, font: UIFont(name: "Helvetica", size: 12)!, textColor: UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 7.0))
        
        marker.minimumSize = CGSize(width: 50.0, height: 50.0)
        graphChart.marker = marker
     
        graphChart.data = data
        graphChart.chartDescription?.text = "Smart Barbeque"
        
        
    }
    



}

