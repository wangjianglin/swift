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
#import "MRProgressOverlayView.h"

#define kVideoPreset AVCaptureSessionPresetHigh

@interface CameraViewController ()<SCRecorderDelegate, SCAssetExportSessionDelegate>{
    SCRecorder *_recorder;
    SCRecordSession *_recordSession;
    UIButton * cancelButton;
    UIButton * setButton;
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
@property (nonatomic)UIView *focusViews;
@property (nonatomic)BOOL canCa;
@property(nonatomic)AVCaptureDevice *device;


@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _canCa = [self canUserCamear];
    if (_canCa) {
        
        [self customUI];
        
    }else{
        [self setUI];
    }
}
- (instancetype)initWithMaxInterval:(NSTimeInterval)interval{
    
    self = [super init];
    if (self != nil) {
        minInterval = 30.0;
        maxInterval = interval;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        maxInterval = 10.0;
        maxInterval = 15.0;
    }
    return self;
}


- (void)setUI {
    
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:0.02 green:0.02 blue:0.02 alpha:1.0];
    
    UIView * previewView = [[UIView alloc] init];
    CGRect rect = CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width - 40)/2.0, self.view.bounds.size.width, self.view.bounds.size.width);
    previewView.frame = rect;
    previewView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:previewView];
    
    
    setButton = [[UIButton alloc]init];
    [setButton setTitle:@"开打相机" forState:UIControlStateNormal];
    setButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    setButton.frame = CGRectMake(previewView.frame.size.width / 2  , (previewView.frame.size.height - 40 )/ 2, 90, 45);
    setButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:17.0];
    [setButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setCarmer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setButton];
    
    cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(0, self.view.bounds.size.height - 70, 90, 45);
    cancelButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16.0];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancelButton];
    
    
    
}


- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}

- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    
    if ( [_device lockForConfiguration:nil]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusViews.center = point;
        _focusViews.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusViews.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusViews.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusViews.hidden = YES;
            }];
        }];
    }
    
}

- (void)customUI{
    
    isRecording = false;
    
//    minInterval = 10.0;
//    maxInterval = 15.0;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:0.02 green:0.02 blue:0.02 alpha:1.0];
    
    UIView * previewView = [[UIView alloc] init];
    CGRect rect = CGRectMake(0, (self.view.bounds.size.height - self.view.bounds.size.width - 40)/2.0, self.view.bounds.size.width, self.view.bounds.size.width);
    previewView.frame = rect;
    previewView.backgroundColor = [[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];;
    [self.view addSubview:previewView];
    
    _focusViews = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusViews.layer.borderWidth = 1.0;
    _focusViews.layer.borderColor =[UIColor greenColor].CGColor;
    _focusViews.backgroundColor = [UIColor clearColor];
    [previewView addSubview:_focusViews];
    _focusViews.hidden = YES;
    
    
    _recorder = [SCRecorder recorder];
    
    _recorder.audioConfiguration.enabled = FALSE;
    
    _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    _recorder.maxRecordDuration = CMTimeMake(15, 1);
    _recorder.flashMode = SCFlashModeOff;
    
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = YES;
    
    _recorder.previewView = previewView;
    
    NSError *error;
    if (![_recorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
    
    
    button = [[LeafButton alloc] initWithFrame:CGRectMake(80, 80, 80, 80)];
    button.tag = 100;
    button.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - 50);
    button.type=LeafButtonTypeVideo;
    
    __weak CameraViewController * wself = self;
    [button setClickedBlock:^(LeafButton *button) {
        
        [wself recorderClick];
    }];
    
    [self.view addSubview:button];
    
    
    //CGRect frame = CGRectMake(10, 70, 60, 30);
    cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(0, self.view.bounds.size.height - 70, 90, 45);
    cancelButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16.0];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancelButton];
    
    NSBundle * b = [NSBundle bundleForClass:[self class]];
    
    UIButton * cameraButton = [[UIButton alloc] init];
    cameraButton.frame = CGRectMake(self.view.frame.size.width - 75, 20, 60, 35);
    [cameraButton setImage:[UIImage imageNamed:@"LinCore.bundle/camera/capture_flip.png" inBundle:b compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(switchCameraMode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraButton];
    
    
    flashButton = [[UIButton alloc] init];
    flashButton.frame = CGRectMake(5, 20, 60, 35);
    [flashButton setImage:[UIImage imageNamed:@"LinCore.bundle/camera/camera_icon_toggle_flash.png" inBundle:b compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [flashButton setTitle:@"  关" forState:UIControlStateNormal];
    flashButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14.0];
    
    [flashButton addTarget:self action:@selector(switchFlash:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:flashButton];
    
    
    timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"00:00:00";
    timeLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14.0];
    timeLabel.frame = CGRectMake(0, 20, self.view.bounds.size.width, 30);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:timeLabel];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [previewView addGestureRecognizer:tapGesture];
    
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [_device lockForConfiguration:nil];
    if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
        [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
    }
    [_device unlockForConfiguration];
    
    
    
}


#pragma mark - 检查相机权限
- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        
        return NO;
    }
    
    else{
        return YES;
    }
    return YES;
}

// 监听焦距发生改变
-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    
    if([keyPath isEqualToString:@"adjustingFocus"]){
        BOOL adjustingFocus =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
        NSLog(@"adjustingFocus~~%d  change~~%@", adjustingFocus, change);
    }
}

-(void)setCarmer:(UIButton*)_{
    
    
    NSURL *settingUrl = [NSURL URLWithString: UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:settingUrl];
    
}

- (void)switchCameraMode:(id)sender {
    [_recorder switchCaptureDevices];
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
        double v = ctime.value * 1.0 / ctime.timescale;
        if (v > minInterval) {
            dispatch_async(dispatch_get_main_queue(), ^{
                button.enable = TRUE;
            });
        }
        if (v > maxInterval + 0.1 || (fabs(v - preValue) < 0.01 && preValue > minInterval)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self recorderClick];
            });
            break;
        }
        preValue = v;
        [NSThread sleepForTimeInterval:0.1];
        
    }
}
-(void)recorderClick{
    if(!isRecording){
        isRecording = true;
        [_recorder record];
        button.state = LeafButtonStateSelected;
        button.enable = FALSE;
        [[[NSThread alloc] initWithTarget:self selector:@selector(updateTimeAction:) object:nil] start];
    }else{
        CMTime time = _recorder.session.duration;
        if (time.value * 1.0 / time.timescale > minInterval) {
            isRecording = false;
            button.state = LeafButtonStateNormal;
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
    if (touchDetector.state == UIGestureRecognizerStateBegan) {
        
        [_recorder record];
    } else if (touchDetector.state == UIGestureRecognizerStateEnded) {
        [_recorder pause:^{
            [self saveVideo];
        }];
    }
}

- (void)saveAndShowSession:(SCRecordSession *)recordSession {
    [[SCRecordSessionManager sharedInstance] saveRecordSession:recordSession];
    
    _recordSession = recordSession;
}

-(void)saveVideo{
    
    CMTime currentTime = kCMTimeZero;
    
    if (_recorder.session != nil) {
        currentTime = _recorder.session.duration;
    }
    currentTime.value = currentTime.value - 3 * currentTime.timescale / 10;
    _recordSession = _recorder.session;
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:_recordSession.assetRepresentingSegments];
    exportSession.videoConfiguration.filter = [SCFilter emptyFilter];
    exportSession.audioConfiguration.preset = SCPresetMediumQuality;
    exportSession.videoConfiguration.maxFrameRate = 30;
    exportSession.outputUrl = _recordSession.outputUrl;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.delegate = self;
    SCEmptyOverlayView *overlay = [[SCEmptyOverlayView alloc] init];
    overlay.date = _recordSession.date;
    
    exportSession.videoConfiguration.overlay = overlay;//水印
    
    __weak CameraViewController * wself = self;
    
    void(^completionHandler)(NSURL *url, NSError *error) = ^(NSURL *url, NSError *error) {
        CameraViewController * sself = wself;
        sself->outputFile = sself->_recordSession.outputUrl;
        [wself back:nil];
    };
    
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        completionHandler(exportSession.outputUrl, exportSession.error);
    }];
}


- (void)prepareSession {
    if (_recorder.session == nil) {
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeMPEG4;
        _recorder.session = session;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    AVCaptureDevice *camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags =NSKeyValueObservingOptionNew;
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    
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
    
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    
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


@end
