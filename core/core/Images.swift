//
//  Images.swift
//  LinCore
//
//  Created by lin on 1/14/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import UIKit
import LinUtil

private var CacheImageView_Cache_Path_tmpvar:String?;

extension UIImage{
    
    public class func initImage(size imageSize:CGSize,color:UIColor)->UIImage{
        UIGraphicsBeginImageContextWithOptions(imageSize,false, UIScreen.main.scale);
        color.set();
        UIRectFill(CGRect(x: 0,y: 0, width: imageSize.width, height: imageSize.height));
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
    
    public func scaledToSize(size newSize:CGSize)->UIImage{
    
        UIGraphicsBeginImageContext(newSize);
        self.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height));
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage!;
    }
    
    public func scaledToSize(_ size:CGSize,fill:Bool)->UIImage{
   
        var s:CGFloat = 1.0;
        if (!fill) {
            s = (self.size.width/self.size.height)/(size.width/size.height);
        }
        var newSize = size;
        if (s > 1) {
            newSize.height = size.height / s;
        }else{
            newSize.width = size.width * s;
        }
        UIGraphicsBeginImageContext(newSize);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!;
    }

     public convenience init?(urlString: String){
        let url = URL(string: urlString);
        if let url = url {
            self.init(url:url);
        }else{
            self.init();
        }
    }
    
    public convenience init?(url: URL){
        let data = try? Data(contentsOf: url);
        if let data = data{
            self.init(data: data);
        }else{
            self.init();
        }
    }

    public class func cache(url urlStr:String?)->UIImage!{
        if urlStr == nil {
            return nil;
        }
        let lowerUrlStr = urlStr!.lowercased();
        if !(lowerUrlStr.hasPrefix("http://")
            || lowerUrlStr.hasPrefix("https://")
            || lowerUrlStr.hasPrefix("ftp://")) {
            return UIImage(named: urlStr!);
        }
        
        let urlOpt = URL(string: urlStr!);
        
        if urlOpt == nil {
            return nil;
        }
        
        let url = urlOpt!;
        
        let md5 = "\(url)".md5 + ".imagecache";
        
        var filename:String!;
        if UIImage.cachePath.hasSuffix("/") {
            filename = UIImage.cachePath + md5;
        }else{
            filename = UIImage.cachePath + "/" + md5;
        }
        
        
        var data = try? Data(contentsOf: URL(fileURLWithPath: filename));
        if data == nil {
            data = try? Data(contentsOf: url);
            if let data = data {
                try? data.write(to: URL(fileURLWithPath: filename), options: Data.WritingOptions.atomic);
            }
        }
        if let data = data {
            return UIImage(data: data);
        }
        return nil;
    }
    
    public class var cachePath:String{
        get{
            if CacheImageView_Cache_Path_tmpvar == nil {
                CacheImageView_Cache_Path_tmpvar = pathFor(Documents.cache, path: "imagecache");
            }
            createCachePath()
            return CacheImageView_Cache_Path_tmpvar!
        }
        set{CacheImageView_Cache_Path_tmpvar = newValue;createCachePath();}
    }
    
    private class func createCachePath(){
        let fileManager = FileManager.default;
        let isDir = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1);
        isDir.initialize(to: ObjCBool(false));
        if !fileManager.fileExists(atPath: CacheImageView_Cache_Path_tmpvar!,isDirectory:isDir) ||
            isDir.move().boolValue == false{
            do {
                try fileManager.createDirectory(atPath: CacheImageView_Cache_Path_tmpvar!,withIntermediateDirectories:true,attributes:nil)
            } catch _ {
            };
        }
    }
}
