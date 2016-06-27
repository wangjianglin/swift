//
//  Images.swift
//  LinCore
//
//  Created by lin on 1/14/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import UIKit


extension UIImage{
    
    public class func initImage(size imageSize:CGSize,color:UIColor)->UIImage{
        UIGraphicsBeginImageContextWithOptions(imageSize,false, UIScreen.mainScreen().scale);
        color.set();
        UIRectFill(CGRectMake(0,0, imageSize.width, imageSize.height));
        var image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
    public func scaledToSize(size newSize:CGSize)->UIImage{
    
        UIGraphicsBeginImageContext(newSize);
        self.drawInRect(CGRectMake(0,0,newSize.width,newSize.height));
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    
    //
    //  Images.m
    //  LinCore
    //
    //  Created by lin on 1/14/15.
    //  Copyright (c) 2015 lin. All rights reserved.
    //
    
//    #import "Images.h"
//    
//    @implementation UIImage(LinCore)
//    
//    -(UIImage *)scaledToSize:(CGSize)size{
//    UIGraphicsBeginImageContext(size);
//    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//    }
//    
//    -(UIImage *)scaledToSize:(CGSize)size fill:(BOOL)fill{
    public func scaledToSize(size:CGSize,fill:Bool)->UIImage{
//    
        var s:CGFloat = 1.0;
    //    CGFloat offsetX = 0.0;
    //    CGFloat offsetY = 0.0;
    if (!fill) {
        s = (self.size.width/self.size.height)/(size.width/size.height);
    }
//
        var newSize = size;
    if (s > 1) {
        newSize.height = size.height / s;
    //        offsetY = (self.size.height - size.height) / 2;
    }else{
        newSize.width = size.width * s;
    //        offsetX = (self.size.width - size.width) / 2;
    }
//
    UIGraphicsBeginImageContext(newSize);
//    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
        self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height));
    let newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    }
//
//    +(UIImage*)imageWithURLString:(NSString*)url{
//    return [UIImage imageWithURL:[NSURL URLWithString:url]];
//    }
//    public class func imageWithURLString(url:String)->UIImage{
//        return UIImage.im
//    }
    
//    public class func imageWithURL(url:NSURL)->UIImage{
//        var data = NSData(contentsOfURL: url);
//        return UIImage(data: data!)!;
//    }
     public convenience init?(urlString: String){
        var url = NSURL(string: urlString);
        if let url = url {
            self.init(url:url);
        }else{
            self.init();
        }
    }
//    convenience
    public convenience init?(url: NSURL){
        var data = NSData(contentsOfURL: url);
        if let data = data{
            self.init(data: data);
        }else{
//            self.init(CGImage: nil);
            self.init();
//            return nil;
        }
    }
//    +(UIImage*)imageWithURL:(NSURL*)url{
//    NSData * data = [NSData dataWithContentsOfURL:url];
//    return [UIImage imageWithData:data];
//    }
//    @end

}
