//
//  UIColors.swift
//  LinUtil
//
//  Created by Ray on 2017/11/7.
//  Copyright © 2017年 lin. All rights reserved.
//

import Foundation


extension UIColor {
    
    class func colorWithRGBA(red:Int ,green:Int ,blue:Int ,alpha:Int) -> UIColor {
        return UIColor(red: CGFloat(Double(red)/255.0), green:CGFloat(Double(green)/255.0), blue:CGFloat(Double( blue)/255.0), alpha:CGFloat(Double(alpha)/255.0));
        
    }
    
    class func colorWithRGB(red:Int ,green:Int ,blue:Int) -> UIColor {
        return UIColor(red: CGFloat(Double(red)/255.0), green:CGFloat(Double(green)/255.0), blue:CGFloat(Double( blue)/255.0), alpha:1.0);
        
    }
}

//extension Ext where Base:UIColor {
//    
//   
//    
//}

