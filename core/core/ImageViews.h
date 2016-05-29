////
////  CacheImage.h
////  LinCore
////
////  Created by lin on 1/18/15.
////  Copyright (c) 2015 lin. All rights reserved.
////
//
//
//#import <UIKit/UIKit.h>
//
//typedef NS_ENUM(NSUInteger, ImageFill) {
//    ImageFillDefault,    //
//    ImageFillFill,  //
//    ImageFillWithWidth,
//    ImageFillWithHeight//
//} ;
//
//
//@interface CacheImageView : UIImageView
//
//
//+(NSData*)cachedataForUrl:(NSURL*)url;
//
//+(NSString*)cachePath;
//+(void)setCachePath:(NSString*)cachePath;
//
//@property NSString * path;
//
//@property NSString * noImage;
//
//-(id)initWithPath:(NSString*)path;
//@property void(^imageChanged)(CacheImageView * imageView) ;
//
//
//@end
//
//@interface FillImageView : UIView
//
//
//@property(readonly) UIImageView * imageView;
//
//@property void(^imageChanged)() ;
//
//@property ImageFill fill;
//
//@property NSObject * image;
//
//@end
//
//@interface ColorImageView : UIImageView
//
//-initWithColor:(UIColor*)color;
//+imageWithColor:(UIColor*)color;
//
//@end
