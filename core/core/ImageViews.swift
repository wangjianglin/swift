//
//  CacheImage.swift
//  LinCore
//
//  Created by lin on 1/18/15.
//  Copyright (c) 2015 lin. All rights reserved.
//


import UIKit
import LinUtil

public enum ImageFill: Int {
    case `default` = 0
    case fill = 1
    case width = 2
    case height = 4
}

//typedef NS_ENUM(NSUInteger, ImageFill) {
//    ImageFillDefault,    //
//    ImageFillFill,  //
//    ImageFillWithWidth,
//    ImageFillWithHeight//
//} ;
//@interface CacheImageOperation : NSOperation
//
//@end
//
//@interface CacheImageOperation(){
//    @private
//    NSString * _path;
//    CacheImageView * _imageView;;
//}
//
//@end


//@interface CacheImageView (){
//@private
//    BOOL isImage;
//    void (^_imageChanged)(CacheImageView * imageView);
//    NSRecursiveLock * lock;
//    CacheImageOperation * operation;
//    NSString * _path;
//}
//
//-(void)setCacheImage:(UIImage *)image;
//@end




//public class CacheImageOperation : NSOperation{
//    
//    private var _path:String;
//    private var _imageView:CacheImageView;;
//
//
//    public init(path:String, imageView:CacheImageView){
////    self = [super init];
//    
//        self._path = path;
//        self._imageView = imageView;
//    }
//
//    public override func main(){
//        let isCancelled = super.cancelled
//        if isCancelled {
//            return;
//        }
//
//        var data:NSData? = nil;
//        let url = NSURL(string:self._path);
//        if let url = url {
//            data = CacheImageView.cachedataForUrl(url);
//        }
//    
//    
//    dispatch_async(dispatch_get_main_queue()) {[weak self]in
//            if self?.cancelled ?? false {
//                if data != nil {
//                    self?._imageView.image = UIImage(data:data!);
//                }else{
//                    if self?._imageView.noImage == nil ?? false {
//                        self._imageView.setCacheImage(UIImage(named:_imageView.noImage));
//                    }else{
//                        self._imageView.setCacheImage(nil);
//                    }
//                }
//            }
//        };
//
//}
//
//}

//private var _CacheImageView_Cache_Path_tmpvar:String?;
//
//
//private var ___CacheImageView_predicate:dispatch_once_t = 0;
//private var ___CacheImageView_instance:Queue!;
//
//
//public class CacheImageView : UIImageView{
//    
////}
////
////@implementation CacheImageView
//    private var _isImage:Bool = false;
//    //    void (^_imageChanged)(CacheImageView * imageView);
//    private var _imageChanged:((imaegView:CacheImageView)->())?
//    private var _lock:NSRecursiveLock?;
//    private var _operation:CacheImageOperation!;
////    private var _path:String?;
//
//
////-(void (^)(CacheImageView * imageView))imageChanged{
////    return self->_imageChanged;
////}
////
////-(void)setImageChanged:(void (^)(CacheImageView * imageView))imageChanged{
////    self->_imageChanged = imageChanged;
////}
//    private var imageChanged:((imaegView:CacheImageView)->())?;
//
//    private class func cachedataForUrl(url:NSURL?)->NSData?{
//    if (url == nil) {
//        return nil;
//    }
//        let md5 = url.absoluteString.md5;
//        var filename:String!;
//    if  CacheImageView.cachePath.hasSuffix("/") {
//        filename = "\(CacheImageView.cachePath)\(md5)";
//    }else{
//        filename = "\(CacheImageView.cachePath)/\(md5)";
//    }
//
//    let data = NSData(file:filename);
//    if data == nil {
//        data = NSData(URL:url);
//        data.writeToFile(filename, atomically:true);
//    }
//    return data;
//
//}
//
//    private class var cachePath:String{
//        get{
//    if _CacheImageView_Cache_Path_tmpvar == nil {
//        _CacheImageView_Cache_Path_tmpvar = pathFor(DocumentsCache, "imagecache");
//    }
//    self.createCachePath();
//    return _CacheImageView_Cache_Path_tmpvar;
//}
//
//set{
//    CacheImageView_Cache_Path_tmpvar = newValue;
//    self.createCachePath();
//}
//    }
//
//private class func createCachePath(){
//    let fileManager = NSFileManager.defaultManager();
////    BOOL isDir = false;
//    let isDir = UnsafeMutablePointer<ObjCBool>.alloc(1);
//    if !fileManager.fileExistsAtPath(_CacheImageView_Cache_Path_tmpvar, isDirectory:isDir) || isDir.memory == false {
//        fileManager.createDirectoryAtPath(_CacheImageView_Cache_Path_tmpvar, withIntermediateDirectories:true, attributes:nil, error:nil);
//    }
//}
//
//
//private func imageCacheQueue()->Queue{
//    dispatch_once(&___CacheImageView_predicate,^{
//        ___CacheImageView_instance = Queue(count:20);
//    });
//    return ___CacheImageView_instance;
//}
//
//    public var path:String? = nil{
////        get{
////    return self->_path;
////}
////set{
//        didSet{
//    if (oldValue == self.path && self._isImage == false) {
////        self->_path = newValue;
//        return;
//    }
////    self->_path = newValue;
//    self.loadImage();
//}
//    }
//
//        public init(path:String){
////    self = [super init];
////    if (self) {
//        self._lock = NSRecursiveLock();
//        self._isImage = false;
//        self.path = path;
////    }
////    return self;
//}
//    public init(){
////    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
////    self = [super init];
////    if (self) {
//        self._lock = NSRecursiveLock();
//        self._isImage = false;
////    }
////    return self;
//}
//
//    public init(frame:CGRect){
////    if (self) {
//        self._lock = NSRecursiveLock();
//        self._isImage = false;
////    }
//    super.init(frame:frame);
////    return self;
//}
//
//private func loadImage(){
//    self._lock.lock();
//    
//    self._operation.cancel();
//    super.image = nil;
//    if self.path != nil && !self.path.isKindOfClass(NSNull.self) {
//        isImage = false;
//        if self.path!.hasPrefix("http://") {
//            operation = CacheImageOperation(path:self.path, imageView:self);
//            CacheImageView.imageCacheQueue.addOperation(operation);
//        }else{
//            self.setImage(UIImage(named:self.path));
//        }
//        
//    }else{
//        self.setImage(UIImage(named:self.noImage));
//    }
//    self._lock.unlock();
//}
//
//    public var image:UIImage?{
//        get{
//    return super.image;
//}
//
//set{
//    self._lock.lock();
//    isImage = true;
//    self._operation.cancel();
//    super.image = newValue;
//    lock.unlock();
//    if _imageChanged != nil {
//        _imageChanged(self);
//    }
//}
//    }
//
//    private func setCacheImage(iamge:UIImage){
//    lock.lock();
//    if _isImage == false {
//        super.image = image;
//    }
//    lock.unlock();
//    if _imageChanged != nil {
//        _imageChanged(self);
//    }
//}
//
//public func removeFromSuperview(){
//    _operation.cancel();
//}
//}



open class FillImageView : UIImageView{
    fileprivate var _preImageSize:CGSize = CGSize(width: 0, height: 0);
    fileprivate var _preVieSize:CGSize = CGSize(width: 0, height: 0);
    fileprivate var _imageView:CacheImageView;
//    private var _image:AnyObject;
//    private var _fill:ImageFill;
    
//    void (^_imageChanged)();
//}
//@end
    open var imageChanged:(()->())?

//@implementation FillImageView


    open var imageView:UIImageView{
    return _imageView;
}

//-(void (^)())imageChanged{
//    return _imageChanged;
//}
//
//-(void)setImageChanged:(void (^)())imageChanged{
//    _imageChanged = imageChanged;
//}

    open var fill:ImageFill = ImageFill.default{
        didSet{
    if (oldValue == fill) {
        return;
    }
    self.update();
}
    }

    public init(){
//    self = [super init];
//    
//    if (self) {
        _imageView = CacheImageView();
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
//        __weak FillImageView * wself = self;
        _imageView.imageChanged = {[weak self] (_:CacheImageView)->() in
//            FillImageView * sself = wself;
            
            self?.update();
            
            if let imageChanged = self?.imageChanged {
                imageChanged();
            }
        };
        
        self.addSubview(_imageView);
        self.backgroundColor = UIColor.clear;
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    return self;
//}

//-(NSObject *)image{
//    return _image;
//}

    open func setFillImage(_ image:AnyObject?){
//        didSet{
    
//        }
//    }
//-(void)setImage:(NSObject *)image{
    if image == nil {
        return;
    }
//    if self.image == nil {
//        _imageView.image = nil;
//        return;
//    }
        
    if image is String {
        _imageView.path = image as? String;
    }else if image is UIImage {
        _imageView.image = image as? UIImage;
    }else{
        _imageView.image = nil;
    }
//}
    }

fileprivate func update(){

    if _imageView.image == nil {
        return;
    }
    
    var viewRect = self.bounds;
    
    let imageSize = _imageView.image?.size ?? CGSize(width: 0,height: 0);
    if imageSize.width == 0 || imageSize.height == 0 {
        return;
    }
    
    if viewRect.size.width == 0 || viewRect.size.height == 0 {
        viewRect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height);
        self.frame = viewRect;
//        [self layoutIfNeeded];
    }
    var contentViewRect = viewRect;
    if imageSize.width != _preImageSize.width || imageSize.height != _preImageSize.height
        || contentViewRect.size.width != _preVieSize.width || contentViewRect.size.height != _preVieSize.height {
        _preImageSize = imageSize;
        _preVieSize = contentViewRect.size;
        var s:CGFloat = 1.0;
        if self.fill != ImageFill.fill {
            s = (_preImageSize.width/_preImageSize.height)/(contentViewRect.size.width/contentViewRect.size.height);
        }
        if (ImageFill.default == self.fill && s > 1) || self.fill == ImageFill.width {
            contentViewRect.size.width = contentViewRect.size.width;
            contentViewRect.size.height = contentViewRect.size.height / s;
            contentViewRect.origin.x = 0;
            contentViewRect.origin.y = (viewRect.size.height - contentViewRect.size.height) / 2;
        }else{
            contentViewRect.size.width = contentViewRect.size.width * s;
            contentViewRect.size.height = contentViewRect.size.height;
            contentViewRect.origin.y = 0;
            contentViewRect.origin.x = (viewRect.size.width - contentViewRect.size.width) / 2;
        }
        _imageView.frame = contentViewRect;
    
    }
}

    open override func layoutSubviews() {
       
    self.update();
    super.layoutSubviews();
}

}

