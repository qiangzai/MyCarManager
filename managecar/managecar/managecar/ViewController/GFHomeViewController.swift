//
//  GFHomeViewController.swift
//  managecar
//
//  Created by hjs_mac on 15/12/18.
//  Copyright © 2015年 lizhongqiang. All rights reserved.
//

import UIKit

// MARK: --屏幕尺寸--
public let KScreenWidth: CGFloat = UIScreen.mainScreen().bounds.width
public let KScreenHeight: CGFloat = (UIScreen.mainScreen().bounds.height)
public let KScreenContent: CGFloat = (UIScreen.mainScreen().bounds.height - 64)
public let KScreenRate: CGFloat = (UIScreen.mainScreen().bounds.size.width / 320.0)



class GFHomeViewController: GFBaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate {
    var label:UILabel?
    var button:UIButton?
    
    var firstTF:UITextField?
    var nameTF:UITextField?
    var carImg:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.whiteColor()
//        self.navigationItem.titleView = 
        
//        label = UILabel(frame: CGRectMake(100, 100, 100, 10))
//        label?.text = "测试文字"
//        self.view.addSubview(label!)
        
        firstTF = UITextField(frame: CGRectMake(10, 70, 300, 40))
        firstTF?.backgroundColor = UIColor.grayColor()
        firstTF?.layer.cornerRadius = 5
        firstTF?.layer.masksToBounds = true
        firstTF?.placeholder = "首字母"
        self.view.addSubview(firstTF!)
        
        nameTF = UITextField(frame: CGRectMake(10, 120, 300, 40))
        nameTF?.backgroundColor = UIColor.grayColor()
        nameTF?.layer.cornerRadius = 5
        nameTF?.layer.masksToBounds = true
        nameTF?.placeholder = "名字"
        self.view.addSubview(nameTF!)
        
        
        carImg = UIImageView(frame: CGRectMake(50, 190, 220, 220))
        carImg?.backgroundColor = UIColor.grayColor()
        carImg?.userInteractionEnabled = true
        self.view.addSubview(carImg!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(GFHomeViewController.tapEvent(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        carImg?.addGestureRecognizer(tap)
        
        
        button = UIButton(frame: CGRectMake(100, 460, 100, 40))
        button?.setTitle("按钮", forState: UIControlState.Normal)
        button?.backgroundColor = UIColor.blueColor()
        button?.addTarget(self, action: #selector(GFHomeViewController.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button!)
        
        let keyboard:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GFHomeViewController.keyboardEvent(_:)))
        keyboard.numberOfTapsRequired = 1
        keyboard.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(keyboard)
        
//        let bquery:BmobQuery = BmobQuery(className: "car")
//        bquery.findObjectsInBackgroundWithBlock { (array, error) -> Void in
//            NSLog("%@", array);
//        }
        
//        let str = NSMutableString(string: "重庆") as CFMutableString
//        if (CFStringTransform(str, nil, kCFStringTransformToLatin, false)) == true{
//            if (CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)) == true{
//                print(str)
//            }
//            
//        }
        
        
    }
    
    func keyboardEvent(tap:UIGestureRecognizer){
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }
    
    func tapEvent(tap:UIGestureRecognizer){
        let actionSheet = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil,otherButtonTitles: "相机","相册")
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let imgPickCtr = UIImagePickerController()
        imgPickCtr.delegate = self
        imgPickCtr.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        if(buttonIndex == 1){
            imgPickCtr.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imgPickCtr, animated: true) { () -> Void in
                
            }
        }else if(buttonIndex == 2){
            imgPickCtr.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imgPickCtr, animated: true, completion: { () -> Void in
                
            })
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true) { () -> Void in
            
        }
//        NSLog("%@", info)
        
        var imagePhoto:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePhoto = imageByScalingToMaxSize(imagePhoto)
        let imgEditorVC: VPImageCropperViewController = VPImageCropperViewController(image: imagePhoto, cropFrame: CGRectMake(0, 130 * KScreenRate, KScreenWidth, KScreenWidth), limitScaleRatio: 3)
        imgEditorVC.delegate = self
        self.presentViewController(imgEditorVC, animated: true) { 
            
        }
        
        
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    let ORIGINAL_MAX_WIDTH: CGFloat = 640.0
    
    
    
    func imageByScalingToMaxSize(sourceImage: UIImage) -> UIImage {
        if sourceImage.size.width < ORIGINAL_MAX_WIDTH {
            return sourceImage
        }
        var btWidth: CGFloat = 0.0
        var btHeight: CGFloat = 0.0
        if sourceImage.size.width > sourceImage.size.height {
            btHeight = ORIGINAL_MAX_WIDTH
            btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height)
        } else {
            btWidth = ORIGINAL_MAX_WIDTH
            btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width)
        }
        let targetSize: CGSize = CGSizeMake(btWidth, btHeight)
        
        return imageByScalingAndCroppingForSourceImage(sourceImage, targetSize: targetSize)
        
        
    }
    
    func imageByScalingAndCroppingForSourceImage(sourceImage: UIImage, targetSize: CGSize) -> UIImage {
        var newImage: UIImage?
        let imageSize: CGSize = sourceImage.size
        let width: CGFloat = imageSize.width
        let height: CGFloat = imageSize.height
        let targetWidth: CGFloat = targetSize.width
        let targetHeight: CGFloat = targetSize.height
        var scaleFactor: CGFloat = 0.0
        var scaleWidth: CGFloat = targetWidth
        var scaleHeight: CGFloat = targetHeight
        var thumbnailPoint: CGPoint = CGPointMake(0.0, 0.0)
        if CGSizeEqualToSize(imageSize, targetSize) == false {
            let widthFactor: CGFloat = targetWidth / width
            let heightFactor: CGFloat = targetHeight / height
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            } else {
                scaleFactor = heightFactor
            }
            scaleWidth = width * scaleFactor
            scaleHeight = height * scaleFactor
            
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaleHeight) * 0.5
            } else if widthFactor < heightFactor {
                thumbnailPoint.x = (targetWidth - scaleWidth) * 0.5
            }
        }
        
        UIGraphicsBeginImageContext(targetSize)
        var thumbnailRect: CGRect = CGRectZero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaleWidth
        thumbnailRect.size.height = scaleHeight
        
        sourceImage.drawInRect(thumbnailRect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        if newImage == nil {
            print("could not scale image")
        }
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
    
    func buttonClick(sender:UIButton){
        let strName:NSString = (nameTF?.text)!
        if(strName.length <= 0){
            Utility().showToastWithMessage("请输入名字", view: self.view)
            return;
        }
        let strFirst:NSString = (firstTF?.text)!
        if(strFirst.length <= 0){
            Utility().showToastWithMessage("请输入首字母", view: self.view)
            return;
        }
        let imgData:NSData = UIImageJPEGRepresentation((carImg?.image)!, 0.5)! as NSData
        if imgData.length <= 0 {
            Utility().showToastWithMessage("请拍照", view: self.view)
            return;
        }
        
        let cardata:BmobObject = BmobObject(className:"car")
        cardata.setObject(strFirst, forKey: "firstIndex")
        cardata.setObject(strName, forKey: "carName")
        let fileName = Utility().getPinYin(strName)
        cardata.setObject(fileName, forKey: "fileName")
        let file: BmobFile = BmobFile.init(fileName: fileName + ".png", withFileData: imgData)
        file.saveInBackground { (success, error) -> Void in
            if success{
                cardata.setObject(file.url, forKey: "imageurl")
                cardata.saveInBackgroundWithResultBlock({ (isSuccess, errorcode) -> Void in
                    if isSuccess{
                        print("保存数据成功")
                    }
                })
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension GFHomeViewController: VPImageCropperDelegate {
    func imageCropper(cropperViewController: VPImageCropperViewController!, didFinished editedImage: UIImage!) {
        cropperViewController.dismissViewControllerAnimated(true) { 
            
        }
        
        carImg?.image = editedImage
        
    }
    
    func imageCropperDidCancel(cropperViewController: VPImageCropperViewController!) {
        cropperViewController.dismissViewControllerAnimated(true) { 
            
        }
    }
}




