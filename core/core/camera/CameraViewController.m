//
//  CameraViewController.m
//  LinCore
//
//  Created by lin on 7/20/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "CameraViewController.h"
#import "SCTouchDetector.h"
#import <AVFoundation/AVFoundation.h>
#import "SCTouchDetector.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SCEmptyOverlayView.h"
#import "SCRecordSessionManager.h"
#import "LeafButton.h"
//#import "LinUtil/util.h"
#import "MRProgressOverlayView.h"

#define kVideoPreset AVCaptureSessionPresetHigh

@interface CameraViewController ()<SCRecorderDelegate, SCAssetExportSessionDelegate>{
    SCRecorder *_recorder;
    SCRecordSession *_recordSession;
    UIButton * cancelButton;
    UIButton * flashButton;
    volatile BOOL isRecording;
//    NSDate * startTime;
    volatile NSTimeInterval minInterval;//单位为 秒
    volatile NSTimeInterval maxInterval;//单位为 秒
    UILabel * timeLabel;
    NSDateFormatter *dateFormatter;
    LeafButton *button;
    NSURL * outputFile;
}
@property (strong, nonatomic) SCRecorderToolsView *focusView;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    isRecording = false;
    
    minInterval = 10.0;
    maxInterval = 15.0;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // Do any additional setup after loading the view.
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    self.view.backgroundColor = [[UIColor alloc] initWithRed:0.02 green:0.02 blue:0.02 alpha:1.0];
    
    UIView * previewView = [[UIView alloc] init];
    CGRect rect = CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width - 40)/2.0, self.view.bounds.size.width, self.view.bounds.size.width);
    previewView.frame = rect;
    previewView.backgroundColor = [[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];;
    [self.view addSubview:previewView];
    
    _recorder = [SCRecorder recorder];
    
    _recorder.audioConfiguration.enabled = FALSE;
    
    _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    _recorder.maxRecordDuration = CMTimeMake(15, 1);
//    _recorder.
    //    _recorder.fastRecordMethodEnabled = YES;
    _recorder.flashMode = SCFlashModeOff;
    
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = YES;
    
    _recorder.previewView = previewView;
    
    //self.focusView = [[SCRecorderToolsView alloc] initWithFrame:previewView.frame];
    //self.focusView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    //self.focusView.recorder = _recorder;
    //[previewView addSubview:self.focusView];
    
    //    self.focusView.outsideFocusTargetImage = [UIImage imageNamed:@"capture_flip"];
    //    self.focusView.insideFocusTargetImage = [UIImage imageNamed:@"capture_flip"];
    
    //_recorder.initializeSessionLazily = NO;
    
    NSError *error;
    if (![_recorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
    
    //    UIView * button = [[UIView alloc] init];
    //
    //    button.backgroundColor = [UIColor grayColor];
    //    button.userInteractionEnabled = YES;
    //
    //    button.frame = CGRectMake(60, 420, 100, 40);
    //    //button.
    //    //button.titleLabel.textColor = [UIColor redColor];
    //    [self.view addSubview:button];
    //    [self.view bringSubviewToFront:button];
    //
    //
    //    [button addGestureRecognizer:[[SCTouchDetector alloc] initWithTarget:self action:@selector(handleTouchDetected:)]];
    
    
    //    LeafButton *button = [[LeafButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    //    button.tag = 100;
    //    button.center = self.view.center;
    //    [button setClickedBlock:^(LeafButton *button) {
    //        NSLog(@"我被点中了");
    //    }];
    
    //[button addGestureRecognizer:[[SCTouchDetector alloc] initWithTarget:self action:@selector(handleTouchDetected:)]];
    
    
    button = [[LeafButton alloc] initWithFrame:CGRectMake(80, 80, 80, 80)];
    button.tag = 100;
    button.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - 50);
    button.type=LeafButtonTypeVideo;
    
    __weak CameraViewController * wself = self;
    [button setClickedBlock:^(LeafButton *button) {
        //NSLog(@"我被点中了");
        [wself recorderClick];
    }];
    
    [self.view addSubview:button];
    
    
    //CGRect frame = CGRectMake(10, 70, 60, 30);
    cancelButton = [[UIButton alloc] init];
    //cancelButton = [[UIButton alloc] initWithFrame:frame];
    
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(0, self.view.bounds.size.height - 70, 90, 45);
    cancelButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16.0];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //cancelButton.titleLabel.text = @"取消";
//    cancelButton.tintColor = [UIColor redColor];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancelButton];
    
    
    UIButton * cameraButton = [[UIButton alloc] init];
    cameraButton.frame = CGRectMake(self.view.frame.size.width - 75, 20, 60, 35);
    //[cameraButton setImage:[UIImage imageNamed:@"LinCore.bundle/camera/camera_icon_camera.png"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"LinCore.bundle/camera/capture_flip.png"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(switchCameraMode:) forControlEvents:UIControlEventTouchUpInside];
    //[cameraButton setTitle:@"取消00" forState:UIControlStateNormal];
    
    //cameraButton.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:cameraButton];
    
    
    flashButton = [[UIButton alloc] init];
    flashButton.frame = CGRectMake(5, 20, 60, 35);
    [flashButton setImage:[UIImage imageNamed:@"LinCore.bundle/camera/camera_icon_toggle_flash.png"] forState:UIControlStateNormal];
    [flashButton setTitle:@"  关" forState:UIControlStateNormal];
    flashButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14.0];
    //cameraButton.backgroundColor = [UIColor grayColor];
    [flashButton addTarget:self action:@selector(switchFlash:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:flashButton];
    
    
    timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"00:00:00";
    timeLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14.0];
    timeLabel.frame = CGRectMake(0, 20, self.view.bounds.size.width, 30);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:timeLabel];
}

- (void)switchCameraMode:(id)sender {
    [_recorder switchCaptureDevices];
//    if ([_recorder.captureSessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            //self.capturePhotoButton.alpha = 0.0;
//            //self.recordView.alpha = 1.0;
//            //self.retakeButton.alpha = 1.0;
//            //self.stopButton.alpha = 1.0;
//        } completion:^(BOOL finished) {
//            _recorder.captureSessionPreset = kVideoPreset;
//            //[self.switchCameraModeButton setTitle:@"Switch Photo" forState:UIControlStateNormal];
//            //[self.flashModeButton setTitle:@"Flash : Off" forState:UIControlStateNormal];
//            //_recorder.flashMode = SCFlashModeOff;
//        }];
//    } else {
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            //self.recordView.alpha = 0.0;
//            //self.retakeButton.alpha = 0.0;
//            //self.stopButton.alpha = 0.0;
//            //self.capturePhotoButton.alpha = 1.0;
//        } completion:^(BOOL finished) {
//            _recorder.captureSessionPreset = AVCaptureSessionPresetPhoto;
//            //[self.switchCameraModeButton setTitle:@"Switch Video" forState:UIControlStateNormal];
//            //[self.flashModeButton setTitle:@"Flash : Auto" forState:UIControlStateNormal];
//            //_recorder.flashMode = SCFlashModeAuto;
//        }];
//    }
}

- (void)switchFlash:(id)_ {
    NSString *flashModeString = nil;
    if ([_recorder.captureSessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
        switch (_recorder.flashMode) {
            case SCFlashModeAuto:
                flashModeString = @"  关";
                _recorder.flashMode = SCFlashModeOff;
                break;
            case SCFlashModeOff:
                flashModeString = @"  开";
                _recorder.flashMode = SCFlashModeOn;
                break;
            case SCFlashModeOn:
                flashModeString = @"  灯";
                _recorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                flashModeString = @" 自动";
                _recorder.flashMode = SCFlashModeAuto;
                break;
            default:
                break;
        }
    } else {
        switch (_recorder.flashMode) {
            case SCFlashModeOff:
                flashModeString = @"  灯";
                _recorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                flashModeString = @"  关";
                _recorder.flashMode = SCFlashModeOff;
                break;
            default:
                break;
        }
    }
    
    [flashButton setTitle:flashModeString forState:UIControlStateNormal];
}

-(void)back:(UIButton*)_{
    [self dismissViewControllerAnimated:TRUE completion:nil];
    if (_delegate != nil && [self.delegate respondsToSelector:@selector(cameraViewResponse:)]) {
        [self.delegate cameraViewResponse:outputFile];
    }
}

-(void)dealloc{
//    NSLog(@"----------------------=====================");
}

-(void)updateTimeAction:(id)_{
    //__weak CameraViewController * wself = self;
    double preValue = -1;
    while (isRecording) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //timeLabel.text = [dateFormatter stringForObjectValue:;
            NSMutableString * sb = [[NSMutableString alloc] init];
            CMTime ctime = _recorder.session.duration;
            int time = (int)(ctime.value / ctime.timescale);
            int s = time % 60;
            time = time / 60;
            int m = time % 60;
            int h = time /  60;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-security"
            if(h<10){
                [sb appendFormat:[[NSString alloc] initWithFormat:@"0%d:",h]];
            }else{
                [sb appendFormat:[[NSString alloc] initWithFormat:@"%d:",h]];
            }
            if(m<10){
                [sb appendFormat:[[NSString alloc] initWithFormat:@"0%d:",m]];
            }else{
                [sb appendFormat:[[NSString alloc] initWithFormat:@"%d:",m]];
            }
            if(s<10){
                [sb appendFormat:[[NSString alloc] initWithFormat:@"0%d",s]];
            }else{
                [sb appendFormat:[[NSString alloc] initWithFormat:@"%d",s]];
            }
#pragma clang diagnostic pop
            timeLabel.text = sb;
        });
        CMTime ctime = _recorder.session.duration;
        //if ([_recorder ratioRecorded] > 15) {
        double v = ctime.value * 1.0 / ctime.timescale;
        
        if (v > minInterval) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self recorderClick];
                button.enable = TRUE;
            });
        }
        if (v > maxInterval + 0.1 || (fabs(v - preValue) < 0.01 && preValue > minInterval)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self recorderClick];
            });
            break;
        }
//        if (ctime.value <= preValue) {
//            preValue++;
//        }else{
        preValue = v;//ctime.value * 1.0 / ctime.timescale;
//        }
        [NSThread sleepForTimeInterval:0.1];
        
    }
}
-(void)recorderClick{
    if(!isRecording){
        isRecording = true;
        [_recorder record];
        button.state = LeafButtonStateSelected;
        button.enable = FALSE;
        
//        startTime = [NSDate date];
        
//        void (^updateTime)() = ^{
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//            });
        
            [[[NSThread alloc] initWithTarget:self selector:@selector(updateTimeAction:) object:nil] start];
            
        //};
        
    }else{
        CMTime time = _recorder.session.duration;
        if (time.value * 1.0 / time.timescale > minInterval) {
            isRecording = false;
            button.state = LeafButtonStateNormal;
//            [_recorder pause];
//            [self saveVideo];
            
            
            __block MRProgressOverlayView *progressView = [MRProgressOverlayView new];
            progressView.mode = MRProgressOverlayViewModeIndeterminateSmallDefault;
            [self.view addSubview:progressView];
            progressView.titleLabelText = @"正在生成视频...";
            [progressView show:TRUE];
            
            [_recorder pause:^{
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
                dispatch_after(popTime , dispatch_get_main_queue(), ^{
                    [self saveVideo];
                });
                
            }];
        }else{
            button.state = LeafButtonStateSelected;
        }
    }
}
- (void)handleTouchDetected:(SCTouchDetector*)touchDetector {
    //NSLog(@"-------------------------");
    if (touchDetector.state == UIGestureRecognizerStateBegan) {
        //_ghostImageView.hidden = YES;
        [_recorder record];
    } else if (touchDetector.state == UIGestureRecognizerStateEnded) {
//        [_recorder pause];
//        [self saveVideo];
        [_recorder pause:^{
            [self saveVideo];
        }];
    }
}

- (void)saveAndShowSession:(SCRecordSession *)recordSession {
    [[SCRecordSessionManager sharedInstance] saveRecordSession:recordSession];
    
    _recordSession = recordSession;
    //[self showVideo];
}

-(void)saveVideo{
    
    CMTime currentTime = kCMTimeZero;
    
    if (_recorder.session != nil) {
        currentTime = _recorder.session.duration;
    }
    currentTime.value = currentTime.value - 3 * currentTime.timescale / 10;
//    _recorder.maxRecordDuration = currentTime;
    _recordSession = _recorder.session;
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:_recordSession.assetRepresentingSegments];
    //exportSession.videoConfiguration.
    exportSession.videoConfiguration.filter = [SCFilter emptyFilter];
    //exportSession.videoConfiguration.preset = SCPresetHighestQuality;
    exportSession.audioConfiguration.preset = SCPresetMediumQuality;
    exportSession.videoConfiguration.maxFrameRate = 30;
    //NSLog(@"_recordSession.outputUrl:%@",_recordSession.outputUrl);
    exportSession.outputUrl = _recordSession.outputUrl;
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
    
    SCEmptyOverlayView *overlay = [[SCEmptyOverlayView alloc] init];
    overlay.date = _recordSession.date;
    
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
    
    
    __weak CameraViewController * wself = self;
    
    void(^completionHandler)(NSURL *url, NSError *error) = ^(NSURL *url, NSError *error) {
        //NSLog(@"**********************************");
        //        if (error == nil) {
        //            //UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        //        } else {
        //            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        //
        //            [[[UIAlertView alloc] initWithTitle:@"Failed to save" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        //        }
        
        //outputFile = _recordSession.outputUrl;
        CameraViewController * sself = wself;
        sself->outputFile = sself->_recordSession.outputUrl;
        [wself back:nil];
    };
    
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
//        [UIView animateWithDuration:0.3 animations:^{
//            //self.exportView.alpha = 0;
//        }];
        
        completionHandler(exportSession.outputUrl, exportSession.error);
    }];
}


- (void)prepareSession {
    if (_recorder.session == nil) {
        
        SCRecordSession *session = [SCRecordSession recordSession];
        //session.fileType = AVFileTypeQuickTimeMovie;
        session.fileType = AVFileTypeMPEG4;
        
        _recorder.session = session;
    }
    
    //[self updateTimeRecordedLabel];
    //[self updateGhostImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self prepareSession];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_recorder previewViewFrameChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_recorder startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_recorder stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end



//@interface CameraViewController()
//
//-(void)setResult:(void(^)(NSURL * file))result;
//
//@end

