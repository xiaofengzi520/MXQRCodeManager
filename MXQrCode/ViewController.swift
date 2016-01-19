//
//  ViewController.swift
//  MXQrCode
//
//  Created by 牟潇 on 16/1/19.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController ,AVCaptureMetadataOutputObjectsDelegate{

    @IBOutlet weak var messageLabel: UILabel!
    var captureSession:AVCaptureSession?
    var  videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        let input:AnyObject! = try? AVCaptureDeviceInput(device: captureDevice)
        guard ((input as? AVCaptureDeviceInput) != nil) else {return}
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as? AVCaptureDeviceInput)
        let captureMetadataoutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataoutput)
        captureMetadataoutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataoutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
        view.bringSubviewToFront(messageLabel)
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0{
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = "No QR code is detected"
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObjectTypeQRCode{
           let barCodeObj = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObj.bounds
            if metadataObj.stringValue != nil{
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

