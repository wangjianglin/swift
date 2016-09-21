//
//  CacheImage.swift
//  LinCore
//
//  Created by lin on 1/18/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation
import UIKit
import LinUtil

//class CacheImageView;

open class CacheImageOperation : Operation{
    
    fileprivate var path:String!;
    fileprivate var imageView:CacheImageView!;
    
    fileprivate init(path:String,imageView:CacheImageView){
        self.path = path;
        self.imageView = imageView;
    }
    
    open override func main(){
        
        var isCancelled = false;
        //self.imageView.lock.lock();
        isCancelled = self.isCancelled;
        //self.imageView.lock.unlock();
        if isCancelled {
            return;
        }
        //        var url = NSURL(string:self.path);
//        var data:NSData? = nil;
//        if let url = NSURL(string:self.path){
        let image = CacheImageView.cachedataForUrl(url: self.path)
//        }
        
        
        DispatchQueue.main.async(execute: {() in
            if !self.isCancelled {
                if let image = image {
                    self.imageView.setImage(image);
                }else{
                    self.imageView.setImage(nil);
                }
            }
        });
        
        //        let md5 = self.path.md5 + ".imagecache";
        //        //var urlString = HTTP_COMM_URL + photo.path + "/" + photo.name;// + "." + photo.ext;
        //        var filename:String!;
        //        if CacheImageView.cachePath.hasSuffix("/") {
        //            filename = CacheImageView.cachePath + md5;
        //        }else{
        //            filename = CacheImageView.cachePath + "/" + md5;
        //        }
        //
        //
        //        var data = NSData(contentsOfFile: filename);
        //        if data == nil {
        //            var url = NSURL(string:self.path);
        //            data = NSData(contentsOfURL:url!);
        //            if let data = data {
        //                dispatch_async(dispatch_get_main_queue(), {() in
        //                    if !self.cancelled {
        //                        self.imageView.setImage(UIImage(data:data));
        //                    }
        //                });
        //                data.writeToFile(filename, atomically: true);
        //            }
        //        }else{
        //            dispatch_async(dispatch_get_main_queue(), {() in
        //                //self.imageView.lock.lock();
        //                if !self.cancelled {
        //                    self.imageView.setImage(UIImage(data:data!));
        //                }
        //                ///self.imageView.lock.unlock();
        //
        //            });
        //        }
    }
}

private var CacheImageView_Cache_Path_tmpvar:String?;

open class CacheImageView : UIImageView{
    
    struct YRSingleton{
        static var instance:OperationQueue? = nil
    }
    
    fileprivate static var __once: () = {

            YRSingleton.instance = OperationQueue();

            YRSingleton.instance!.maxConcurrentOperationCount = 10;

        }()

    

    

//    public class func cachedataForUrl(url:NSURL)->NSData!{
    open class func cachedataForUrl(url urlStr:String?)->UIImage!{
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
        if CacheImageView.cachePath.hasSuffix("/") {
            filename = CacheImageView.cachePath + md5;
        }else{
            filename = CacheImageView.cachePath + "/" + md5;
        }
        
        
        var data = try? Data(contentsOf: URL(fileURLWithPath: filename));
        if data == nil {
            data = try? Data(contentsOf: url);
            if let data = data {
//                try? data.write(to: URL(fileURLWithPath: filename), options: [.dataWritingAtomic]);
                try? data.write(to: URL(fileURLWithPath: filename), options: Data.WritingOptions.atomic);
            }
        }
        if let data = data {
            return UIImage(data: data);
        }
        return nil;
    }
    
    open class var cachePath:String{
        get{
            if CacheImageView_Cache_Path_tmpvar == nil {
                CacheImageView_Cache_Path_tmpvar = pathFor(Documents.cache, path: "imagecache");
            }
            createCachePath()
            return CacheImageView_Cache_Path_tmpvar!
        }
        set{CacheImageView_Cache_Path_tmpvar = newValue;createCachePath();}
    }
    
    fileprivate class func createCachePath(){
        let fileManager = FileManager.default;
        //        isDirectory: UnsafeMutablePointer<ObjCBool>
        let isDir = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1);
        isDir.initialize(to: ObjCBool(false));
        if !fileManager.fileExists(atPath: CacheImageView_Cache_Path_tmpvar!,isDirectory:isDir) ||
            isDir.move().boolValue == false{
            do {
                //            func createDirectoryAtPath(path: String, withIntermediateDirectories createIntermediates: Bool, attributes: [NSObject : AnyObject]?, error: NSErrorPointer)
                try fileManager.createDirectory(atPath: CacheImageView_Cache_Path_tmpvar!,withIntermediateDirectories:true,attributes:nil)
            } catch _ {
            };
        }
    }
    
    private class var imageCacheQueue:OperationQueue{
        _ = CacheImageView.__once
        return YRSingleton.instance!
    }
    
    
    fileprivate var operation:CacheImageOperation?;
    
    public var path:String?{
        didSet{
            if self.path == oldValue && self.isImage == false {
                return;
            }
            self.loadImage();
        }
    }
    //
    
    //    public init(path:String){
    //        super.init();
    //        self.path = path;
    ////        super.init();
    //    }
    
    public init(){
        super.init(frame:CGRect(x: 0, y: 0, width: 0, height: 0));
    }
    
    public override init(frame: CGRect) {
        super.init(frame:frame);
    }
    
    fileprivate func loadImage(){
        lock.lock();
        if let operation = self.operation {
            operation.cancel();
        }
        super.image = nil;
        if let path = self.path {
            isImage = false;
            operation = CacheImageOperation(path: path,imageView:self);
            CacheImageView.imageCacheQueue.addOperation(operation!);
        }
        lock.unlock();
    }
    
    public var imageChanged:((_ imageView:CacheImageView)->())?
    
    fileprivate var isImage:Bool = false;
    fileprivate var lock:NSRecursiveLock = NSRecursiveLock();
    open override var image: UIImage?{
        get{
            return super.image;
        }
        set{
            lock.lock();
            self.isImage = true;
            if let operation = self.operation {
                operation.cancel();
            }
            super.image = newValue;
            lock.unlock();
            if let imageChanged = self.imageChanged {
                imageChanged(self);
            }
        }
    }
    
    fileprivate func setImage(_ image:UIImage?){
        lock.lock();
        if self.isImage == false {
            super.image = image;
        }
        lock.unlock();
        if let imageChanged = self.imageChanged {
            imageChanged(self);
        }
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func removeFromSuperview() {
        if let operation = self.operation {
            operation.cancel();
        }
    }
    
    //    public func reuse(){
    //    
    //    }
    
    //    required public init(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder);
    //    }
}
