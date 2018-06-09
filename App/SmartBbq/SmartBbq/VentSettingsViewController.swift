//
//  VentSettingsViewController.swift
//  SmartBbq
//
//  Created by Vigram Mohan on 09/06/2018.
//  Copyright © 2018 Vigram. All rights reserved.
//

import UIKit
import Charts

class VentSettingsViewController: UIViewController {

    
    @IBOutlet weak var ventTopLeft: PieChartView!
    @IBOutlet weak var ventTopRight: PieChartView!
    @IBOutlet weak var ventBottomLeft: PieChartView!
    @IBOutlet weak var ventBottomRight: PieChartView!
    
    
    var ventTopLeftData = PieChartDataEntry(value: 0)
    var ventTopRightData = PieChartDataEntry(value: 0)
    var ventBottomLeftData = PieChartDataEntry(value: 0)
    var ventBottomRightData = PieChartDataEntry(value: 0)
    
    var ventTopLeftData2 = PieChartDataEntry(value: 0)
    var ventTopRightData2 = PieChartDataEntry(value: 0)
    var ventBottomLeftData2 = PieChartDataEntry(value: 0)
    var ventBottomRightData2 = PieChartDataEntry(value: 0)
    
    
    
    @IBOutlet weak var stepperTL: UIStepper!
    @IBOutlet weak var stepperTR: UIStepper!
    @IBOutlet weak var stepperBL: UIStepper!
    @IBOutlet weak var stepperBR: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCharts()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    func setUpCharts()
    {
        //        self.ventTopLeftData.value=self.stepperTL.value;
        self.ventTopLeft.legend.enabled = false
        self.ventTopRight.legend.enabled = false
        self.ventBottomLeft.legend.enabled = false
        self.ventBottomRight.legend.enabled = false
        
        self.ventTopLeft.drawSlicesUnderHoleEnabled = false
        

        
      
        
        
        
    }
    
    
    func updateChartData(vent: PieChartView, chartDataSet: PieChartDataSet)
    {
       
        
        let chartDataObj = PieChartData(dataSet: chartDataSet)
        
        let colors=[ UIColor .white, UIColor .blue]
        
        
        
        chartDataSet.colors = colors
        
        vent.data = chartDataObj
        
        
    }
    @IBAction func stepperTL(_ sender: UIStepper) {
        self.ventTopLeftData.value = sender.value
        self.ventTopLeftData2.value=100.00-sender.value;
         let chartDataSet = PieChartDataSet(values: [self.ventTopLeftData, self.ventTopLeftData2], label: nil)
        updateChartData(vent: self.ventTopLeft, chartDataSet: chartDataSet)
    }
    @IBAction func stepperTR(_ sender: UIStepper) {
        self.ventTopRightData.value = sender.value
        self.ventTopRightData2.value=100.00-sender.value;
         let chartDataSet = PieChartDataSet(values: [self.ventTopRightData, self.ventTopRightData2], label: nil)
       updateChartData(vent: self.ventTopRight, chartDataSet: chartDataSet)
    }
    @IBAction func stepperBL(_ sender: UIStepper) {
        self.ventBottomLeftData.value = sender.value
        self.ventBottomLeftData2.value=100.00-sender.value;
         let chartDataSet = PieChartDataSet(values: [self.ventBottomLeftData, self.ventBottomLeftData2], label: nil)
       updateChartData(vent: self.ventBottomLeft, chartDataSet: chartDataSet)
    }
    
    @IBAction func stepperBR(_ sender: UIStepper) {
        self.ventBottomRightData.value = sender.value
        self.ventBottomRightData2.value=100.00-sender.value;
         let chartDataSet = PieChartDataSet(values: [self.ventBottomRightData, self.ventBottomRightData2], label: nil)
        updateChartData(vent: self.ventBottomRight, chartDataSet: chartDataSet)
    }

}
