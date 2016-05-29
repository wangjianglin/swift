////
////  CacheImage.swift
////  LinCore
////
////  Created by lin on 1/18/15.
////  Copyright (c) 2015 lin. All rights reserved.
////
//
//
//#import <UIKit/UIKit.h>
//#import "ImageViews.h"
////#import <LinUtil/LinUtil.h>
////#import "Lin
//
//
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
//
//
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
//
//
//
//
//@implementation CacheImageOperation
//
//
//-(id)initWithPath:(NSString*)path imageView:(CacheImageView*)imageView{
//    self = [super init];
//    
//    if (self) {
//        self->_path = path;
//        self->_imageView = imageView;
//    }
//    
//    return self;
//}
//
//-(void)main{
//    BOOL isCancelled = [self isCancelled];
//        if (isCancelled) {
//            return;
//        }
//
//    __block NSData * data = nil;
//    NSURL * url = [[NSURL alloc] initWithString:self->_path];
//    if (url != nil) {
//        data = [CacheImageView cachedataForUrl:url];
//    }
//    
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//            if (![self isCancelled]) {
//                if (data != nil) {
//                    [self->_imageView setCacheImage:[[UIImage alloc] initWithData:data]];
//                }else{
//                    if (_imageView.noImage) {
//                        [self->_imageView setCacheImage:[UIImage imageNamed:_imageView.noImage]];
//                    }else{
//                        [self->_imageView setCacheImage:nil];
//                    }
//                }
//            }
//        });
//
//}
//
//@end
//NSString * CacheImageView_Cache_Path_tmpvar;
//
//
//dispatch_once_t ___CacheImageView_predicate = 0;
//Queue * ___CacheImageView_instance;
//
//@implementation CacheImageView
//
//
//-(void (^)(CacheImageView * imageView))imageChanged{
//    return self->_imageChanged;
//}
//
//-(void)setImageChanged:(void (^)(CacheImageView * imageView))imageChanged{
//    self->_imageChanged = imageChanged;
//}
//
//+(NSData *)cachedataForUrl:(NSURL *)url{
//    if (url == nil) {
//        return nil;
//    }
//    NSString * md5 = [url absoluteString].md5;
//    NSString * filename;
//    if ([CacheImageView.cachePath hasSuffix:@"/"]) {
//        filename = [[NSString alloc] initWithFormat:@"%@%@", CacheImageView.cachePath , md5 ];
//    }else{
//        filename = [[NSString alloc] initWithFormat:@"%@/%@", CacheImageView.cachePath , md5 ];
//    }
//
//    NSData * data = [NSData dataWithContentsOfFile:filename];
//    if (data == nil) {
//        data = [NSData dataWithContentsOfURL:url];
//        [data writeToFile:filename atomically:TRUE];
//    }
//    return data;
//
//}
//
//+(NSString *)cachePath{
//    if (CacheImageView_Cache_Path_tmpvar == nil) {
//        CacheImageView_Cache_Path_tmpvar = pathFor(DocumentsCache, @"imagecache");
//    }
//    [self createCachePath];
//    return CacheImageView_Cache_Path_tmpvar;
//}
//
//+(void)setCachePath:(NSString *)cachePath{
//    CacheImageView_Cache_Path_tmpvar = cachePath;
//    [self createCachePath];
//}
//
//+(void)createCachePath{
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    BOOL isDir = false;
//    if (![fileManager fileExistsAtPath:CacheImageView_Cache_Path_tmpvar isDirectory:&isDir] || isDir == false) {
//        [fileManager createDirectoryAtPath:CacheImageView_Cache_Path_tmpvar withIntermediateDirectories:TRUE attributes:nil error:nil];
//    }
//}
//
//
//+(Queue*)imageCacheQueue{
//    dispatch_once(&___CacheImageView_predicate,^{
//        ___CacheImageView_instance = [[Queue alloc] initWithCount:20];
//    });
//    return ___CacheImageView_instance;
//}
//
//-(NSString *)path{
//    return self->_path;
//}
//-(void)setPath:(NSString *)path{
//    if (path == self->_path && self->isImage == false) {
//        self->_path = path;
//        return;
//    }
//    self->_path = path;
//    [self loadImage];
//}
//-(id)initWithPath:(NSString*)path{
//    self = [super init];
//    if (self) {
//        self->lock = [[NSRecursiveLock alloc] init];
//        self->isImage = false;
//        self->_path = path;
//    }
//    return self;
//}
//-(id)init{
////    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
//    self = [super init];
//    if (self) {
//        self->lock = [[NSRecursiveLock alloc] init];
//        self->isImage = false;
//    }
//    return self;
//}
//
//-(id)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self->lock = [[NSRecursiveLock alloc] init];
//        self->isImage = false;
//    }
//    return self;
//}
//
//-(void)loadImage{
//    [self->lock lock];
//    
//    [self->operation cancel];
//    super.image = nil;
//    if (self.path != nil && ![self.path isKindOfClass:[NSNull class]]) {
//        isImage = false;
//        if ([self.path hasPrefix:@"http://"]) {
//            operation = [[CacheImageOperation alloc] initWithPath:self.path imageView:self];
//            [CacheImageView.imageCacheQueue addOperation:operation];
//        }else{
//            [self setImage:[UIImage imageNamed:self.path]];
//        }
//        
//    }else{
//        [self setImage:[UIImage imageNamed:self.noImage]];
//    }
//    [self->lock unlock];
//}
//
//-(UIImage *)image{
//    return super.image;
//}
//
//-(void)setImage:(UIImage *)image{
//    [self->lock lock];
//    isImage = true;
//    [self->operation cancel];
//    super.image = image;
//    [lock unlock];
//    if (_imageChanged != nil) {
//        _imageChanged(self);
//    }
//}
//
//-(void)setCacheImage:(UIImage *)image{
//    [lock lock];
//    if (isImage == false) {
//        super.image = image;
//    }
//    [lock unlock];
//    if (_imageChanged != nil) {
//        _imageChanged(self);
//    }
//}
//
//-(void)removeFromSuperview{
//    [operation cancel];
//}
//
//@end
//
//
//
//@interface FillImageView (){
//    @private
//    CGSize preImageSize;
//    CGSize preVieSize;
//    CacheImageView * _imageView;
//    NSObject * _image;
//    ImageFill _fill;
//    
//    void (^_imageChanged)();
//}
//@end
//
//@implementation FillImageView
//
//
//-(UIImageView *)imageView{
//    return _imageView;
//}
//
//-(void (^)())imageChanged{
//    return _imageChanged;
//}
//
//-(void)setImageChanged:(void (^)())imageChanged{
//    _imageChanged = imageChanged;
//}
//
//-(ImageFill)fill{
//    return _fill;
//}
//
//-(void)setFill:(ImageFill)fill{
//    if (_fill == fill) {
//        return;
//    }
//    _fill = fill;
//    [self update];
//}
//
//-(instancetype)init{
//    self = [super init];
//    
//    if (self) {
//        _imageView = [[CacheImageView alloc] init];
//        
//        __weak FillImageView * wself = self;
//        _imageView.imageChanged = ^(CacheImageView * _){
//            FillImageView * sself = wself;
//            
//            [sself update];
//            
//            if (sself->_imageChanged != nil) {
//                sself->_imageChanged();
//            }
//        };
//        
//        [self addSubview:_imageView];
//        self.backgroundColor = [UIColor clearColor];
//    }
//    
//    return self;
//}
//
//-(NSObject *)image{
//    return _image;
//}
//
//-(void)setImage:(NSObject *)image{
//    if (_image == image) {
//        return;
//    }
//    _image = image;
//    if (image == nil) {
//        _imageView.image = nil;
//        return;
//    }
//    if ([image isKindOfClass:[NSString class]]) {
//        _imageView.path = (NSString*)image;
//    }else if([image isKindOfClass:[UIImage class]]){
//        _imageView.image = (UIImage*)image;
//    }else{
//        _imageView.image = nil;
//    }
//}
//
//-(void)update{
//
//    if (_imageView.image == nil) {
//        return;
//    }
//    
//    CGRect viewRect = self.bounds;
//    
//    CGSize imageSize = _imageView.image.size;
//    if (imageSize.width == 0 || imageSize.height == 0) {
//        return;
//    }
//    
//    if (viewRect.size.width == 0 || viewRect.size.height == 0) {
//        viewRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
//        [self setFrame:viewRect];
////        [self layoutIfNeeded];
//    }
//    CGRect contentViewRect = viewRect;
//    if (imageSize.width != preImageSize.width || imageSize.height != preImageSize.height
//        || contentViewRect.size.width != preVieSize.width || contentViewRect.size.height != preVieSize.height) {
//        preImageSize = imageSize;
//        preVieSize = contentViewRect.size;
//        CGFloat s = 1.0;
//        if (self.fill != ImageFillFill) {
//            s = (preImageSize.width/preImageSize.height)/(contentViewRect.size.width/contentViewRect.size.height);
//        }
//        if ((ImageFillDefault == self.fill && s > 1) || self.fill == ImageFillWithWidth) {
//            contentViewRect.size.width = contentViewRect.size.width;
//            contentViewRect.size.height = contentViewRect.size.height / s;
//            contentViewRect.origin.x = 0;
//            contentViewRect.origin.y = (viewRect.size.height - contentViewRect.size.height) / 2;
//        }else{
//            contentViewRect.size.width = contentViewRect.size.width * s;
//            contentViewRect.size.height = contentViewRect.size.height;
//            contentViewRect.origin.y = 0;
//            contentViewRect.origin.x = (viewRect.size.width - contentViewRect.size.width) / 2;
//        }
//        _imageView.frame = contentViewRect;
//    
//    }
//}
//
//-(void)layoutSubviews{
//    [self update];
//    [super layoutSubviews];
//}
//
//@end
//
