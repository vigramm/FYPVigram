//
//  ImageViewController.swift
//  SmartBbq
//
//  Created by Vigram Mohan on 18/05/2018.
//  Copyright © 2018 Vigram. All rights reserved.
//

import UIKit
import Firebase

class ImageViewController: UIViewController {
    
    var ref: DatabaseReference?
  
    
    var experimentNumber: Int = 0
    var counterNumber: Int = 0
    
    @IBOutlet weak var photo: UIImageView!
    
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonOnClick))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Camera", style: .plain, target: self, action: #selector(cameraButtonOnClick))
        
        
        self.getExperimentNumber()
        
        
        
        
        photo.image = self.image


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func saveButtonOnClick()
    {
        self.getCounterNumber()
        let imageData = UIImageJPEGRepresentation(self.image, 0.8)
        
        let storageRef=Storage.storage().reference(withPath: "experiment\(self.experimentNumber)/\(self.counterNumber).jpg")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        let uploadTask = storageRef.putData(imageData!, metadata: uploadMetaData) { (metadata, error) in
            if(error != nil){
                print("Error Received! \(error!.localizedDescription)")
            }
            else{
                print ("Upload Complete! Heres some metadata \(metadata!)")
                let url:String = (metadata?.downloadURL()?.absoluteString)!
                self.ref?.child("experiment\(self.experimentNumber)").child("\(self.counterNumber)").child("Value").setValue(url)
            }
            
        }
        
        //For progress bar
        
//        uploadTask.observe(.progress){ [weak self] (snapshot) in
//            guard let strongSelf = self else { return }
//            guard let progress = snapshot.progress else { return }
//            strongSelf.progressView.progress = Float(progress.fractionCompleted)
//        }
        
        
        
    
    }
    
    @objc func cameraButtonOnClick()
    {
        navigationController?.popViewController(animated: true)
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
