//
//  CameraViewController.swift
//  SmartBbq
//
//  Created by Vigram Mohan on 18/05/2018.
//  Copyright © 2018 Vigram. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<Experiment", style: .plain, target: self, action: #selector(ExperimentMenuOnClick))
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCaptureSession()
    {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice()
    {
        
    let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
      let devices = deviceDiscoverySession.devices
        for device in devices
        {
            if device.position == AVCaptureDevice.Position.back
            {
                backCamera = device
            }
            else if device.position == AVCaptureDevice.Position.front
            {
                frontCamera = device
            }
        }
        
        currentCamera = backCamera
    }
    
    
    func setupInputOutput(){
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        }
        catch
        {
            print(error)
            
        }
        
    }
    
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
    
    
    @IBAction func cameraButtonOnClick(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto_Segue" {
            let imageVC = segue.destination as! ImageViewController
            imageVC.image = self.image
        }
    }
    
    @objc func ExperimentMenuOnClick(){
        navigationController?.popViewController(animated: true)
    }
    
}

extension CameraViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            print(imageData)
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "showPhoto_Segue", sender: self)
        }
    }
}
