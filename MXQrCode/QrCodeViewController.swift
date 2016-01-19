//
//  QrCodeViewController.swift
//  MXQrCode
//
//  Created by 牟潇 on 16/1/19.
//  Copyright © 2016年 muxiao. All rights reserved.
//

import UIKit

class QrCodeViewController: UIViewController {

    @IBOutlet weak var qrcodeImageView: UIImageView!
    @IBOutlet weak var messageTextFiled: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the 
    }

    @IBAction func submit(sender: AnyObject) {
      qrcodeImageView.image =  createQRForString(messageTextFiled.text, qrImageName: "login_icon_logo")
      view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createQRForString(qrString:String?,qrImageName:String?) ->UIImage?{
        if let sureQrString = qrString{
            let stringData = sureQrString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")
            qrFilter?.setValue(stringData, forKey: "inputMessage")
            qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter?.outputImage
            
            let colorFilter = CIFilter(name: "CIFalseColor")
            colorFilter?.setDefaults()
            colorFilter?.setValue(qrCIImage, forKey: "inputImage")
            colorFilter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            
            let codeImage = UIImage(CIImage: (colorFilter?.outputImage?.imageByApplyingTransform(CGAffineTransformMakeScale(5, 5)))!)
            // 通常,二维码都是定制的,中间都会放想要表达意思的图片
            if let iconImage = UIImage(named: qrImageName!) {
                let rect = CGRectMake(0, 0, codeImage.size.width, codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)
                
                codeImage.drawInRect(rect)
                let avatarSize = CGSizeMake(rect.size.width * 0.25, rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.drawInRect(CGRectMake(x, y, avatarSize.width, avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage

        }
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
