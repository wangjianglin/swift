////
////  ImagesView.m
////  LinCore
////
////  Created by lin on 8/1/15.
////  Copyright (c) 2015 lin. All rights reserved.
////
//
//#import <MediaPlayer/MediaPlayer.h>
//#import "ImagesView.h"
//#import "ImageViews.h"
//#import "UILabels.h"
//#import "CameraViewController.h"
//#import "QBImagePickerController.h"
////#import "UIViews.h"
//#import "Vedios.h"
//
//@class ImagesViewAddVedioCollectionViewCell;
//
//@interface ImagesView ()<UICollectionViewDelegate,UICollectionViewDataSource,QBImagePickerControllerDelegate,UIActionSheetDelegate>{
//    UICollectionView * _collectionView;
//    UICollectionViewCell * _cellImage;
//    ImagesViewAddVedioCollectionViewCell * _cellVideo;
//    NSMutableArray * _imagePaths;
//    UICollectionViewFlowLayout * _flowLayout;
//    NSURL * _vedioUrl;
//    NSLayoutConstraint * heightConstraint;
//    UIImage * _vedioImage;
//    
//    VedioConvert * _vc;
//}
//
//-(void)delete:(long)pos;
//
//@end
//
//@interface ImagesViewAddImageCollectionViewCell : UICollectionViewCell{
//    UIImageView * _dashImageView;
//}
//@end
//
//@implementation ImagesViewAddImageCollectionViewCell
//
//-(instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self initView];
//    }
//    return self;
//}
//
//-(void)initView{
//    
//    self.backgroundColor = [UIColor clearColor];
//    
//    _dashImageView = [[UIImageView alloc]init];
//    [self addSubview:_dashImageView];
//    
//    _dashImageView.frame = CGRectMake(10, 5, self.bounds.size.width - 20, self.bounds.size.width-20);
//    _dashImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    
//    FillImageView * iconImage = [[FillImageView alloc] init];
//    
//    iconImage.image = @"LinCore.bundle/camera/camera_icon_image.png";
//    
//    iconImage.frame = CGRectMake(15, 10, _dashImageView.frame.size.width - 10, _dashImageView.frame.size.width - 10);
//    iconImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    [self addSubview:iconImage];
//    
//    LinUILabel * label = [[LinUILabel alloc] init];
//    
//    label.frame = CGRectMake(0, self.bounds.size.height - 20, self.bounds.size.width, 18);
//    
//    label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
//    label.text = @"图片(必选)";
//    label.textColor = [[UIColor alloc] initWithRed:0x7b/255.0 green:0x7b/255.0 blue:0x7b/255.0 alpha:1.0];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.verticalAlignment = VerticalAlignmentMiddle;
//    
//    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    [self addSubview:label];
//    
//    
//    
//    //虚线框 结束
//}
//
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    
//    
//    CGSize size = _dashImageView.bounds.size;
//    
//    UIGraphicsBeginImageContext(size);   //开始画线
//    [_dashImageView.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
//    
//    
//    CGFloat lengths[] = {6,3};
//    CGContextRef line = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(line, [UIColor grayColor].CGColor);
//    
//    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
//    CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
//    CGContextAddLineToPoint(line, size.width, 0.0);
//    CGContextAddLineToPoint(line, size.width, size.height);
//    CGContextAddLineToPoint(line, 0.0, size.height);
//    CGContextAddLineToPoint(line, 0.0, 0.0);
//    
//    CGContextStrokePath(line);
//    
//    _dashImageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    
//}
//@end
//
//
//
//@interface ImagesViewAddVedioCollectionViewCell : UICollectionViewCell{
//    UIImageView * _dashImageView;
//    LinUILabel * _label;
//    FillImageView * _imageView;
//}
//
//-(void)setVedioImage:(UIImage*)image;
//@end
//
//@implementation ImagesViewAddVedioCollectionViewCell
//
//
//-(void)setVedioImage:(UIImage *)image{
//    if (_imageView.image == image) {
//        return;
//    }
//    _imageView.image = image;
//    if (image == nil) {
//        _imageView.hidden = TRUE;
//        _label.hidden = FALSE;
//        _dashImageView.hidden = FALSE;
//    }else{
//        _imageView.hidden = FALSE;
//        _label.hidden = TRUE;
//        _dashImageView.hidden = TRUE;
//    }
//}
//
//-(instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self initView];
//    }
//    return self;
//}
//
//-(void)initView{
//    
//        self.backgroundColor = [UIColor clearColor];
//    
//    _dashImageView = [[UIImageView alloc]init];
//    [self addSubview:_dashImageView];
//    
//    _dashImageView.frame = CGRectMake(10, 5, self.bounds.size.width - 20, self.bounds.size.width-20);
//    _dashImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    
//    
//    FillImageView * iconImage = [[FillImageView alloc] init];
//    
//    iconImage.image = @"LinCore.bundle/camera/camera_icon_camera.png";
//    
//    iconImage.frame = CGRectMake(15, 10, _dashImageView.frame.size.width - 10, _dashImageView.frame.size.width - 10);
//    iconImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    [self addSubview:iconImage];
//    
//    
//     _label = [[LinUILabel alloc] init];
//    
//    _label.frame = CGRectMake(0, self.bounds.size.height - 20, self.bounds.size.width, 18);
//    
//    _label.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
//    _label.text = @"视频(可选)";
//    _label.textAlignment = NSTextAlignmentCenter;
//    _label.verticalAlignment = VerticalAlignmentMiddle;
//    _label.textColor = [[UIColor alloc] initWithRed:0x7b/255.0 green:0x7b/255.0 blue:0x7b/255.0 alpha:1.0];
//    
//    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    [self addSubview:_label];
//    
//    _imageView = [[FillImageView alloc] init];
//    
//    [self addSubview:_imageView];
//    
//    _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//    
//    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    _imageView.hidden = TRUE;
//    
//    //虚线框 结束
//}
//
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    
//    
//    CGSize size = _dashImageView.bounds.size;
//    
//    UIGraphicsBeginImageContext(size);   //开始画线
//    [_dashImageView.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
//    
//    
//    CGFloat lengths[] = {6,3};
//    CGContextRef line = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(line, [UIColor grayColor].CGColor);
//    
//    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
//    CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
//    CGContextAddLineToPoint(line, size.width, 0.0);
//    CGContextAddLineToPoint(line, size.width, size.height);
//    CGContextAddLineToPoint(line, 0.0, size.height);
//    CGContextAddLineToPoint(line, 0.0, 0.0);
//    
//    CGContextStrokePath(line);
//    
//    _dashImageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    
//}
//@end
//
//@interface ImagesViewUICollectionViewCell : UICollectionViewCell{
//    FillImageView * _imageView;
//}
//
////@property NSObject * imagePath;
//
//@property NSObject * image;
//
//@property ImageFill fill;
//
//@property long pos;
//
//@property(nonatomic,assign) ImagesView * imagesView;
//
//@end
//
//@implementation ImagesViewUICollectionViewCell
//
////-(NSObject *)imagePath{
////    return _imagePath;
////}
//
////-(void)setImagePath:(NSObject *)imagePath{
////    if (_imagePath == imagePath) {
////        return;
////    }
////    _imageView.image = imagePath;
////}
//
//-(NSObject *)image{
//    return _imageView.image;
//}
//
//-(void)setImage:(NSObject *)image{
//    if (_imageView.image == image) {
//        return;
//    }
//    _imageView.image = image;
//}
//
//-(ImageFill)fill{
//    return _imageView.fill;
//}
//
//-(void)setFill:(ImageFill)fill{
//    _imageView.fill = fill;
//}
//
//
//
//-(instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    
//    if (self) {
//        self.contentView.backgroundColor = [UIColor clearColor];
//        
//        _imageView = [[FillImageView alloc] init];
//        
////        __weak ImagesViewUICollectionViewCell * wself = self;
//        
////        _imageView.imageChanged = ^{
////            [wself update];
////        };
////        _imageView.backgroundColor = [UIColor greenColor];
//        _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        
//        [self addSubview:_imageView];
//        
//        UIImageView * minusImageView = [[UIImageView alloc] init];
//        
//        minusImageView.image = [UIImage imageNamed:@"LinCore.bundle/QBImagePickerController/minus.png"];
//        [minusImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)]];
//        minusImageView.userInteractionEnabled = TRUE;
//        [self addSubview:minusImageView];
//        
//        [minusImageView setTranslatesAutoresizingMaskIntoConstraints:FALSE];
//        
//        [self addConstraints:
//         @[[NSLayoutConstraint constraintWithItem:minusImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10.0],
//           [NSLayoutConstraint constraintWithItem:minusImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0]]];
//    }
//    
//    return self;
//}
//
//-(void)deleteImage:(id)_{
//    [self.imagesView delete:self.pos];
//
//}
//
//
//@end
//
//
//
//
//
//
//@implementation ImagesView
//
//-(void)delete:(long)pos{
//    [_imagePaths removeObjectAtIndex:pos];
//    [_collectionView reloadData];
//}
//-(NSURL *)vedioUrl{
//    return _vedioUrl;
//}
//
//-(UIImage *)vedioImage{
//    return _vedioImage;
//}
//
//-(void)setVedioImage:(UIImage *)vedioImage{
//    _vedioImage = vedioImage;
//    [_cellVideo setVedioImage:_vedioImage];
//}
//
//-(void)setVedioUrl:(NSURL *)vedioUrl{
//    if (_vedioUrl == vedioUrl) {
//        return;
//    }
//    _vedioUrl = vedioUrl;
//    [self setVedioImage];
//}
//
//-(NSArray *)images{
//    return [[NSArray alloc] initWithArray:_imagePaths];
//}
//
//-(void)setImages:(NSArray *)imagePaths{
//    _imagePaths = [[NSMutableArray alloc] initWithArray:imagePaths];
//    [_collectionView reloadData];
//}
//
//-(instancetype)init{
//    self = [super init];
//    
//    if (self) {
//        //层声明实列化
//        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        [_flowLayout setItemSize:CGSizeMake(50,50)]; //设置每个cell显示数据的宽和高必须
//        //[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //水平滑动
//        [_flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
//        _flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//        
//        //创建一屏的视图大小
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, 320, 380) collectionViewLayout:_flowLayout];  //搜索
//        _collectionView.backgroundColor = [UIColor clearColor];
//        //对Cell注册(必须否则程序会挂掉)
//        [_collectionView registerClass:[ImagesViewUICollectionViewCell class] forCellWithReuseIdentifier:@"_ImagesViewUICollectionViewCell_"];
//        [_collectionView registerClass:[ImagesViewAddImageCollectionViewCell class] forCellWithReuseIdentifier:@"_ImagesViewAddImageCollectionViewCell_"];
//        [_collectionView registerClass:[ImagesViewAddVedioCollectionViewCell class] forCellWithReuseIdentifier:@"_ImagesViewAddVedioCollectionViewCell_"];
//        
//        
//        //collectionView = [[UICollectionView alloc] init];
//        
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        
//        [self addSubview:_collectionView];
//        
//        [_collectionView setTranslatesAutoresizingMaskIntoConstraints:FALSE];
//        
//        
//        [self addConstraints:
//         @[[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
//           [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0],
//           [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0],
//           [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]
//           ]];
//        
//    }
//    
//    return self;
//}
//
//-(void)vedioPacker{
//    
//    QBImagePickerController * imagePickerController = [[QBImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    //    imagePickerController.filterType = QBImagePickerFilterTypeAllPhotos;
//    imagePickerController.filterType = QBImagePickerFilterTypeAllVideos;
//    imagePickerController.allowsMultipleSelection = FALSE;
//    //    uint maxSelection = 0;
//    //        for (NSObject * item in self.imagePaths) {
//    //    NSObject * item = nil;
//    //    for (int n=0; n<self.imagePaths.count; n++) {
//    //        item = self.imagePaths[n];
//    //        if ((item == nil || [item isKindOfClass:[NSNull class]]) && [views[n+videoCount] isKindOfClass:[LinImagesContentView class]] &&
//    //            ((LinImagesContentView*)views[n+videoCount]).image == nil
//    //            //&&
//    //            //(((LinImagesContentView*)views[n])->_imagePath == nil || [((LinImagesContentView*)views[n])->_imagePath isKindOfClass:[NSNull class]])
//    //            ) {
//    //            maxSelection++;
//    //        }
//    //    }
//    //    if ((self.imagePaths[index] != nil && ![self.imagePaths[index] isKindOfClass:[NSNull class]])
//    //        || ((LinImagesContentView*)views[_currentItem]).image != nil)
//    //    {
//    //        maxSelection++;
//    //    }
//    imagePickerController.maximumNumberOfSelection = 10 - _imagePaths.count;
//    imagePickerController.limitsMaximumNumberOfSelection = TRUE;
//    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
//    [[self viewController] presentViewController:navigationController animated:TRUE completion:nil];
//}
//
//
//
//-(void)imagePacker:(id)_{
//    
//    QBImagePickerController * imagePickerController = [[QBImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    imagePickerController.filterType = QBImagePickerFilterTypeAllPhotos;
////    imagePickerController.filterType = QBImagePickerFilterTypeAllVideos;
//    imagePickerController.allowsMultipleSelection = TRUE;
////    uint maxSelection = 0;
//    //        for (NSObject * item in self.imagePaths) {
////    NSObject * item = nil;
////    for (int n=0; n<self.imagePaths.count; n++) {
////        item = self.imagePaths[n];
////        if ((item == nil || [item isKindOfClass:[NSNull class]]) && [views[n+videoCount] isKindOfClass:[LinImagesContentView class]] &&
////            ((LinImagesContentView*)views[n+videoCount]).image == nil
////            //&&
////            //(((LinImagesContentView*)views[n])->_imagePath == nil || [((LinImagesContentView*)views[n])->_imagePath isKindOfClass:[NSNull class]])
////            ) {
////            maxSelection++;
////        }
////    }
////    if ((self.imagePaths[index] != nil && ![self.imagePaths[index] isKindOfClass:[NSNull class]])
////        || ((LinImagesContentView*)views[_currentItem]).image != nil)
////    {
////        maxSelection++;
////    }
//    imagePickerController.maximumNumberOfSelection = 10 - _imagePaths.count;
//    imagePickerController.limitsMaximumNumberOfSelection = TRUE;
//    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
//    [[self viewController] presentViewController:navigationController animated:TRUE completion:nil];
//}
//
//
//- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info{
//    
//    if (imagePickerController.filterType == QBImagePickerFilterTypeAllVideos) {
//        
//        NSLog(@"===============");
//        
//        NSDictionary * dict = info;
//        UIImage * image = dict[@"UIImagePickerControllerOriginalImage"];
//        NSURL * url = dict[@"UIImagePickerControllerReferenceURL"];
//        
//        _vc = [[VedioConvert alloc] initWithURL:url];
//        
//        __weak ImagesView * wself = self;
//        
//        [_vc setCompleteAction:^(NSURL *url) {
//            ImagesView * sself = wself;
//            sself->_vedioUrl = url;
//            sself->_vedioImage = image;
//            [sself->_cellVideo setVedioImage:image];
////            NSLog(@"url:%@",url);
//        }];
//        [_vc start:[self viewController].view];
////        _vedioUrl = url;
//    }
//    else if (imagePickerController.allowsMultipleSelection) {
//        NSArray * mediaInfoArray = (NSArray*)info;
//        if (_imagePaths == nil) {
//            _imagePaths = [[NSMutableArray alloc] init];
//        }
////        [_imagePaths addObjectsFromArray:mediaInfoArray];
////        int start = [self currentItem];
//        for (NSDictionary * item in mediaInfoArray) {
////            while (!([views[start % views.count] isKindOfClass:[LinImagesContentView class]]) || (
////                                                                                                  ((LinImagesContentView*)views[start % views.count]).image != nil &&
////                                                                                                  ![((LinImagesContentView*)views[start % views.count]).image isKindOfClass:[NSNull class]] && start != [self currentItem]))
////            {
////                start++;
////            }
//            UIImage * image = (UIImage*)(item[@"UIImagePickerControllerOriginalImage"]);
//            [_imagePaths addObject:image];
////            ((LinImagesContentView*)views[start%views.count]).image = image;
////            ((LinImagesContentView*)views[start%views.count]).tag = 2;
////            start++;
//        }
//        [_collectionView reloadData];
//    }
//    
//    [imagePickerController dismissViewControllerAnimated:TRUE completion:nil];
//    
//}
//
//-(void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
//    [imagePickerController dismissViewControllerAnimated:TRUE completion:nil];
//}
//
//-(NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController{
//    return @"选择所有";
//}
//
//-(NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController{
//    return @"取消所有选择";
//}
//
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wformat-security"
//-(NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos{
//    return [[NSString alloc] initWithFormat:@"共有%lu张照片",(unsigned long)numberOfPhotos];
//}
//
//-(NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos{
//    return [[NSString alloc] initWithFormat:@"共有%lu个视频",(unsigned long)numberOfVideos];
//}
//
//- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos{
//    return [[NSString alloc] initWithFormat:@"共有%d张照片，%lu个视频",(int)numberOfPhotos,(unsigned long)numberOfVideos];
//}
//#pragma clang diagnostic pop
//
//
//#pragma mark video
//
//
//-(void)movieFinishedCallback:(id)sender{
//    MPMoviePlayerController * playerViewController = ((NSNotification*)sender).object;
//    //    playerViewController view
//    //    [playerViewController removeFromParentViewController];
//    [playerViewController.view removeFromSuperview];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    
////    self.navigationController.navigationBar.hidden = FALSE;
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    //    NSLog(@"index:%ld",buttonIndex);
//    
//    NSString * title = [actionSheet buttonTitleAtIndex:buttonIndex];
//    
//    //if (buttonIndex == 0 && _vedioUrl != nil) {
//    if ([@"播放" isEqualToString:title]) {
//        
//        //播放
//        //NSURL * url = [NSURL URLWithString:@"http://i.feicuibaba.com/test.mp4"];
//        
//        MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:_vedioUrl];
//        
//        [self.rootViewController addChildViewController:playerViewController];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:)
//                                                     name:MPMoviePlayerPlaybackDidFinishNotification
//                                                   object:[playerViewController moviePlayer]];
//        //-- add to view---
//        [self.rootViewController.view addSubview:playerViewController.view];
//        
//        //playerViewController.view.frame = CGRectMake(20, 20, 200, 300);
//        
//        //playerViewController.
//        
//        //---play movie---
//        MPMoviePlayerController *player = [playerViewController moviePlayer];
//        
//        //player.contentURL = [NSURL URLWithString:@"http://i.feicuibaba.com/test.mp4"];
//        
//        [player prepareToPlay];
//        //self.navigationController.navigationBar.hidden = TRUE;
//    //}else if((buttonIndex == 0 && _vedioUrl == nil) || (buttonIndex == 1 && _vedioUrl != nil)){
//    }else if ([@"重新拍摄" isEqualToString:title]) {
//        [self recordVedio];
//    //}else if((buttonIndex == 1 && _vedioUrl == nil) || (buttonIndex == 2 && _vedioUrl != nil)){
//    }else if ([@"选取一个视频" isEqualToString:title]) {
//        [self vedioPacker];
//    }
//}
//
//-(void)imageVideo:(id)_{
//    
//    if (_vedioUrl != nil) {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                      initWithTitle:nil
//                                      delegate:self
//                                      cancelButtonTitle:@"取消"
//                                      destructiveButtonTitle:nil
////                                      otherButtonTitles:@"播放",@"重新拍摄", @"选取一个视频",nil];
//                                      otherButtonTitles:@"播放",@"重新拍摄",nil];
//        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//        [actionSheet showInView:self];
//    }else{
////        UIActionSheet *actionSheet = [[UIActionSheet alloc]
////                                      initWithTitle:nil
////                                      delegate:self
////                                      cancelButtonTitle:@"取消"
////                                      destructiveButtonTitle:nil
////                                      otherButtonTitles:@"拍摄",@"选取一个视频", nil];
////        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
////        [actionSheet showInView:self];
//        [self recordVedio];
//    }
//
//}
//-(void)recordVedio{
//    __weak ImagesView * wself = self;
//    CameraViewController * camera = [[CameraViewController alloc] init];
//    
//    [camera setResult:^(NSURL *file) {
////        NSLog(@"file:%@",file);
//        //                player.contentURL = file;
//        //                [player play];
//        if (file == nil) {
//            return ;
//        }
//        
//        ImagesView * sself = wself;
//        sself.vedioUrl = file;
//    }];
//    [[self viewController] presentViewController:camera animated:TRUE completion:nil];
//    return;
//}
//
//-(void)setVedioImage{
//    
//    
//    
//    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
//    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:_vedioUrl options:opts];
//    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
//    generator.appliesPreferredTrackTransform = YES;
//    generator.maximumSize = CGSizeMake(480, 480);
//    NSError *error = nil;
//    //CMTime * actualTime = [[CMTime alloc] init];
//    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:&error];
//    if (error == nil)
//    {
//        _vedioImage = [UIImage imageWithCGImage:img];
//        //use "img" to ooxx........
//        //            w->vedioImage.frame = dashImageView.frame;
//        //            w->vedioImage.image = [UIImage imageWithCGImage:img];
//        //            [datas addObject:UIImageJPEGRepresentation([UIImage imageWithCGImage:img], 0.6)];
//        //            goods.goods_video_img = [[NSString alloc] initWithFormat:@"%@/%@.jpg",path,[self uuidString]];
//        //            [keys addObject:goods.goods_video_img];
//    }else{
//        _vedioImage = nil;
//    }
//    
//    [_cellVideo setVedioImage:_vedioImage];
//}
//
////-(void)imageVideo:(id)_{
////    __weak ImagesView * wself = self;
////    CameraViewController * camera = [[CameraViewController alloc] init];
////    //CameraViewController
////    //self dismissViewControllerAnimated:<#(BOOL)#> completion:<#^(void)completion#>
////    //[self presentViewController:]
////    [camera setResult:^(NSURL *file) {
////        NSLog(@"file:%@",file);
//////        player.contentURL = file;
//////        [player play];
//////        LinImagesView * w = wself;
//////        w->_vedioUrl = file;
////    }];
////    [[self viewController] presentViewController:camera animated:TRUE completion:nil];
////    return;
////}
//
//
//#pragma mark data source
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSInteger row = [_imagePaths count];
//    if (row == 10) {
//        row += 1;
//    }else{
//        row += 2;
//    }
//    [self resetLayout];
//    
//    return row;
//}
//
//// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
////    return [[ImagesViewUICollectionViewCell alloc] init];
//    if (indexPath.row == 0) {
//        
//        if (_cellVideo == nil) {
//            _cellVideo = [collectionView dequeueReusableCellWithReuseIdentifier:@"_ImagesViewAddVedioCollectionViewCell_" forIndexPath:indexPath];
//        
//            [_cellVideo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageVideo:)]];
//        }
//        
//        return _cellVideo;
//    }
//    
//    if (indexPath.row == _imagePaths.count + 1) {
//        
////        if (_cellImage == nil) {
//            _cellImage = [collectionView dequeueReusableCellWithReuseIdentifier:@"_ImagesViewAddImageCollectionViewCell_" forIndexPath:indexPath];
//            
//            [_cellImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePacker:)]];
////        }
//        return _cellImage;
//    }
//    
//    static NSString * CellIdentifier = @"_ImagesViewUICollectionViewCell_";
//    ImagesViewUICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    
////    int r = indexPath.row + 5;
////    cell.backgroundColor = [UIColor colorWithRed:((10 * r) / 255.0) green:((20 * r)/255.0) blue:((30 * r)/255.0) alpha:1.0f];
//    
//    cell.image = _imagePaths[indexPath.row -1];
//    cell.pos = indexPath.row -1;
//    cell.imagesView = self;
//    return cell;
//    
//}
//
//#pragma mark view
//
//-(void)layoutSubviews{
//    [_flowLayout setItemSize:CGSizeMake(self.bounds.size.width / 4 - 10, self.bounds.size.width / 4)];
//    [self resetLayout];
//    [super layoutSubviews];
//}
//
//-(void)resetLayout{
//    
//    double h = self.bounds.size.width / 4 + 10;
//    
//    int row = (int)[_imagePaths count] + 2;
//    if (heightConstraint != nil) {
//        [self removeConstraint:heightConstraint];
//    }
//    heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:h * ((row + 3) / 4)];
//    [self addConstraint:heightConstraint];
//}
//@end
