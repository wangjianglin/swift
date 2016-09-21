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

open class ImagesView : UIView, UICollectionViewDelegate,UICollectionViewDataSource,QBImagePickerControllerDelegate,UIActionSheetDelegate{
    fileprivate var _collectionView:UICollectionView!
    fileprivate var _cellImage:UICollectionViewCell!;
    fileprivate var _cellVideo:ImagesViewAddVedioCollectionViewCell!;
    fileprivate var _imagePaths = [AnyObject]();
    fileprivate var _flowLayout:UICollectionViewFlowLayout!;
    fileprivate var _vedioUrl:URL?;
    fileprivate var _heightConstraint:NSLayoutConstraint!;
    fileprivate var _vedioImage:UIImage?;
    
    fileprivate var _vc:VedioConvert!;
    
    
    fileprivate func delete(_ pos:Int){
        _imagePaths.remove(at: pos);
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
    open var vedioImage:UIImage?{
        get{
            return _vedioImage;
        }
        set{
            _vedioImage = newValue;
            _cellVideo.setVedioImage(_vedioImage)
        }
    }
    
    open var vedioUrl:URL?{
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
    open var images:[AnyObject]{
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
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        //层声明实列化
        _flowLayout = UICollectionViewFlowLayout();
        _flowLayout.itemSize = CGSize(width: 50,height: 50); //设置每个cell显示数据的宽和高必须
        //[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //水平滑动
        _flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical; //控制滑动分页用
        _flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        //创建一屏的视图大小
        _collectionView = UICollectionView(frame:CGRect(x: 0, y: 44, width: 320, height: 380), collectionViewLayout:_flowLayout);  //搜索
        _collectionView.backgroundColor = UIColor.clear;
        //对Cell注册(必须否则程序会挂掉)
        _collectionView.register(ImagesViewUICollectionViewCell.self, forCellWithReuseIdentifier:"_ImagesViewUICollectionViewCell_");
        _collectionView.register(ImagesViewAddImageCollectionViewCell.self, forCellWithReuseIdentifier:"_ImagesViewAddImageCollectionViewCell_");
        _collectionView.register(ImagesViewAddVedioCollectionViewCell.self, forCellWithReuseIdentifier:"_ImagesViewAddVedioCollectionViewCell_");
        
        
        //collectionView = [[UICollectionView alloc] init];
        
        
        self.addSubview(_collectionView);
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = false;
        
        
        self.addConstraints(
            [NSLayoutConstraint(item:_collectionView, attribute:NSLayoutAttribute.top, relatedBy:NSLayoutRelation.equal, toItem:self, attribute:NSLayoutAttribute.top, multiplier:1.0, constant:0.0),
                NSLayoutConstraint(item:_collectionView, attribute:NSLayoutAttribute.left, relatedBy:NSLayoutRelation.equal, toItem:self, attribute:NSLayoutAttribute.left, multiplier:1.0, constant:0.0),
                NSLayoutConstraint(item:_collectionView, attribute:NSLayoutAttribute.right, relatedBy:NSLayoutRelation.equal, toItem:self, attribute:NSLayoutAttribute.right, multiplier:1.0, constant:0.0),
                NSLayoutConstraint(item:_collectionView, attribute:NSLayoutAttribute.bottom, relatedBy:NSLayoutRelation.equal, toItem:self, attribute:NSLayoutAttribute.bottom, multiplier:1.0, constant:0.0)
            ]);
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    return self;
    //}
    
    fileprivate func vedioPacker(){
        
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
        self.viewController?.present(navigationController, animated:true, completion:nil);
    }
    
    
    
    @objc fileprivate func imagePacker(_:NSObject){
        
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
        self.viewController?.present(navigationController, animated:true, completion:nil);
    }
    
    
    @objc open func imagePickerController(_ imagePickerController:QBImagePickerController, didFinishPickingMediaWithInfo info:AnyObject){
        
        if (imagePickerController.filterType == QBImagePickerFilterTypeAllVideos) {
            
            //        NSLog(@"===============");
            
            let dict = info as! NSDictionary;
            let image = dict["UIImagePickerControllerOriginalImage"] as! UIImage;
            let url = dict["UIImagePickerControllerReferenceURL"] as! URL;
            
            _vc = VedioConvert(url:url);
            
            //        __weak ImagesView * wself = self;
            
            _vc.action = {[weak self](url:URL?) in
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
        
        imagePickerController.dismiss(animated: true, completion:nil);
        
    }
    
    open func imagePickerControllerDidCancel(_ imagePickerController:QBImagePickerController){
        imagePickerController.dismiss(animated: true, completion:nil);
    }
    
    open func description(forSelectingAllAssets imagePickerController:QBImagePickerController)->String{
        return "选择所有";
    }
    
    open func description(forDeselectingAllAssets imagePickerController:QBImagePickerController)->String{
        return "取消所有选择";
    }
    
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Wformat-security"
    open func imagePickerController(_ imagePickerController:QBImagePickerController, descriptionForNumberOfPhotos numberOfPhotos:UInt)->String{
        return "共有\(numberOfPhotos)张照片";
    }
    
    open func imagePickerController(_ imagePickerController:QBImagePickerController, descriptionForNumberOfVideos numberOfVideos:UInt)->String{
        return "共有%\(numberOfVideos)个视频";
    }
    
    open func imagePickerController(_ imagePickerController:QBImagePickerController, descriptionForNumberOfPhotos numberOfPhotos:UInt, numberOfVideos:UInt)->String{
        return "共有\(numberOfPhotos)张照片，\(numberOfVideos)个视频";
    }
    
    
    //MARK: video
    
    
    open func movieFinishedCallback(_ sender:AnyObject){
        let playerViewController = (sender as! Notification).object;
        //    playerViewController view
        //    [playerViewController removeFromParentViewController];
        (playerViewController as AnyObject).view.removeFromSuperview();
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object:nil);
        
        //    self.navigationController.navigationBar.hidden = FALSE;
    }
    
    @objc public func actionSheet(_ actionSheet:UIActionSheet, clickedButtonAt buttonIndex:Int){
        //    NSLog(@"index:%ld",buttonIndex);
        
        let title = actionSheet.buttonTitle(at: buttonIndex);
        
        //if (buttonIndex == 0 && _vedioUrl != nil) {
        if "播放" == title {
            
            //播放
            //NSURL * url = [NSURL URLWithString:@"http://i.feicuibaba.com/test.mp4"];
            
            let playerViewController = MPMoviePlayerViewController(contentURL:_vedioUrl);
            
            self.rootViewController?.addChildViewController(playerViewController!);
            
            NotificationCenter.default.addObserver(self, selector:#selector(self.movieFinishedCallback),
                                                             name:NSNotification.Name.MPMoviePlayerPlaybackDidFinish,
                                                             object:playerViewController?.moviePlayer);
            //-- add to view---
            self.rootViewController?.view.addSubview((playerViewController?.view)!);
            
            //playerViewController.view.frame = CGRectMake(20, 20, 200, 300);
            
            //playerViewController.
            
            //---play movie---
            let player = playerViewController?.moviePlayer;
            
            //player.contentURL = [NSURL URLWithString:@"http://i.feicuibaba.com/test.mp4"];
            
            player?.prepareToPlay();
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
            actionSheet.actionSheetStyle = UIActionSheetStyle.blackOpaque;
            actionSheet.show(in: self);
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
        
        camera.setResult({[weak self](file:URL?) in
            if (file == nil) {
                return ;
            }
            
            //        ImagesView * sself = wself;
            self?.vedioUrl = file;
        });
        self.viewController?.present(camera, animated:true, completion:nil);
        return;
    }
    
    private func setVedioImage(){
        
        
        
        //    let opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        //    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:_vedioUrl options:opts];
        let opts:[String : AnyObject]? = nil;
        
        let urlAsset = AVURLAsset(url: _vedioUrl!, options: opts);
        
        //    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
        let generator = AVAssetImageGenerator(asset: urlAsset);
        generator.appliesPreferredTrackTransform = true;
        generator.maximumSize = CGSize(width: 480, height: 480);
        //    NSError *error = nil;
        //    //CMTime * actualTime = [[CMTime alloc] init];
        //    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:&error];
        let img = try? generator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil);
        if let img = img {
            _vedioImage = UIImage(cgImage:img);
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
    
    public func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int)->Int{
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
    public func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath)->UICollectionViewCell{
        //    return [[ImagesViewUICollectionViewCell alloc] init];
        if ((indexPath as NSIndexPath).row == 0) {
            
            if (_cellVideo == nil) {
                _cellVideo = collectionView.dequeueReusableCell(withReuseIdentifier: "_ImagesViewAddVedioCollectionViewCell_", for:indexPath) as! ImagesViewAddVedioCollectionViewCell;
                
                _cellVideo.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.imageVideo)));
            }
            
            return _cellVideo;
        }
        
        if ((indexPath as NSIndexPath).row == _imagePaths.count + 1) {
            
            //        if (_cellImage == nil) {
            _cellImage = collectionView.dequeueReusableCell(withReuseIdentifier: "_ImagesViewAddImageCollectionViewCell_", for:indexPath);
            
            _cellImage.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.imagePacker)));
            //        }
            return _cellImage;
        }
        
        let CellIdentifier = "_ImagesViewUICollectionViewCell_";
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for:indexPath) as! ImagesViewUICollectionViewCell;
        
        //    int r = indexPath.row + 5;
        //    cell.backgroundColor = [UIColor colorWithRed:((10 * r) / 255.0) green:((20 * r)/255.0) blue:((30 * r)/255.0) alpha:1.0f];
        
        cell.image = _imagePaths[Int((indexPath as NSIndexPath).row - 1)];
        cell.pos = Int((indexPath as NSIndexPath).row - 1);
        cell.imagesView = self;
        return cell;
        
    }
    
    //MARK: view
    
    open override func layoutSubviews() {
        
        _flowLayout.itemSize = CGSize(width: self.bounds.size.width / 4 - 10, height: self.bounds.size.width / 4);
        self.resetLayout();
        super.layoutSubviews();
    }
    
    private func resetLayout(){
        
        let h = self.bounds.size.width / 4 + 10;
        
        let row = _imagePaths.count + 2;
        if _heightConstraint != nil {
            self.removeConstraint(_heightConstraint);
        }
        _heightConstraint = NSLayoutConstraint(item:self, attribute:NSLayoutAttribute.height, relatedBy:NSLayoutRelation.equal, toItem:nil, attribute:NSLayoutAttribute.notAnAttribute, multiplier:1.0, constant:h * CGFloat((row + 3) / 4));
        self.addConstraint(_heightConstraint);
    }
}


public class ImagesViewAddImageCollectionViewCell : UICollectionViewCell{
    fileprivate var _dashImageView:UIImageView!;
    
    public override init(frame:CGRect){
        super.init(frame:frame);
        
        self.initView();
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initView(){
        
        self.backgroundColor = UIColor.clear;
        
        _dashImageView = UIImageView();
        self.addSubview(_dashImageView);
        
        _dashImageView.frame = CGRect(x: 10, y: 5, width: self.bounds.size.width - 20, height: self.bounds.size.width-20);
        _dashImageView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue);
        
        
        let iconImage = FillImageView();
        
//        iconImage.setFillImage("LinCore.bundle/camera/camera_icon_image.png");
        iconImage.setFillImage(UIImage(named: "LinCore.bundle/camera/camera_icon_image.png", in: Bundle(for:self.classForCoder), compatibleWith: nil));
        
        iconImage.frame = CGRect(x: 15, y: 10, width: _dashImageView.frame.size.width - 10, height: _dashImageView.frame.size.width - 10);
        iconImage.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue);
        
        self.addSubview(iconImage);
        
        let label = LinUILabel();
        
        label.frame = CGRect(x: 0, y: self.bounds.size.height - 20, width: self.bounds.size.width, height: 18);
        
        label.font = UIFont(name:"STHeitiSC-Light", size:10);
        label.text = "图片(必选)";
        label.textColor = UIColor(red:0x7b/255.0, green:0x7b/255.0, blue:0x7b/255.0, alpha:1.0);
        label.textAlignment = NSTextAlignment.center;
        label.verticalAlignment = VerticalAlignmentMiddle;
        
        label.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue);
        
        self.addSubview(label);
        
        
        
        //虚线框 结束
    }
    
    public override func layoutSubviews() {
        
        super.layoutSubviews();
        
        
        let size = _dashImageView.bounds.size;
        
        UIGraphicsBeginImageContext(size);   //开始画线
        _dashImageView.image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height));
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round as CGLineCap);  //设置线条终点形状
        
        
        let lengths = [CGFloat(6),CGFloat(3)];
        let line = UIGraphicsGetCurrentContext();
        line?.setStrokeColor(UIColor.gray.cgColor);
        
        line?.setLineDash(phase: 0, lengths: lengths);  //画虚线
        
//        line?.moveTo(x: 0.0, y: 0.0);    //开始画线
        line?.move(to: CGPoint(x: 0.0, y: 0.0));
//        line?.addLineTo(x: size.width, y: 0.0);
        line?.addLine(to: CGPoint(x: size.width, y: 0.0));
        line?.addLine(to: CGPoint(x: size.width, y: size.height));
        line?.addLine(to: CGPoint(x: 0.0, y: size.height));
        line?.addLine(to: CGPoint(x: 0.0, y: 0.0));
        
        line?.strokePath();
        
        _dashImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
    }
}



open class ImagesViewAddVedioCollectionViewCell : UICollectionViewCell{
    fileprivate var _dashImageView:UIImageView!;
    fileprivate var _label:LinUILabel!;
    fileprivate var _imageView:FillImageView!;
    
    
    fileprivate func setVedioImage(_ image:UIImage?){
        if (_imageView.image == image) {
            return;
        }
        _imageView.image = image;
        if image == nil {
            _imageView.isHidden = true;
            _label.isHidden = false;
            _dashImageView.isHidden = false;
        }else{
            _imageView.isHidden = false;
            _label.isHidden = true;
            _dashImageView.isHidden = true;
        }
    }
    
    public override init(frame:CGRect){
        super.init(frame:frame);
        
        self.initView();
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initView(){
        
        self.backgroundColor = UIColor.clear;
        
        _dashImageView = UIImageView();
        self.addSubview(_dashImageView);
        
        _dashImageView.frame = CGRect(x: 10, y: 5, width: self.bounds.size.width - 20, height: self.bounds.size.width-20);
        _dashImageView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue);
        
        
        
        let iconImage = FillImageView();
        
        //iconImage.setFillImage("LinCore.bundle/camera/camera_icon_camera.png");
        iconImage.setFillImage(UIImage(named: "LinCore.bundle/camera/camera_icon_camera.png", in: Bundle(for:self.classForCoder), compatibleWith: nil));
        
        iconImage.frame = CGRect(x: 15, y: 10, width: _dashImageView.frame.size.width - 10, height: _dashImageView.frame.size.width - 10);
        iconImage.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue);
        
        self.addSubview(iconImage);
        
        
        _label = LinUILabel();
        
        _label.frame = CGRect(x: 0, y: self.bounds.size.height - 20, width: self.bounds.size.width, height: 18);
        
        _label.font = UIFont(name:"STHeitiSC-Light", size:10);
        _label.text = "视频(可选)";
        _label.textAlignment = NSTextAlignment.center;
        _label.verticalAlignment = VerticalAlignmentMiddle;
        _label.textColor = UIColor(red:0x7b/255.0, green:0x7b/255.0, blue:0x7b/255.0, alpha:1.0);
        
        _label.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue);
        
        self.addSubview(_label);
        
        _imageView = FillImageView();
        
        self.addSubview(_imageView);
        
        _imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height);
        
        _imageView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue);
        
        _imageView.isHidden = true;
        
        //虚线框 结束
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews();
        
        
        let size = _dashImageView.bounds.size;
        
        UIGraphicsBeginImageContext(size);   //开始画线
        _dashImageView.image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height));
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round);  //设置线条终点形状
        
        
        let lengths = [CGFloat(6),CGFloat(3)];
        let line = UIGraphicsGetCurrentContext();
        line?.setStrokeColor(UIColor.gray.cgColor);
        
        line?.setLineDash(phase: 0, lengths: lengths);  //画虚线
        line?.move(to: CGPoint(x: 0.0, y: 0.0));    //开始画线
        line?.addLine(to: CGPoint(x: size.width, y: 0.0));
        line?.addLine(to: CGPoint(x: size.width, y: size.height));
        line?.addLine(to: CGPoint(x: 0.0, y: size.height));
        line?.addLine(to: CGPoint(x: 0.0, y: 0.0));
        
        line?.strokePath();
        
        _dashImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
    }
}

class ImagesViewUICollectionViewCell : UICollectionViewCell{
    fileprivate var _imageView:FillImageView!;
    
    //@property NSObject * imagePath;
    
    //    private var image:AnyObject?;
    
//    private var fill:ImageFill = ImageFill.Fill;
    
    fileprivate var pos = 0;
    
    fileprivate var imagesView:ImagesView?;
    
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
    var fill:ImageFill = ImageFill.fill{
        didSet{
            _imageView.fill = fill;
        }
    }
    
    
    
    override init(frame:CGRect){
        super.init(frame:frame);
        
        //    if (self) {
        self.contentView.backgroundColor = UIColor.clear;
        
        _imageView = FillImageView();
        
        //        __weak ImagesViewUICollectionViewCell * wself = self;
        
        //        _imageView.imageChanged = ^{
        //            [wself update];
        //        };
        //        _imageView.backgroundColor = [UIColor greenColor];
        _imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height);
        _imageView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue);
        
        self.addSubview(_imageView);
        
        let minusImageView = UIImageView();
        
        minusImageView.image = UIImage(named:"LinCore.bundle/QBImagePickerController/minus.png", in: Bundle(for: self.classForCoder),compatibleWith: nil);
        minusImageView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.deleteImage)));
        minusImageView.isUserInteractionEnabled = true;
        self.addSubview(minusImageView);
        
        minusImageView.translatesAutoresizingMaskIntoConstraints = false;
        
        self.addConstraints([NSLayoutConstraint(item:minusImageView, attribute:NSLayoutAttribute.centerX, relatedBy:NSLayoutRelation.equal, toItem:self, attribute:NSLayoutAttribute.left, multiplier:1.0, constant:10.0),
            NSLayoutConstraint(item:minusImageView, attribute:NSLayoutAttribute.centerY, relatedBy:NSLayoutRelation.equal, toItem:self, attribute:NSLayoutAttribute.top, multiplier:1.0, constant:10.0)]);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal func deleteImage(_:AnyObject){
        self.imagesView!.delete(self.pos);
        
    }
    
}
