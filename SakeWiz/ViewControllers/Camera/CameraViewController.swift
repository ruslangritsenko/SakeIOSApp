//
//  CameraViewController.swift
//  SakeWiz
//
//  Created by TW welly on 6/5/17.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import Photos
import PhotosUI
import EZLoadingActivity

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
    
    
    
    var timerSeconds = 0
    var timer = Timer()
    var canCheckStatus = true
    
    var isAllowingPhotos = true
    
    var imageUploadId:String? = nil
    
    var matchesToPass = Array<String>()
    
    var productObjectToPass:ProductObject? = nil
    
    @IBOutlet weak var uploadProgressView: UIProgressView!

    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!
    
    @IBOutlet weak var flashButton: UIButton!
    @IBAction func flashButtonAction(_ sender: UIButton) {
        
        
        var device : AVCaptureDevice!
        
        if #available(iOS 10.0, *) {
            let videoDeviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDuoCamera, .builtInTelephotoCamera], mediaType: AVMediaTypeVideo, position: .unspecified)!
            let devices = videoDeviceDiscoverySession.devices!
            if let thisDevice = devices.first
            {
                device = thisDevice
            }
            
        } else {
            // Fallback on earlier versions
            device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        }
        
        if(device != nil)
        {
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo))
            {
                if (device.hasFlash)
                {
                    self.captureSession.beginConfiguration()
                    //self.objOverlayView.disableCenterCameraBtn();
                    if device.isFlashActive == false {
                        self.flashOn(device: device)
                        self.flashButton.setImage(UIImage(named: "flash_on"), for: .normal)
                    } else {
                        self.flashOff(device: device);
                        self.flashButton.setImage(UIImage(named: "flash_icon"), for: .normal)
                    }
                    //self.objOverlayView.enableCenterCameraBtn();
                    self.captureSession.commitConfiguration()
                }
            }
        }
        else
        {
            if self.flashButton.image(for: .normal) == UIImage(named: "flash_on")
            {
                self.flashButton.setImage(UIImage(named: "flash_icon"), for: .normal)
            }
            else
            {
                self.flashButton.setImage(UIImage(named: "flash_on"), for: .normal)
            }
        
        }
        
    }
    
    @IBOutlet weak var questionMarkButton: UIButton!
    
    @IBOutlet weak var libraryImageView: UIImageView!
    
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var captureButton: UIButton!
    @IBAction func captureButtonAction(_ sender: UIButton) {
        
        if isAllowingPhotos
        {
            if #available(iOS 10.0, *) {
                let settings = AVCapturePhotoSettings()
                if let _ = imageOutput as? AVCapturePhotoOutput
                {
                    isAllowingPhotos = false
                    (imageOutput as! AVCapturePhotoOutput).capturePhoto(with: settings, delegate: self)
                }
                
            } else {
                // Fallback on earlier versions
                isAllowingPhotos = false
                print("Camera button pressed")
                saveToCamera()
            }
            
        }
    }
    
    @IBOutlet weak var libraryButton: UIButton!
    @IBAction func libraryButtonAction(_ sender: UIButton) {
        
        switch PHPhotoLibrary.authorizationStatus()
        {
        case .authorized:
            
            imagepick()
        case .denied:
            let alertController = UIAlertController (title: "Not Authorized to Use Photo Library", message: "Sake-Wiz must be able to access your camera to use this feature", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                
                DispatchQueue.main.async(execute: {
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        
                        UIApplication.shared.openURL(settingsUrl)
                    }
                    
                })
            }
            
            let cancelAction = UIAlertAction(title: "Later", style: .default, handler: nil)
            
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            return
        default:
            return
        }
        
        
    }
    
    
    let picker = UIImagePickerController()
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var imageOutput: Any? = nil
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        picker.delegate = self
        
        
        
        switch PHPhotoLibrary.authorizationStatus()
        {
        case .authorized:
            DispatchQueue.main.async(execute: {[weak self] () -> Void in
                
                let options = PHFetchOptions()
                options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                
                let allPhotos = PHAsset.fetchAssets(with: options)
                
                if allPhotos.count > 0
                {
                    
                    if let imageSize = self?.libraryImageView.frame.size
                    {
                        
                        PHImageManager.default().requestImage(for: allPhotos.lastObject!, targetSize: imageSize, contentMode: PHImageContentMode.default, options: nil, resultHandler: {(image, _) in
                            
                            self?.libraryImageView.image = image
                        })
                    }
                }
                
            })
        default:
            self.libraryImageView.image = UIImage(named: "some_handsome_guy")
        }
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        
        //captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        //let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        if #available(iOS 10.0, *) {
            
            print("is iOS 10")
            
            imageOutput = AVCapturePhotoOutput()
            var userDevice: AVCaptureDevice? = nil
            
            if #available(iOS 10.2, *) {
                
                print("is iOS 10.2")
                
                print()
            
                if let thisDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInDualCamera, mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.back)
                {
                    userDevice = thisDevice
                }
                else
                {
                    if let thisDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
                    {
                        userDevice = thisDevice
                    }
                
                }
            
            }
            else
            {
                if let thisDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
                {
                    userDevice = thisDevice
                }
                
            }
            
            if let device = userDevice
            {
                if let input = try? AVCaptureDeviceInput(device: device) {
                    if (captureSession.canAddInput(input)) {
                        captureSession.addInput(input)
                        if let _ = imageOutput as? AVCapturePhotoOutput
                        {
                            if (captureSession.canAddOutput(imageOutput as! AVCapturePhotoOutput)) {
                                captureSession.addOutput(imageOutput as! AVCapturePhotoOutput)
                                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                                previewLayer?.frame = self.view.bounds
                                self.view.layer.addSublayer(previewLayer!)
                                captureSession.startRunning()
                                layoutViews()
                            }
                        }
                    } else {
                        print("issue here : captureSesssion.canAddInput")
                        layoutViews()
                    }
                } else {
                    print("some problem here")
                    layoutViews()
                }
            
            }
            else
            {
                print("Device not found")
                layoutViews()
            }
            
        
        } else {
            // Fallback on earlier versions
            if let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] {
                // Loop through all the capture devices on this phone
                for device in devices {
                    // Make sure this particular device supports video
                    if (device.hasMediaType(AVMediaTypeVideo)) {
                        // Finally check the position and confirm we've got the back camera
                        if(device.position == AVCaptureDevicePosition.back) {
                            captureDevice = device
                            if captureDevice != nil {
                                print("Capture device found")
                                beginSessionForBelow10()
                            }
                        }
                    }
                }
            }
            
    
        }
        
        
        
    
        
    }
    
    
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? MatchProductViewController
        {
            destinationVC.matchedProductString = matchesToPass[0]
            if let scanID = imageUploadId
            {
                destinationVC.passedScanID = scanID
            }
        }
        
        if let destinationVC = segue.destination as? PotentialMatchesViewController
        {
            destinationVC.passedIDs = matchesToPass
        }
    }
    
    func cutRectangularHoleIn(thisView: UIView, atView: UIView)
    {
        // Create the initial layer from the view bounds.
        let maskLayer = CAShapeLayer()
        maskLayer.frame = thisView.bounds
        maskLayer.fillColor = UIColor.black.cgColor
        
        // Create the frame
        let rect = CGRect(x: atView.frame.origin.x, y: atView.frame.origin.y, width: atView.frame.width, height: atView.frame.height)

        // Create the path.
        let path = UIBezierPath(rect: thisView.bounds)
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        // Append the circle to the path so that it is subtracted.
        path.append(UIBezierPath(rect: rect))
        //path.append(UIBezierPath(ovalInRect: rect))
        maskLayer.path = path.cgPath
        
        // Set the mask of the view.
        thisView.layer.mask = maskLayer
    
    }
    
    func cutRectangularHoleIn(atView: UIView, withImageView: UIImageView)
    {
        
            // Create the initial layer from the view bounds.
            let maskLayer = CAShapeLayer()
            maskLayer.frame = atView.bounds
            maskLayer.fillColor = UIColor.black.cgColor
            
            // Create the frame
            let rect = CGRect(x: withImageView.frame.origin.x, y: withImageView.frame.origin.y + (withImageView.frame.height * 0.1), width: withImageView.frame.width, height: withImageView.frame.height)
    
            
            // Create the path.
            let path = UIBezierPath(rect: atView.bounds)
            maskLayer.fillRule = kCAFillRuleEvenOdd
            
            // Append the circle to the path so that it is subtracted.
            path.append(UIBezierPath(rect: rect))
            //path.append(UIBezierPath(ovalInRect: rect))
            maskLayer.path = path.cgPath
            
            // Set the mask of the view.
            atView.layer.mask = maskLayer
        
    }
    
    func calculateRectOfImageInImageView(imageView: UIImageView) -> CGRect {
        let imageViewSize = imageView.frame.size
        let imgSize = imageView.image?.size
        
        guard let imageSize = imgSize, imgSize != nil else {
            return CGRect.zero
        }
        
        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        let aspect = fmin(scaleWidth, scaleHeight)
        
        var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
        // Center image
        imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2
        
        // Add imageView offset
        imageRect.origin.x += imageView.frame.origin.x
        imageRect.origin.y += imageView.frame.origin.y
        
        return imageRect
    }
    
    func checkImageStatus()
    {
        print("timer triggered")
        
        if canCheckStatus
        {
        
            guard let imageID = imageUploadId else
            {
                timer.invalidate()
                return
            
            }
        
            canCheckStatus = false
            API.checkImageProcessingStatus(ID: imageID, completionHandler: { [weak self] matches, stat in
            
                self?.canCheckStatus = true
                
                guard let status = stat  else {
                
                    self?.timer.invalidate()
                    
                    EZLoadingActivity.hide(false, animated: true)
                    
                    print("an error has occured with status")
                    
                    return
                }
                
                if status == "RECOGNIZED"
                {
                    
                    
                    self?.timer.invalidate()
                    self?.captureButton.isEnabled = true
                    
                    if matches.count > 0
                    {
                        
                        EZLoadingActivity.hide(true, animated: true)
                        
                        self?.matchesToPass = matches
                        
                        if matches.count > 1
                        {
                            if self?.matchesToPass != nil
                            {
                                self?.performSegue(withIdentifier: "ToPotentialMatches", sender: nil)
                            }
                            
                        }
                        else
                        {
                            //go to product details
                            
                            self?.performSegue(withIdentifier: "ToMatch", sender: nil)
                            
                            
                        }
                        
                    }
                    else
                    {
                        EZLoadingActivity.hide()
                        self?.alert(message: "No Matches were found, please try again.", title: nil, OKButtonTitle: "OK", completionHandler: nil)
                    }
                    
                    
                }else if status == "FAILED"
                {
                    EZLoadingActivity.hide(false, animated: true)
                    
                    
                    self?.timer.invalidate()
                    self?.captureButton.isEnabled = true
                    
                    self?.alert(message: "Failed to recognize image. Please try again or try a different angle".localized(), title: "Image Recognition Failed".localized(), OKButtonTitle: "OK".localized(), completionHandler: nil)
                    
                    
                }
                
                
                
                
            
            }, failure: {[weak self] errorMessage in
                
                if errorMessage != nil
                {
                    self?.alert(message: errorMessage!, title: "Server Error".localized(), OKButtonTitle: "OK".localized(), completionHandler: nil)
                }
                
                print(errorMessage as Any)
                
                EZLoadingActivity.hide()
            
            })
        }
        
        
    }
    
    func setTimer()
    {
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(CameraViewController.checkImageStatus), userInfo: nil, repeats: true)
    
    }
    

    
    func beginSessionForBelow10() {
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
        
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else {
            print("no preview layer")
            return
        }
        
        self.view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame
        captureSession.startRunning()
        layoutViews()
        

    }
    
    func layoutViews()
    {
        self.view.bringSubview(toFront: backgroundBlurView)
        self.view.bringSubview(toFront:flashButton)
        self.view.bringSubview(toFront:questionMarkButton)
        self.view.bringSubview(toFront:libraryImageView)
        self.view.bringSubview(toFront:libraryButton)
        self.view.bringSubview(toFront: overlayImageView)
        self.view.bringSubview(toFront:captureButton)
        uploadProgressView.isHidden = true
        self.view.bringSubview(toFront: uploadProgressView)
        
        cutRectangularHoleIn(atView: backgroundBlurView, withImageView: overlayImageView)
        
        //cutRectangularHoleIn(thisView: backgroundBlurView, atView: overlayImageView)
    }
    
    

    func saveToCamera() {
        
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { [weak self] (CMSampleBuffer, Error) in
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer) {
                    
                    if let cameraImage = UIImage(data: imageData) {
                        
                        self?.isAllowingPhotos = true
                        
                        if UserObject.sharedInstance.userSettings != nil
                        {
                            if UserObject.sharedInstance.userSettings!.canSavePhotosToLibrary
                            {
                                
                                DispatchQueue.main.async(execute: { () -> Void in
                                    
                                    UIImageWriteToSavedPhotosAlbum(cameraImage, nil, nil, nil)
                                    
                                })
                            }
                        }
                        
                        self?.uploadProgressView.progress = 0
                        self?.uploadProgressView.isHidden = false
                        
                        
                        EZLoadingActivity.Settings.SuccessText = "Found".localized()
                        EZLoadingActivity.Settings.FailText = "Not Found".localized()
                        EZLoadingActivity.Settings.LoadOverApplicationWindow = true
                        EZLoadingActivity.show("Now Searching...".localized(), disableUI: true)
                        
                        
                        API.uploadPictureWith(image: cameraImage, progressHandler: {progress in
                            
                            self?.uploadProgressView.progress = Float(progress)
                            
                            
                        }, completionHandler: {[weak self] idString in
                            
                            self?.uploadProgressView.isHidden = true
                            
                            self?.imageUploadId = idString
                            self?.setTimer()
                            
                            
                            print("returned ID: \(idString)")
                            
                            
                            }, failure: {[weak self] errorMessage in
                                
                                self?.uploadProgressView.isHidden = true
                                print(errorMessage as Any)
                                
                                EZLoadingActivity.hide(false, animated: true)
                                
                        })
                    }
                }
            })
        }
    }
    
    func imagepick()
    {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.sourceView = libraryImageView
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func flashOn(device:AVCaptureDevice)
    {
        do{
            if (device.hasTorch)
            {
                try device.lockForConfiguration()
                //device.torchMode = .on
                device.flashMode = .on
                device.unlockForConfiguration()
            }
        }catch{
            //DISABEL FLASH BUTTON HERE IF ERROR
            print("Device tourch Flash Error ");
        }
    }
    
    private func flashOff(device:AVCaptureDevice)
    {
        do{
            if (device.hasTorch){
                try device.lockForConfiguration()
                //device.torchMode = .off
                device.flashMode = .off
                device.unlockForConfiguration()
            }
        }catch{
            flashButton.isEnabled = false
            print("Device Flash Error ");
        }
    }
    
    
    
    //MARK: - Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

            self.doImagePickerLogic(image: image)
            
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            doImagePickerLogic(image: image)
        }
        
        dismiss(animated:true, completion: nil) //5
    }
    
    func doImagePickerLogic(image: UIImage)
    {
        self.libraryImageView.image = image
        
        var imageToSend = image
        
        if image.size.height > 1920.0 || image.size.width > 1080.0
        {
            print("The image is large: \(image.size.width)/\(image.size.height)")
            
            if let thisImage = image.resized(toWidth: 1080.0)
            {
                imageToSend = thisImage
            }
            
        }
        
        self.uploadProgressView.progress = 0
        self.uploadProgressView.isHidden = false
        self.view.bringSubview(toFront: self.uploadProgressView)
        
        EZLoadingActivity.Settings.SuccessText = "Found".localized()
        EZLoadingActivity.Settings.FailText = "Not Found".localized()
        EZLoadingActivity.Settings.LoadOverApplicationWindow = true
        EZLoadingActivity.show("Uploading...".localized(), disableUI: true)
        
        API.uploadPictureWith(image: imageToSend, progressHandler: {[weak self] progress in
            
            self?.uploadProgressView.progress = Float(progress)
            
            }, completionHandler: {[weak self] idString in
                
                EZLoadingActivity.hide()
                EZLoadingActivity.show("Now Searching...", disableUI: true)
                
                self?.uploadProgressView.isHidden = true
                self?.imageUploadId = idString
                self?.setTimer()
                
                
                print("returned ID: \(idString)")
                
                
            }, failure: {[weak self] errorMessage in
                
                self?.uploadProgressView.isHidden = true
                print(errorMessage as Any)
                
                EZLoadingActivity.hide(false, animated: true)
        })
    
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 10.0, *)
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print("error occure : \(error.localizedDescription)")
        }
        
        
        if  let sampleBuffer = photoSampleBuffer
        {
            if let dataImage =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer:  sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
                
                if let cameraImage = UIImage(data: dataImage)
                {
                    
                    print("image resolution : \(cameraImage.size.width)/\(cameraImage.size.height)")
                    
                    self.isAllowingPhotos = true
                    
                    if UserObject.sharedInstance.userSettings != nil
                    {
                        if UserObject.sharedInstance.userSettings!.canSavePhotosToLibrary
                        {
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                UIImageWriteToSavedPhotosAlbum(cameraImage, nil, nil, nil)
                                
                            })
                        
                        }
                    }
                    
                    self.uploadProgressView.progress = 0
                    self.uploadProgressView.isHidden = false
                    
                    
                    EZLoadingActivity.Settings.SuccessText = "Found".localized()
                    EZLoadingActivity.Settings.FailText = "Not Found".localized()
                    EZLoadingActivity.Settings.LoadOverApplicationWindow = true
                    EZLoadingActivity.show("Now Searching...".localized(), disableUI: true)
                    
                    
                    API.uploadPictureWith(image: cameraImage, progressHandler: {[weak self] progress in
                        
                        self?.uploadProgressView.progress = Float(progress)
                        
                        
                        }, completionHandler: {[weak self] idString in
                            
                            self?.uploadProgressView.isHidden = true
                            
                            self?.imageUploadId = idString
                            self?.setTimer()
                            
                            
                            print("returned ID: \(idString)")
                            
                            
                        }, failure: {[weak self] errorMessage in
                            
                            self?.uploadProgressView.isHidden = true
                            print(errorMessage as Any)
                            
                            EZLoadingActivity.hide(false, animated: true)
                            
                    })
                }
                else
                {
                    print("could not get image from data")
                }
                
            }
            else
            {
                print("No image data")
            }
            
            
            
        } else {
            print("no sample buffer")
        }
    }
    
    
}
