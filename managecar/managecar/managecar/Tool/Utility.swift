//
//  Utility.swift
//  managecar
//
//  Created by hjs_mac on 15/12/23.
//  Copyright © 2015年 lizhongqiang. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    
    
    func getPinYin(str:NSString) ->String{
        let strPinYin = NSMutableString(string: str) as CFMutableString
        if (CFStringTransform(strPinYin, nil, kCFStringTransformMandarinLatin, false)) == true{
            if (CFStringTransform(strPinYin, nil, kCFStringTransformStripDiacritics, false)) == true
            {
                return strPinYin as String
            }
        }
        return ""
    }
    
    
    
    func showToastWithMessage(message: String, view: UIView) -> Void {
        let progressHUD: MBProgressHUD = MBProgressHUD.init(view: view)
        view.addSubview(progressHUD)
        progressHUD.detailsLabelText = message
        progressHUD.mode = MBProgressHUDMode.Text
        progressHUD.showAnimated(true, whileExecutingBlock: { 
            sleep(3)
            }) { 
                progressHUD.removeFromSuperview()
        }
        
    }

}
