//
//  CamaraVC.swift
//  MoneyyBox
//
//  Created by viral on 1/19/19.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import AVFoundation

class CamaraVC: BaseViewController{


    @IBOutlet weak var camaraView: UIView!
    var captureSession: AVCaptureSession?
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    var backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        if #available(iOS 10.2, *){
//            
//            let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
//            do{
//                let input = try AVCaptureDeviceInput(device: captureDevice!)
//                captureSession = AVCaptureSession()
//                captureSession?.addInput(input)
//                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
//                videoPreviewLayer?.frame = view.layer.bounds
//                camaraView.layer.addSublayer(videoPreviewLayer!)
//                captureSession?.startRunning()
//                
//            }
//            catch{
//                print("Error")
//            }
//        }
//        
//        capturePhotoOutput = AVCapturePhotoOutput()
//        capturePhotoOutput?.isHighResolutionCaptureEnabled = false
//        captureSession?.addOutput(capturePhotoOutput!)

    }
    
  
    @IBAction func imageCapture(_ sender: Any) {
        
        
        guard let capturePhotoOutput = self.capturePhotoOutput else{ return }
        let photoSessings = AVCapturePhotoSettings()
        photoSessings.isAutoStillImageStabilizationEnabled = true
        photoSessings.isHighResolutionPhotoEnabled = false
        capturePhotoOutput.capturePhoto(with: photoSessings, delegate: self)
    }
    
    @IBAction func closeCamara(_ sender: Any) {
        onSlideMenuButtonPressed(sender as! UIButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imagePreview" {
            
            let preVC = segue.destination as! PreviewVC
            preVC.takenPhoto = imagePre
            
        }
    }
    
    
}
extension BaseViewController: AVCapturePhotoCaptureDelegate {

//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: CMSampleBuffer?,previewphoto previewPhotoSampleBuffer:CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
//        guard error == nil,
//            let photoSampleBuffer = previewPhotoSampleBuffer else{
//                print("Error")
//                return
//        }
//        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else{ return }
//        let capturedImage = UIImage.init(data: imageData, scale: 1.0)
//
//        if let image = capturedImage{
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        }
//    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            
//            imagePre = UIImage.init(data: imageData, scale: 1.0)
            imagePre = UIImage.init(data: imageData, scale: 1.0)
            
            performSegue(withIdentifier: "imagePreview", sender: nil)
        }
    }
    
}
