//
//  ImagesView.m
//  LinCore
//
//  Created by lin on 8/1/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import MediaPlayer
import UIKit

//@class ImagesViewAddVedioCollectionViewCell;

public class ImagesView : UIView, UICollectionViewDelegate,UICollectionViewDataSource,QBImagePickerControllerDelegate,UIActionSheetDelegate{
    private var _collectionView:UICollectionView!
    private var _cellImage:UICollectionViewCell!;
    private var _cellVideo:ImagesViewAddVedioCollectionViewCell!;
    private var _imagePaths = [AnyObject]();
    private var _flowLayout:UICollectionViewFlowLayout!;
    private var _vedioUrl:NSURL?;
    private var _heightConstraint:NSLayoutConstraint!;
    private var _vedioImage:UIImage?;
    
    private var _vc:VedioConvert!;
    
    
    private func delete(pos:Int){
        _imagePaths.removeAtIndex(pos);
        _collectionView.reloadData();
    }
    
//    public var vedioUrl:NSURL?{
//        return _vedioUrl;
//    }
//    
//    public var vedioImage:UIImage{
//        return _vedioImage;
//    }
//    
//    private func setVedioImage(vedioImage:UIImage){
//        _vedioImage = vedioImage;
//        _cellVideo.setVedioImage(_vedioImage);
//    }
    public var vedioImage:UIImage?{
        get{
            return _vedioImage;
        }
        set{
            _vedioImage = newValue;
            _cellVideo.setVedioImage(_vedioImage)
        }
    }
    
    public var vedioUrl:NSURL?{
        get{
            return _vedioUrl;
        }
        set{
            if _vedioUrl == newValue {
                return;
            }
            _vedioUrl = newValue;
            self.setVedioImage();
        }
    }
//    private func setVedioUrl(vedioUrl:NSURL){
//        if (_vedioUrl == vedioUrl) {
//            return;
//        }
//        _vedioUrl = vedioUrl;
//        self.setVedioImage();
//    }
    
    //    public var images:[String]{
    //    return _imagePaths;
    //}
    //
    //    public func setImages(imagePaths:NSArray *){
    //    _imagePaths = [[NSMutableArray alloc] initWithArray:imagePaths];
    //    [_collectionView reloadData];
    //}
    public var images:[AnyObject]{
        get{
            return _imagePaths;
        }
        set{
            _imagePaths = newValue;
            _collectionView.reloadData();
        }
    }
    
    public init(){
        
        //        super.init();
        
        //    if (self) {
        super.init(frame: CGRectMake(0, 0, 0, 0));
        //层声明实列化
        _flowLayout = UICollectionViewFlowLayout();
        _flowLayout.itemSize = CGSizeMake(50,50); //设置每个cell显示数据的宽和高必须
        //[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //水平滑动
        _flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical; //控制滑动分页用
        _flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        //创建一屏的视图大小
        _collectionView = UICollectionView(frame:CGRectMake(0, 44, 320, 380), collectionViewLayout:_flowLayout);  //搜索
        _collectionView.backgroundColor = UIColor.clearColor();
        //对Cell注册(必须否则程序会挂掉)
        _collectionView.registerClass(ImagesViewUICollectionViewCell.self, forCellWithReuseIdentifier:"_ImagesViewUICollectionViewCell_");
        _collectionView.registerClass(ImagesViewAddImageCollectionViewCell.self, forCellWithReuseIdentifier:"_ImagesViewAddImageCollectionViewCell_");
        _collectionView.registerClass(ImagesViewAddVedioCollectionViewCell.self, forCellWithReuseIdentifier:"_ImagesViewAddVedioCollectionViewCell_");
        
        
        //collectionView = [[UICollectionView alloc] init];
        
        
        self.addSubview(_collectionView);
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = false;
        
        
        self.addConstraints(
            [NSLayoutConstraint(item:_collectionView, attribute:NSLayoutAttribute.Top, relatedBy:NSLayoutRelation.Equal, toItem:self, attribute:NSLayoutAttribute.Top, multiplier:1.0, constant:0.0),
                NSLayoutConstraint(item:_collectionView, attribute:NSLayoutAttribute.Left, relatedBy:NSLayoutRelation.Equal, toItem:self, attribute:NSLayoutAttribute.Left, multiplier:1.0, constant:0.0),
                NSLayoutConstraint(item:_collectionView, attribute:NSLayoutAttribute.Right, relatedBy:NSLayoutRelation.Equal, toItem:self, attribute:NSLayoutAttribute.Right, multiplier:1.0, constant:0.0),
                NSLayoutConstraint(item:_collectionView, attribute:NSLayoutAttribute.Bottom, relatedBy:NSLayoutRelation.Equal, toItem:self, attribute:NSLayoutAttribute.Bottom, multiplier:1.0, constant:0.0)
            ]);
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    return self;
    //}
    
    private func vedioPacker(){
        
        let imagePickerController = QBImagePickerController();
        imagePickerController.delegate = self;
        //    imagePickerController.filterType = QBImagePickerFilterTypeAllPhotos;
        imagePickerController.filterType = QBImagePickerFilterTypeAllVideos;
        imagePickerController.allowsMultipleSelection = false;
        //    uint maxSelection = 0;
        //        for (NSObject * item in self.imagePaths) {
        //    NSObject * item = nil;
        //    for (int n=0; n<self.imagePaths.count; n++) {
        //        item = self.imagePaths[n];
        //        if ((item == nil || [item isKindOfClass:[NSNull class]]) && [views[n+videoCount] isKindOfClass:[LinImagesContentView class]] &&
        //            ((LinImagesContentView*)views[n+videoCount]).image == nil
        //            //&&
        //            //(((LinImagesContentView*)views[n])->_imagePath == nil || [((LinImagesContentView*)views[n])->_imagePath isKindOfClass:[NSNull class]])
        //            ) {
        //            maxSelection++;
        //        }
        //    }
        //    if ((self.imagePaths[index] != nil && ![self.imagePaths[index] isKindOfClass:[NSNull class]])
        //        || ((LinImagesContentView*)views[_currentItem]).image != nil)
        //    {
        //        maxSelection++;
        //    }
        imagePickerController.maximumNumberOfSelection = (10 - UInt(_imagePaths.count));
        imagePickerController.limitsMaximumNumberOfSelection = true;
        let navigationController = UINavigationController(rootViewController:imagePickerController);
        self.viewController?.presentViewController(navigationController, animated:true, completion:nil);
    }
    
    
    
    @objc private func imagePacker(_:NSObject){
        
        let imagePickerController = QBImagePickerController();
        imagePickerController.delegate = self;
        imagePickerController.filterType = QBImagePickerFilterTypeAllPhotos;
        //    imagePickerController.filterType = QBImagePickerFilterTypeAllVideos;
        imagePickerController.allowsMultipleSelection = true;
        //    uint maxSelection = 0;
        //        for (NSObject * item in self.imagePaths) {
        //    NSObject * item = nil;
        //    for (int n=0; n<self.imagePaths.count; n++) {
        //        item = self.imagePaths[n];
        //        if ((item == nil || [item isKindOfClass:[NSNull class]]) && [views[n+videoCount] isKindOfClass:[LinImagesContentView class]] &&
        //            ((LinImagesContentView*)views[n+videoCount]).image == nil
        //            //&&
        //            //(((LinImagesContentView*)views[n])->_imagePath == nil || [((LinImagesContentView*)views[n])->_imagePath isKindOfClass:[NSNull class]])
        //            ) {
        //            maxSelection++;
        //        }
        //    }
        //    if ((self.imagePaths[index] != nil && ![self.imagePaths[index] isKindOfClass:[NSNull class]])
        //        || ((LinImagesContentView*)views[_currentItem]).image != nil)
        //    {
        //        maxSelection++;
        //    }
        imagePickerController.maximumNumberOfSelection = 10 - UInt(_imagePaths.count);
        imagePickerController.limitsMaximumNumberOfSelection = true;
        let navigationController = UINavigationController(rootViewController:imagePickerController);
        self.viewController?.presentViewController(navigationController, animated:true, completion:nil);
    }
    
    
    @objc public func imagePickerController(imagePickerController:QBImagePickerController, didFinishPickingMediaWithInfo info:AnyObject){
        
        if (imagePickerController.filterType == QBImagePickerFilterTypeAllVideos) {
            
            //        NSLog(@"===============");
            
            let dict = info as! NSDictionary;
            let image = dict["UIImagePickerControllerOriginalImage"] as! UIImage;
            let url = dict["UIImagePickerControllerReferenceURL"] as! NSURL;
            
            _vc = VedioConvert(url:url);
            
            //        __weak ImagesView * wself = self;
            
            _vc.action = {[weak self](url:NSURL?) in
                //            ImagesView * sself = wself;
                self?._vedioUrl = url;
                self?._vedioImage = image;
                self?._cellVideo.setVedioImage(image);
                //            NSLog(@"url:%@",url);
            };
            _vc.start(self.viewController!.view);
            //        _vedioUrl = url;
        }
        else if imagePickerController.allowsMultipleSelection {
            let mediaInfoArray = info as! NSArray;
//            if (_imagePaths == nil) {
//                _imagePaths = [String]();
//            }
            //        [_imagePaths addObjectsFromArray:mediaInfoArray];
            //        int start = [self currentItem];
            for fitem in mediaInfoArray {
                //            while (!([views[start % views.count] isKindOfClass:[LinImagesContentView class]]) || (
                //                                                                                                  ((LinImagesContentView*)views[start % views.count]).image != nil &&
                //                                                                                                  ![((LinImagesContentView*)views[start % views.count]).image isKindOfClass:[NSNull class]] && start != [self currentItem]))
                //            {
                //                start++;
                //            }
                let item = fitem as! NSDictionary;
                let image = item["UIImagePickerControllerOriginalImage"] as! UIImage;
                _imagePaths.append(image);
                //            ((LinImagesContentView*)views[start%views.count]).image = image;
                //            ((LinImagesContentView*)views[start%views.count]).tag = 2;
                //            start++;
            }
            _collectionView.reloadData();
        }
        
        imagePickerController.dismissViewControllerAnimated(true, completion:nil);
        
    }
    
    public func imagePickerControllerDidCancel(imagePickerController:QBImagePickerController){
        imagePickerController.dismissViewControllerAnimated(true, completion:nil);
    }
    
    public func descriptionForSelectingAllAssets(imagePickerController:QBImagePickerController)->String{
        return "选择所有";
    }
    
    public func descriptionForDeselectingAllAssets(imagePickerController:QBImagePickerController)->String{
        return "取消所有选择";
    }
    
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Wformat-security"
    public func imagePickerController(imagePickerController:QBImagePickerController, descriptionForNumberOfPhotos numberOfPhotos:UInt)->String{
        return "共有\(numberOfPhotos)张照片";
    }
    
    public func imagePickerController(imagePickerController:QBImagePickerController, descriptionForNumberOfVideos numberOfVideos:UInt)->String{
        return "共有%\(numberOfVideos)个视频";
    }
    
    public func imagePickerController(imagePickerController:QBImagePickerController, descriptionForNumberOfPhotos numberOfPhotos:UInt, numberOfVideos:UInt)->String{
        return "共有\(numberOfPhotos)张照片，\(numberOfVideos)个视频";
    }
    
    
    //MARK: video
    
    
    public func movieFinishedCallback(sender:AnyObject){
        let playerViewController = (sender as! NSNotification).object;
        //    playerViewController view
        //    [playerViewController removeFromParentViewController];
        playerViewController?.view.removeFromSuperview();
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:MPMoviePlayerPlaybackDidFinishNotification, object:nil);
        
        //    self.navigationController.navigationBar.hidden = FALSE;
    }
    
    @objc public func actionSheet(actionSheet:UIActionSheet, clickedButtonAtIndex buttonIndex:Int){
        //    NSLog(@"index:%ld",buttonIndex);
        
        let title = actionSheet.buttonTitleAtIndex(buttonIndex);
        
        //if (buttonIndex == 0 && _vedioUrl != nil) {
        if "播放" == title {
            
            //播放
            //NSURL * url = [NSURL URLWithString:@"http://i.feicuibaba.com/test.mp4"];
            
            let playerViewController = MPMoviePlayerViewController(contentURL:_vedioUrl);
            
            self.rootViewController?.addChildViewController(playerViewController);
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(self.movieFinishedCallback),
                                                             name:MPMoviePlayerPlaybackDidFinishNotification,
                                                             object:playerViewController.moviePlayer);
            //-- add to view---
            self.rootViewController?.view.addSubview(playerViewController.view);
            
            //playerViewController.view.frame = CGRectMake(20, 20, 200, 300);
            
            //playerViewController.
            
            //---play movie---
            let player = playerViewController.moviePlayer;
            
            //player.contentURL = [NSURL URLWithString:@"http://i.feicuibaba.com/test.mp4"];
            
            player.prepareToPlay();
            //self.navigationController.navigationBar.hidden = TRUE;
            //}else if((buttonIndex == 0 && _vedioUrl == nil) || (buttonIndex == 1 && _vedioUrl != nil)){
        }else if "重新拍摄" == title {
            self.recordVedio();
            //}else if((buttonIndex == 1 && _vedioUrl == nil) || (buttonIndex == 2 && _vedioUrl != nil)){
        }else if "选取一个视频" == title {
            self.vedioPacker();
        }
    }
    
    @objc private func imageVideo(_:AnyObject){
        
        if (_vedioUrl != nil) {
            let actionSheet = UIActionSheet(title:nil,
                                            delegate:self,
                                            cancelButtonTitle:"取消",
                                            destructiveButtonTitle:nil,
                                            //                                      otherButtonTitles:@"播放",@"重新拍摄", @"选取一个视频",nil];
                otherButtonTitles:"播放","重新拍摄");
            actionSheet.actionSheetStyle = UIActionSheetStyle.BlackOpaque;
            actionSheet.showInView(self);
        }else{
            //        UIActionSheet *actionSheet = [[UIActionSheet alloc]
            //                                      initWithTitle:nil
            //                                      delegate:self
            //                                      cancelButtonTitle:@"取消"
            //                                      destructiveButtonTitle:nil
            //                                      otherButtonTitles:@"拍摄",@"选取一个视频", nil];
            //        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            //        [actionSheet showInView:self];
            self.recordVedio();
        }
        
    }
    
    private func recordVedio(){
        //    __weak ImagesView * wself = self;
        let camera = CameraViewController();
        
        camera.setResult({[weak self](file:NSURL?) in
            if (file == nil) {
                return ;
            }
            
            //        ImagesView * sself = wself;
            self?._vedioUrl = file;
        });
        self.viewController?.presentViewController(camera, animated:true, completion:nil);
        return;
    }
    
    private func setVedioImage(){
        
        
        
        //    let opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        //    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:_vedioUrl options:opts];
        let opts:[String : AnyObject]? = nil;
        
        let urlAsset = AVURLAsset(URL: _vedioUrl!, options: opts);
        
        //    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
        let generator = AVAssetImageGenerator(asset: urlAsset);
        generator.appliesPreferredTrackTransform = true;
        generator.maximumSize = CGSizeMake(480, 480);
        //    NSError *error = nil;
        //    //CMTime * actualTime = [[CMTime alloc] init];
        //    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:&error];
        let img = try? generator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil);
        if let img = img {
            _vedioImage = UIImage(CGImage:img);
            //use "img" to ooxx........
            //            w->vedioImage.frame = dashImageView.frame;
            //            w->vedioImage.image = [UIImage imageWithCGImage:img];
            //            [datas addObject:UIImageJPEGRepresentation([UIImage imageWithCGImage:img], 0.6)];
            //            goods.goods_video_img = [[NSString alloc] initWithFormat:@"%@/%@.jpg",path,[self uuidString]];
            //            [keys addObject:goods.goods_video_img];
        }else{
            _vedioImage = nil;
        }
        
        _cellVideo.setVedioImage(_vedioImage);
    }
    
    //-(void)imageVideo:(id)_{
    //    __weak ImagesView * wself = self;
    //    CameraViewController * camera = [[CameraViewController alloc] init];
    //    //CameraViewController
    //    //self dismissViewControllerAnimated:<#(BOOL)#> completion:<#^(void)completion#>
    //    //[self presentViewController:]
    //    [camera setResult:^(NSURL *file) {
    //        NSLog(@"file:%@",file);
    ////        player.contentURL = file;
    ////        [player play];
    ////        LinImagesView * w = wself;
    ////        w->_vedioUrl = file;
    //    }];
    //    [[self viewController] presentViewController:camera animated:TRUE completion:nil];
    //    return;
    //}
    
    
    //MARK: data source
    
    public func collectionView(collectionView:UICollectionView, numberOfItemsInSection section:Int)->Int{
        var row = _imagePaths.count;
        if (row == 10) {
            row += 1;
        }else{
            row += 2;
        }
        self.resetLayout();
        
        return row;
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(collectionView:UICollectionView, cellForItemAtIndexPath indexPath:NSIndexPath)->UICollectionViewCell{
        //    return [[ImagesViewUICollectionViewCell alloc] init];
        if (indexPath.row == 0) {
            
            if (_cellVideo == nil) {
                _cellVideo = collectionView.dequeueReusableCellWithReuseIdentifier("_ImagesViewAddVedioCollectionViewCell_", forIndexPath:indexPath) as! ImagesViewAddVedioCollectionViewCell;
                
                _cellVideo.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.imageVideo)));
            }
            
            return _cellVideo;
        }
        
        if (indexPath.row == _imagePaths.count + 1) {
            
            //        if (_cellImage == nil) {
            _cellImage = collectionView.dequeueReusableCellWithReuseIdentifier("_ImagesViewAddImageCollectionViewCell_", forIndexPath:indexPath);
            
            _cellImage.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.imagePacker)));
            //        }
            return _cellImage;
        }
        
        let CellIdentifier = "_ImagesViewUICollectionViewCell_";
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath:indexPath) as! ImagesViewUICollectionViewCell;
        
        //    int r = indexPath.row + 5;
        //    cell.backgroundColor = [UIColor colorWithRed:((10 * r) / 255.0) green:((20 * r)/255.0) blue:((30 * r)/255.0) alpha:1.0f];
        
        cell.image = _imagePaths[Int(indexPath.row - 1)];
        cell.pos = Int(indexPath.row - 1);
        cell.imagesView = self;
        return cell;
        
    }
    
    //MARK: view
    
    public override func layoutSubviews() {
        
        _flowLayout.itemSize = CGSizeMake(self.bounds.size.width / 4 - 10, self.bounds.size.width / 4);
        self.resetLayout();
        super.layoutSubviews();
    }
    
    private func resetLayout(){
        
        let h = self.bounds.size.width / 4 + 10;
        
        let row = CGFloat(_imagePaths.count + 2);
        if _heightConstraint != nil {
            self.removeConstraint(_heightConstraint);
        }
        _heightConstraint = NSLayoutConstraint(item:self, attribute:NSLayoutAttribute.Height, relatedBy:NSLayoutRelation.Equal, toItem:nil, attribute:NSLayoutAttribute.NotAnAttribute, multiplier:1.0, constant:h * ((row + 3) / 4));
        self.addConstraint(_heightConstraint);
    }
}


public class ImagesViewAddImageCollectionViewCell : UICollectionViewCell{
    private var _dashImageView:UIImageView!;
    
    public override init(frame:CGRect){
        super.init(frame:frame);
        
        self.initView();
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        
        self.backgroundColor = UIColor.clearColor();
        
        _dashImageView = UIImageView();
        self.addSubview(_dashImageView);
        
        _dashImageView.frame = CGRectMake(10, 5, self.bounds.size.width - 20, self.bounds.size.width-20);
        _dashImageView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleWidth.rawValue | UIViewAutoresizing.FlexibleHeight.rawValue);
        
        
        let iconImage = FillImageView();
        
//        iconImage.setFillImage("LinCore.bundle/camera/camera_icon_image.png");
        iconImage.setFillImage(UIImage(named: "LinCore.bundle/camera/camera_icon_image.png", inBundle: NSBundle(forClass:self.classForCoder), compatibleWithTraitCollection: nil));
        
        iconImage.frame = CGRectMake(15, 10, _dashImageView.frame.size.width - 10, _dashImageView.frame.size.width - 10);
        iconImage.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleWidth.rawValue | UIViewAutoresizing.FlexibleHeight.rawValue);
        
        self.addSubview(iconImage);
        
        let label = LinUILabel();
        
        label.frame = CGRectMake(0, self.bounds.size.height - 20, self.bounds.size.width, 18);
        
        label.font = UIFont(name:"STHeitiSC-Light", size:10);
        label.text = "图片(必选)";
        label.textColor = UIColor(red:0x7b/255.0, green:0x7b/255.0, blue:0x7b/255.0, alpha:1.0);
        label.textAlignment = NSTextAlignment.Center;
        label.verticalAlignment = VerticalAlignmentMiddle;
        
        label.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleWidth.rawValue | UIViewAutoresizing.FlexibleHeight.rawValue);
        
        self.addSubview(label);
        
        
        
        //虚线框 结束
    }
    
    public override func layoutSubviews() {
        
        super.layoutSubviews();
        
        
        let size = _dashImageView.bounds.size;
        
        UIGraphicsBeginImageContext(size);   //开始画线
        _dashImageView.image?.drawInRect(CGRectMake(0, 0, size.width, size.height));
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round as CGLineCap);  //设置线条终点形状
        
        
        let lengths = [CGFloat(6),CGFloat(3)];
        let line = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(line, UIColor.grayColor().CGColor);
        
        CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
        CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
        CGContextAddLineToPoint(line, size.width, 0.0);
        CGContextAddLineToPoint(line, size.width, size.height);
        CGContextAddLineToPoint(line, 0.0, size.height);
        CGContextAddLineToPoint(line, 0.0, 0.0);
        
        CGContextStrokePath(line);
        
        _dashImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
    }
}



public class ImagesViewAddVedioCollectionViewCell : UICollectionViewCell{
    private var _dashImageView:UIImageView!;
    private var _label:LinUILabel!;
    private var _imageView:FillImageView!;
    
    
    private func setVedioImage(image:UIImage?){
        if (_imageView.image == image) {
            return;
        }
        _imageView.image = image;
        if image == nil {
            _imageView.hidden = true;
            _label.hidden = false;
            _dashImageView.hidden = false;
        }else{
            _imageView.hidden = false;
            _label.hidden = true;
            _dashImageView.hidden = true;
        }
    }
    
    public override init(frame:CGRect){
        super.init(frame:frame);
        
        self.initView();
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        
        self.backgroundColor = UIColor.clearColor();
        
        _dashImageView = UIImageView();
        self.addSubview(_dashImageView);
        
        _dashImageView.frame = CGRectMake(10, 5, self.bounds.size.width - 20, self.bounds.size.width-20);
        _dashImageView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleWidth.rawValue | UIViewAutoresizing.FlexibleHeight.rawValue);
        
        
        
        let iconImage = FillImageView();
        
        //iconImage.setFillImage("LinCore.bundle/camera/camera_icon_camera.png");
        iconImage.setFillImage(UIImage(named: "LinCore.bundle/camera/camera_icon_camera.png", inBundle: NSBundle(forClass:self.classForCoder), compatibleWithTraitCollection: nil));
        
        iconImage.frame = CGRectMake(15, 10, _dashImageView.frame.size.width - 10, _dashImageView.frame.size.width - 10);
        iconImage.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleWidth.rawValue | UIViewAutoresizing.FlexibleHeight.rawValue);
        
        self.addSubview(iconImage);
        
        
        _label = LinUILabel();
        
        _label.frame = CGRectMake(0, self.bounds.size.height - 20, self.bounds.size.width, 18);
        
        _label.font = UIFont(name:"STHeitiSC-Light", size:10);
        _label.text = "视频(可选)";
        _label.textAlignment = NSTextAlignment.Center;
        _label.verticalAlignment = VerticalAlignmentMiddle;
        _label.textColor = UIColor(red:0x7b/255.0, green:0x7b/255.0, blue:0x7b/255.0, alpha:1.0);
        
        _label.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleWidth.rawValue | UIViewAutoresizing.FlexibleHeight.rawValue);
        
        self.addSubview(_label);
        
        _imageView = FillImageView();
        
        self.addSubview(_imageView);
        
        _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        
        _imageView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleWidth.rawValue | UIViewAutoresizing.FlexibleHeight.rawValue);
        
        _imageView.hidden = true;
        
        //虚线框 结束
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews();
        
        
        let size = _dashImageView.bounds.size;
        
        UIGraphicsBeginImageContext(size);   //开始画线
        _dashImageView.image?.drawInRect(CGRectMake(0, 0, size.width, size.height));
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round);  //设置线条终点形状
        
        
        let lengths = [CGFloat(6),CGFloat(3)];
        let line = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(line, UIColor.grayColor().CGColor);
        
        CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
        CGContextMoveToPoint(line, 0.0, 0.0);    //开始画线
        CGContextAddLineToPoint(line, size.width, 0.0);
        CGContextAddLineToPoint(line, size.width, size.height);
        CGContextAddLineToPoint(line, 0.0, size.height);
        CGContextAddLineToPoint(line, 0.0, 0.0);
        
        CGContextStrokePath(line);
        
        _dashImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
    }
}

class ImagesViewUICollectionViewCell : UICollectionViewCell{
    private var _imageView:FillImageView!;
    
    //@property NSObject * imagePath;
    
    //    private var image:AnyObject?;
    
//    private var fill:ImageFill = ImageFill.Fill;
    
    private var pos = 0;
    
    private var imagesView:ImagesView?;
    
    //
    //
    //@implementation ImagesViewUICollectionViewCell
    
    //-(NSObject *)imagePath{
    //    return _imagePath;
    //}
    
    //-(void)setImagePath:(NSObject *)imagePath{
    //    if (_imagePath == imagePath) {
    //        return;
    //    }
    //    _imageView.image = imagePath;
    //}
    
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
    var image:AnyObject?{
        didSet{
            if let image = image {
                _imageView.setFillImage(image)
            }
        }
    }
    
    //-(ImageFill)fill{
    //    return _imageView.fill;
    //}
    //
    //-(void)setFill:(ImageFill)fill{
    //    _imageView.fill = fill;
    //}
    var fill:ImageFill = ImageFill.Fill{
        didSet{
            _imageView.fill = fill;
        }
    }
    
    
    
    override init(frame:CGRect){
        super.init(frame:frame);
        
        //    if (self) {
        self.contentView.backgroundColor = UIColor.clearColor();
        
        _imageView = FillImageView();
        
        //        __weak ImagesViewUICollectionViewCell * wself = self;
        
        //        _imageView.imageChanged = ^{
        //            [wself update];
        //        };
        //        _imageView.backgroundColor = [UIColor greenColor];
        _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _imageView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleWidth.rawValue | UIViewAutoresizing.FlexibleHeight.rawValue);
        
        self.addSubview(_imageView);
        
        let minusImageView = UIImageView();
        
        minusImageView.image = UIImage(named:"LinCore.bundle/QBImagePickerController/minus.png", inBundle: NSBundle(forClass: self.classForCoder),compatibleWithTraitCollection: nil);
        minusImageView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.deleteImage)));
        minusImageView.userInteractionEnabled = true;
        self.addSubview(minusImageView);
        
        minusImageView.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addConstraints([NSLayoutConstraint(item:minusImageView, attribute:NSLayoutAttribute.CenterX, relatedBy:NSLayoutRelation.Equal, toItem:self, attribute:NSLayoutAttribute.Left, multiplier:1.0, constant:10.0),
            NSLayoutConstraint(item:minusImageView, attribute:NSLayoutAttribute.CenterY, relatedBy:NSLayoutRelation.Equal, toItem:self, attribute:NSLayoutAttribute.Top, multiplier:1.0, constant:10.0)]);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal func deleteImage(_:AnyObject){
        self.imagesView!.delete(self.pos);
        
    }
    
}