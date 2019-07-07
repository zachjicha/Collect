//
//  ViewController.swift
//  CollectApp
//
//  Created by Rizzian Tuazon on 7/2/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit
//Import for camera usage
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    var captureDevice:AVCaptureDevice!
    
    var takePhoto = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Init the camera
        initializeCamera()
    }
    
    
    func initializeCamera() {
        
        //Set the camera preset to photo
        //THis auto focuses and does some other settings like ISO
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        //If the back camera != nil
        if let backCam = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) {
            
            //set the capture device to the back camera
            captureDevice = backCam
            //Start the camera session
            beginCameraSession()
        }
        
        
    }
    
    func beginCameraSession() {
        //Try catch
        do {
            
            //If we can get input from camera
            //This cast is a warning but the code doesnt seem to work without it
            if let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice) as? AVCaptureDeviceInput {
                
                //If we can add an input, add our backCamera to the capture session
                if(captureSession.canAddInput(captureDeviceInput)) {
                    captureSession.addInput(captureDeviceInput)
                }
            }
            
        }
        catch {
            //Maybe do something else here, or nothing at all
            //This should only be if the user does not give permission
            //to use the camera, which will mean the camera sends black frames
            print(error.localizedDescription)
        }
        
        //Set up preview layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        self.view.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.view.layer.frame
        
        //Start capture session
        captureSession.startRunning()
        
        //Set up data output
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String):(kCVPixelFormatType_32BGRA)]
        
        //Discard late frames to aid performance
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        //If can add out put, add the data output
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        //Commit the config
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "com.Collect.captureQueue")
        
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        takePhoto = true
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if takePhoto {
            takePhoto = false
            
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                
                let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
                    
                photoVC.takenPhoto = image
                    
                DispatchQueue.main.async {
                    self.present(photoVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func getImageFromSampleBuffer(buffer:CMSampleBuffer) -> UIImage? {
        
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRectangle = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRectangle) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        
        return nil
        
        
    }
    
    
}
