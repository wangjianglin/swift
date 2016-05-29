//
//  Vedios.m
//  LinCore
//
//  Created by lin on 8/11/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

//#import "Vedios.h"
////#import "LinUtil/util.h"
//#import "SCRecordSessionManager.h"
//#import "SCEmptyOverlayView.h"
//#import "MRProgressOverlayView.h"
//#import "UIViews.h"
import LinUtil

//@interface VedioConvert()<SCAssetExportSessionDelegate>{
//    NSURL * _url;
//    void (^_action)(NSURL * url);
//}
//
//@end

public class VedioConvert : NSObject, SCAssetExportSessionDelegate{

//@implementation VedioConvert
    private var _url:NSURL;
    public var action:((url:NSURL?)->())?

    public init(url:NSURL){
//    self = [super init];
//    if (self) {
//        _url = url;
//    }
//    return self;
        self._url = url;
}

//-(void)setCompleteAction:(void (^)(NSURL *))action{
//    _action = action;
//}

    public func start(view:UIView){
    
    let progressView = MRProgressOverlayView();
    progressView.mode = MRProgressOverlayViewMode.IndeterminateSmallDefault;
    //[self addSubview:progressView];
    
    view.addSubview(progressView);
    
    progressView.titleLabelText = "正在转换视频...";
    progressView.show(true);
    
    let path = pathFor(Documents.Cache, path: "vediocache");
    
    let fileManager = NSFileManager.defaultManager();
    
        let isDir = UnsafeMutablePointer<ObjCBool>.alloc(1);
    if !fileManager.fileExistsAtPath(path!, isDirectory:isDir) || isDir.memory.boolValue == false {
        try! fileManager.createDirectoryAtPath(path!, withIntermediateDirectories:true, attributes:nil);
    }
    
//    NSURL * outUrl = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",path,@"tmp.mp4"]];
    let outUrl = NSURL(fileURLWithPath:"\(path)/tmp.mp4");
    let exportSession = SCAssetExportSession(asset:AVAsset(URL:_url));
    //exportSession.videoConfiguration.
    exportSession.videoConfiguration.filter = SCFilter.emptyFilter();
    //exportSession.videoConfiguration.preset = SCPresetHighestQuality;
    exportSession.audioConfiguration.preset = SCPresetMediumQuality;
    exportSession.videoConfiguration.maxFrameRate = 30;
    //NSLog(@"_recordSession.outputUrl:%@",_recordSession.outputUrl);
    exportSession.outputUrl = outUrl;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.delegate = self;
    
    //    self.exportView.hidden = NO;
    //    self.exportView.alpha = 0;
    //    CGRect frame =  self.progressView.frame;
    //    frame.size.width = 0;
    //    self.progressView.frame = frame;
    
    //    [UIView animateWithDuration:0.3 animations:^{
    //        //self.exportView.alpha = 1;
    //    }];
    
    let overlay = SCEmptyOverlayView();
    //    overlay.date = _recordSession.date;
    
    exportSession.videoConfiguration.overlay = overlay;//水印
    
    //    UIGraphicsBeginImageContext(label.frame.size);
    //
    //    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    //
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //
    //    UIGraphicsEndImageContext();
    //
    //    exportSession.videoConfiguration.watermarkImage = image;
    //    exportSession.videoConfiguration.watermarkFrame = CGRectMake(10, 10, label.frame.size.width, label.frame.size.height);
    //    exportSession.videoConfiguration.watermarkAnchorLocation = SCWatermarkAnchorLocationBottomRight;
    
    
//    __weak VedioConvert * wself = self;
    
//    void(^completionHandler)(NSURL *url, NSError *error) = ^(NSURL *url, NSError *error) {
//        //NSLog(@"**********************************");
//        //        if (error == nil) {
//        //            //UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
//        //        } else {
//        //            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//        //
//        //            [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//        //        }
//        
//        //outputFile = _recordSession.outputUrl;
//        VedioConvert * sself = wself;
////        sself->outputFile = sself->_recordSession.outputUrl;
////        [wself back:nil];
//        if (sself != nil && sself->_action != nil) {
//            sself->_action(url);
//        }
//        [progressView dismiss:TRUE];
//    };
    
    
    exportSession.exportAsynchronouslyWithCompletionHandler(){[weak self] in
        UIApplication.sharedApplication().endIgnoringInteractionEvents();
        
        //        [UIView animateWithDuration:0.3 animations:^{
        //            //self.exportView.alpha = 0;
        //        }];
        
//        completionHandler(exportSession.outputUrl, exportSession.error);
//        VedioConvert * sself = wself;
        //        sself->outputFile = sself->_recordSession.outputUrl;
        //        [wself back:nil];
//        if (sself != nil && sself->_action != nil) {
//            sself->_action(exportSession.outputUrl);
//        }
        self?.action?(url: exportSession.outputUrl);
        progressView.dismiss(true);
    };
}
}
