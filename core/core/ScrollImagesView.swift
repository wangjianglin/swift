//
//  LinImagesController.m
//  seller
//
//  Created by lin on 12/28/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import MediaPlayer
import UIKit

//int LinImagesViewFullScreenCurrentItem = 0;
//BOOL isLinImagesViewFullScreen = FALSE;
//LinImagesView * preLinImagesView;
//LinImagesController * fullScreenController;



//@interface LinImagesController (){
//@public
//    BOOL _isFullScreen;
//    int _fullScreenItem;
//@private
//    LinImagesView * _imageView;
//    BOOL _edited;
//    NSArray * _imagePaths;
//    BOOL _fullScreen;
//    //    BOOL _isFullScreen;
//    BOOL _showPositionLabel;
//    LinImagesFill _fill;
//    BOOL _zoom;
//    NSString * _noImage;
//    NSURL * _vedioUrl;
//    BOOL _hasVedio;
//}

//-(void)setImageView:(LinImagesVi ew*)imageView;
//@end

private class LinImagesContentView : UIScrollView,UIScrollViewDelegate{
    //    @package
    private var _imagePath:String?;
    private var _imageView:CacheImageView!;
    private var fill:ImageFill = ImageFill.Default;
    //    private var _zoom = false;
    private var _contentView:UIView!;
    private var _preImageSize = CGSizeMake(0, 0);
    private var _preViewSize = CGSizeMake(0, 0);
    private var _linImagesView:ScrollImagesView!;
    
    
    private init(imagePath:String, fill:ImageFill, zoom:Bool, linImagesView:ScrollImagesView){
        
        //@property UIImage * image;
        ////
        ////    //使图像填满
        //@property ImageFill fill;
        ////
        ////    //缩放
        //@property BOOL zoom;
        //
        //@end
        
        
        
        //@implementation LinImagesContentView
        //
        //-(id)initWithImagePath:(NSString *)imagePath fill:(ImageFill)fill zoom:(BOOL)zoom linImagesView:(ScrollImagesView*)linImagesView{
        //    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
        super.init(frame: CGRectMake(0, 0, 0, 0));
        
        self._imagePath = imagePath;
        self.fill = fill;
        self.zoom = zoom;
        self._linImagesView = linImagesView;
        self.initView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var image:UIImage?{
        get{
            return self._imageView?.image;
        }
        set{
            self._imageView?.image = newValue;
        }
    }
    //    //使图像填满
    //-(ImageFill)fill{
    //    return self->_fill;
    //}
    //-(void)setFill:(ImageFill)fill{
    //    self->_fill = fill;
    //}
    
    //    //缩放
    private var zoom:Bool = false{
        didSet{
            //    self->_zoom = zoom;
            self.bouncesZoom = zoom;
            self.zoomScale = 1;
            self.minimumZoomScale = 1;
            self.maximumZoomScale = zoom ? 8 : 1;
        }
    }
    
    
    @objc private func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return _contentView;
    }
    
    private func initView(){
        //    __weak LinImagesContentView * wself = self;
        
        //    self.backgroundColor = [UIColor grayColor];
        self.backgroundColor = UIColor.clearColor();
        _contentView = UIView(frame:CGRectMake(0, 0, 200, 200));
        //    contentView.backgroundColor = [[UIColor alloc] initWithRed:0.72 green:0.72 blue:0.72 alpha:1.0];
        _contentView.backgroundColor = UIColor.clearColor();
        self.addSubview(_contentView);
        
        _imageView = CacheImageView();
        //    _imageView?.noImage = self._linImagesView.noImage;
        _imageView.imageChanged = {[weak self](_:CacheImageView)->() in
            self?.update();
        };
        _imageView?.path = self._imagePath;
        
        _contentView.addSubview(_imageView);
        self.delegate = self;
        self.autoresizesSubviews = true;
        //    self.userInteractionEnabled = FALSE;
        self.contentMode = UIViewContentMode.Redraw;
        
        self.scrollsToTop = false;
        self.delaysContentTouches = false;
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
        self.contentMode = UIViewContentMode.Redraw;
        self.userInteractionEnabled = true;
        self.autoresizesSubviews = false;
    }
    
    private func update(){
        var contentViewRect = _contentView.bounds;
        if self.bounds.size.width == 0 || self.bounds.size.height == 0 {
            return;
        }
        if _imageView.image == nil {
            return;
        }
        if (contentViewRect.size.height != self.bounds.size.height ||
            contentViewRect.size.width != self.bounds.size.width) {
            var contentViewRect2 = _contentView.bounds;
            contentViewRect2.size.height = self.bounds.size.height;
            contentViewRect2.size.width = self.bounds.size.width;
            _contentView.frame = contentViewRect2;
            self.zoomScale = 1;
        }
        let imageSize = _imageView.image?.size ?? CGSizeMake(0, 0);
        if imageSize.width != _preImageSize.width || imageSize.height != _preImageSize.height
            || self.bounds.size.width != _preViewSize.width || self.bounds.size.height != _preViewSize.height
        {
            _preImageSize = imageSize;
            _preViewSize = self.bounds.size;
            contentViewRect = _contentView.bounds;
            var s:CGFloat = 1.0;
            if self.fill != ImageFill.Fill {
                s = (_preImageSize.width * 1.0 / _preImageSize.height)/(self.bounds.size.width * 1.0 / self.bounds.size.height);
            }
            if (ImageFill.Default == self.fill && s > 1) || self.fill == ImageFill.Width {
                contentViewRect.size.width = self.bounds.size.width;
                contentViewRect.size.height = self.bounds.size.height / s;
                contentViewRect.origin.x = 0;
                contentViewRect.origin.y = (self.bounds.size.height - contentViewRect.size.height) / 2;
            }else{
                contentViewRect.size.width = self.bounds.size.width * s;
                contentViewRect.size.height = self.bounds.size.height;
                contentViewRect.origin.y = 0;
                contentViewRect.origin.x = (self.bounds.size.width - contentViewRect.size.width) / 2;
            }
            _imageView.frame = contentViewRect;
            self.zoomScale = 1;
        }
    }
    
    private override func layoutSubviews() {
        self.update();
    }
}


public class ScrollImagesView:UIView,QBImagePickerControllerDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //    @public
    private var _isFullScreen = false;
    private var _fullScreenItem = 0;
    
    //    @private
    //    private var _edited = false;
    private var _fill = ImageFill.Default;
    //    private var _zoom = false;
    //    private var _showPositionLabel = false;
    //    private var _fullScreen = false;
    private var _addImages = [UIImageView]();
    private var _views = [UIView]();
    private var _positionLabelView:UIView!;
    private var _resetImagePaths = false;
    //    private var _imagePaths = [String]();
    //    private var _vedioUrl:NSURL?;
//    private var _hasVedio = false;
    private var _noneImageLabels = [UILabel]();
    private var _scrollView:UIScrollView!;
    private var _currentItem = 0;
    private var _positionLabel:UILabel!;
    //    MPMoviePlayerController * player;
    private var _playImageView:FillImageView?;
    
    //}
    //@end
    //
    //@implementation ScrollImagesView
    
    public init() {
        //    self = [super init];
        //    if (self) {
        super.init(frame:CGRectMake(0, 0, 0, 0));
        self.initView();
        _resetImagePaths = true;
        self.showPositionLabel = true;
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public var vedioImage:AnyObject?;
    
    public var edited = false{
        didSet{
            self.userInteractionEnabled = true;
            //    NSLog(@"userInteractionEnabled:%d",self.userInteractionEnabled);
            //    NSLog(@"controller:%@",self->_controller);
            //            if let addImages = _addImages {
            for item in _addImages {
                item.hidden = !edited;
            }
        }
    }
    
    
    //-(BOOL)edited{
    //    return self->_edited;
    //}
    //-(void)setEdited:(BOOL)edited{
    //    self->_edited = edited;
    ////    self.userInteractionEnabled = self->_edited || self->_fullScreen;
    ////    self.userInteractionEnabled = (self->_edited || self->_fullScreen || self->_isFullScreen);
    //    self.userInteractionEnabled = TRUE;
    ////    NSLog(@"userInteractionEnabled:%d",self.userInteractionEnabled);
    ////    NSLog(@"controller:%@",self->_controller);
    //    if (addImages != nil) {
    //        for (UIView * item in addImages) {
    //            item.hidden = !edited;
    //        }
    //    }
    //}
    
    public var fullScreen = false{
        didSet{
//            self.userInteractionEnabled = true;
        }
    }
    //-(BOOL)fullScreen{
    //    return _fullScreen;
    //}
    //
    //-(void)setFullScreen:(BOOL)fullScreen{
    //    _fullScreen = fullScreen;
    ////    self.userInteractionEnabled = self->_edited || self->_fullScreen;
    ////     self.userInteractionEnabled = (self->_edited || self->_fullScreen || self->_isFullScreen);
    //    self.userInteractionEnabled = TRUE;
    ////    NSLog(@"userInteractionEnabled:%d",self.userInteractionEnabled);
    //}
    
    ////使图像填满
    public var fill = ImageFill.Default{
        didSet{
            for item in _views {
                if item is LinImagesContentView {
                    (item as! LinImagesContentView).fill = self.fill;
                }
            }
        }
    }
    //    return _fill;
    //}
    //-(void)setFill:(ImageFill)fill{
    //    _fill = fill;
    //    if (views != nil) {
    //        for (LinImagesContentView * item in views) {
    //            item.fill = self.fill;
    //        }
    //    }
    //}
    ////缩放
    public var zoom = false{
        didSet{
            for item in _views {
                if item is LinImagesContentView {
                    (item as! LinImagesContentView).zoom = self.zoom;
                }
            }
        }
    }
    //-(BOOL)zoom{
    //    return _zoom;
    //}
    //-(void)setZoom:(BOOL)zoom{
    //    _zoom = zoom;
    //    if (views != nil) {
    //        for (LinImagesContentView * item in views) {
    //            item.zoom = zoom;
    //        }
    //    }
    //}
    //
    ////是否显示位置标记
    //-(BOOL)showPositionLabel{
    //    return _showPositionLabel;
    //}
    //-(void)setShowPositionLabel:(BOOL)showPositionLabel{
    //    _showPositionLabel = showPositionLabel;
    //    positionLabelView.hidden = !showPositionLabel;
    //}
    public var showPositionLabel = false{
        didSet{
            self._positionLabelView.hidden = !showPositionLabel;
        }
    }
    
    public var imageForEdited:[UIImage?]{
        var images = [UIImage?]();
        for item in _views {
            if item is LinImagesContentView {
                if item.tag == 2 {
                    images.append((item as! LinImagesContentView).image);
                }else{
                    images.append(nil);
                }
            }
        }
        return images;
    }
    //-(NSArray *)imagesForEdited{
    //    NSMutableArray * images = [[NSMutableArray alloc] init];
    //    if (views!=nil) {
    //        for (LinImagesContentView * item in views) {
    //            if (item.tag == 2) {
    //                [images addObject:item.image];
    //            }else{
    //                [images addObject:[NSNull null]];
    //            }
    //        }
    //    }
    //    return images;
    //}
    
    public var images:[UIImage?]{
        var images = [UIImage?]();
        for item in _views {
            if item is LinImagesContentView {
                images.append((item as! LinImagesContentView)._imageView.image);
            }
        }
        return images;
    }
    //-(NSArray *)images{
    //    NSMutableArray * images = [[NSMutableArray alloc] init];
    //
    //    if (views != nil) {
    //        for (LinImagesContentView * item in views) {
    //            if (item->imageView.image == nil) {
    //                [images addObject:[NSNull null]];
    //            }else{
    //                [images addObject:item->imageView.image];
    //            }
    //        }
    //    }
    //
    //    return  images;
    //}
    
    //-(NSURL *)vedioUrl{
    //    return _vedioUrl;
    //}
    //
    //-(void)setVedioUrl:(NSURL*)vedioUrl{
    //    _vedioUrl = vedioUrl;
    //    [self resetVedioView];
    //}
    public var vedioUrl:NSURL?{
        didSet{
            self.resetVedioView();
        }
    }
    
    public var hasVedio:Bool = false{
        didSet{
            self.resetVedioView();
        }
    }
    
    //-(BOOL)hasVedio{
    //    return _hasVedio;
    //}
    //-(void)setHasVedio:(BOOL)hasVedio{
    //    _hasVedio = hasVedio;
    //    [self resetVedioView];
    //}
    //-(NSArray *)imagePaths{
    //    return _imagePaths;
    //}
    //-(void)setImagePaths:(NSArray *)imagePaths{
    //    _imagePaths = imagePaths;
    //    [self resetImageViews];
    //}
    public var imagePaths:[String]?{
        didSet{
            self.resetImageViews();
        }
    }
    
    private func resetVedioView(){
        if !hasVedio {
            
            //if (views != nil && views.count > 0 && [NSStringFromClass([views[0] class]) isEqualToString:@"MPMovieView"] ){
            if let playImageView = _playImageView {
                playImageView.removeFromSuperview();
                //            [views removeObjectAtIndex:0];
                _views.removeAtIndex(0);
                //            [addImages removeObjectAtIndex:0];
                _addImages.removeAtIndex(0);
                self.update();
            }
            return;
        }
        //    if (views == nil) {
        //        views = [[NSMutableArray alloc] init];
        //    }
        //if (views == nil && [views[0] isKindOfClass:[MPMovieView Class]]) {
        if _playImageView == nil {
            //        player = [[MPMoviePlayerController alloc] initWithContentURL:nil];
            //
            //        //player.view.frame = CGRectMake(20, 20, 200, 300);
            //        player.controlStyle = MPMovieControlStyleDefault;
            //        //player.moviewControlMode = MPMovieControlModeDefault;
            //
            //        //[views addObject:player.view];
            //        player.view.backgroundColor = [UIColor clearColor];
            
            _playImageView = FillImageView();
            _playImageView?.frame = CGRectMake(0, 0, 100, 100);
            //        [views insertObject:player.view atIndex:0];
            //        [scrollView addSubview:player.view];
            _views.insert(_playImageView!, atIndex:0);
            _scrollView.addSubview(_playImageView!);
            //        _playImageView?.image = self.vedioImage;
            _playImageView?.setFillImage(self.vedioImage);
            //        _playImageView.image = [UIImage imageNamed:@"LinCore.bundle/camera/camera_icon_camera_add.png"];;
            
            _playImageView?.userInteractionEnabled = true;
            
            _playImageView?.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.playVedio)));
            
            let itemAddImage = UIImageView();
            //[addImages addObject:itemAddImage];
            _addImages.insert(itemAddImage, atIndex:0);
            itemAddImage.image = UIImage(named:"LinCore.bundle/camera/camera_icon_camera_add.png");
            
            _scrollView.addSubview(itemAddImage);
            
            
            itemAddImage.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleBottomMargin.rawValue | UIViewAutoresizing.FlexibleLeftMargin.rawValue | UIViewAutoresizing.FlexibleTopMargin.rawValue | UIViewAutoresizing.FlexibleRightMargin.rawValue);
            itemAddImage.frame = CGRectMake(0, 0, 64, 64);
            itemAddImage.hidden = !self.edited;
            
            
        }
        //    player.contentURL = _vedioUrl;
        self.update();
        
    }
    
    @objc private func movieFinishedCallback(sender:AnyObject){
        let playerViewController = (sender as! NSNotification).object;
        //    playerViewController view
        //    [playerViewController removeFromParentViewController];
        if let playerViewController = playerViewController{
            if playerViewController is MPMoviePlayerController {
                (playerViewController as! MPMoviePlayerController).view.removeFromSuperview();
            }
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:MPMoviePlayerPlaybackDidFinishNotification, object:nil);
        
        //    self.navigationController.navigationBar.hidden = FALSE;
    }
    
    @objc private func playVedio(_:AnyObject){
        let playerViewController = MPMoviePlayerViewController(contentURL:vedioUrl);
        
        //    MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] init];
        
        self.rootViewController?.addChildViewController(playerViewController);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(self.movieFinishedCallback),
                                                         name:MPMoviePlayerPlaybackDidFinishNotification,
                                                         object:(playerViewController.moviePlayer));
        //-- add to view---
        self.rootViewController?.view.addSubview(playerViewController.view);
        
        //playerViewController.view.frame = CGRectMake(20, 20, 200, 300);
        
        //playerViewController.
        
        //---play movie---
        let player = playerViewController.moviePlayer;
        
        //player.contentURL = [NSURL URLWithString:@"http://i.feicuibaba.com/test.mp4"];
        //    player.contentURL = _vedioUrl;
        
        //    [player prepareToPlay];
        player.play();
    }
    
    private func resetImageViews(){
        if _resetImagePaths == false {
            return;
        }
        //    if (views != nil) {
        for item in _views {
            item.removeFromSuperview();
        }
        //    }
        
        //    if _noneImageLabels {
        for item in _noneImageLabels {
            item.removeFromSuperview();
        }
        //    }
        
        //    if addImages != nil) {
        for item in _addImages {
            item.removeFromSuperview();
        }
        //    }
        
        _views.removeAll();// = [[NSMutableArray alloc] init];
        _noneImageLabels.removeAll();// = [[NSMutableArray alloc] init];
        _addImages.removeAll();// = [[NSMutableArray alloc] init];
        
        
        if let playImageView = _playImageView {
            //        [views addObject:player.view];
            //        [scrollView addSubview:player.view];
            _views.append(playImageView);
            playImageView.hidden = true;
            _scrollView.addSubview(playImageView);
            
            let itemAddImage = UIImageView();
            _addImages.append(itemAddImage);
            _scrollView.addSubview(itemAddImage);
            //        itemAddImage.image = [UIImage imageNamed:@"LinCore.bundle/camera/camera_icon_camera_add.png"];
            
//            itemAddImage.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleBottomMargin.rawValue | UIViewAutoresizing.FlexibleLeftMargin.rawValue | UIViewAutoresizing.FlexibleTopMargin.rawValue | UIViewAutoresizing.FlexibleRightMargin.rawValue);
            itemAddImage.frame = CGRectMake(0, 0, 60, 60);
            itemAddImage.hidden = !self.edited;
            
            
        }
        
        
        if let imagePaths = self.imagePaths {
            
            var itemView:LinImagesContentView!;
            for n in 0 ..< imagePaths.count {
                itemView = LinImagesContentView(imagePath:imagePaths[n], fill:self.fill, zoom:self.zoom, linImagesView:self);
                //        itemView.backgroundColor = [[UIColor alloc] initWithRed:0.72 green:0.72 blue:0.72 alpha:1.0];
                itemView.backgroundColor = UIColor.clearColor();
                _scrollView.addSubview(itemView);
                _views.append(itemView);
                
                let itemAddImage = UIImageView();
                _addImages.append(itemAddImage);
                itemAddImage.image = UIImage(named:"resources.bundle/publish/imagesEditAdd.png");
                _scrollView.addSubview(itemAddImage);
//                itemAddImage.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleBottomMargin.rawValue | UIViewAutoresizing.FlexibleLeftMargin.rawValue | UIViewAutoresizing.FlexibleTopMargin.rawValue | UIViewAutoresizing.FlexibleRightMargin.rawValue);
                itemAddImage.frame = CGRectMake(0, 0, 60, 60);
                itemAddImage.hidden = !self.edited;
                itemAddImage.tag = n;
                
                let itemNoneImageLabel = UILabel();
                _noneImageLabels.append(itemNoneImageLabel);
                itemNoneImageLabel.text = "没有图像";
                itemNoneImageLabel.textAlignment = NSTextAlignment.Center;
                itemNoneImageLabel.frame = CGRectMake(0, 0, 160, 60);
                itemNoneImageLabel.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleWidth.rawValue | UIViewAutoresizing.FlexibleTopMargin.rawValue | UIViewAutoresizing.FlexibleBottomMargin.rawValue);
                _scrollView.addSubview(itemNoneImageLabel);
            }
        }
        if self.fullScreen {
            self.setCurrentItem(self._fullScreenItem);
        }else{
            self.setCurrentItem(0);
        }
        self.update();
    }
    
    private func initView(){
        
        self.userInteractionEnabled = true;
        
        //    __weak ScrollImagesView * wself = self;
        _scrollView = UIScrollView();
        self.backgroundColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0);
        _scrollView.backgroundColor = UIColor.clearColor();
        _scrollView.autoresizesSubviews = true;
        _scrollView.contentMode = UIViewContentMode.Redraw;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.scrollsToTop = false;
        _scrollView.delaysContentTouches = false;
        _scrollView.pagingEnabled = true;
        _scrollView.bouncesZoom = false;
        _scrollView.zoomScale = 1;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 1;
        _scrollView.delegate = self;
        self.addSubview(_scrollView);
        _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _scrollView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleWidth.rawValue | UIViewAutoresizing.FlexibleHeight.rawValue);
        
        _positionLabelView = UIView(frame:CGRectMake(0, 0, 40, 40));
        _positionLabelView.userInteractionEnabled = false;
        _positionLabelView.hidden = !self.showPositionLabel;
        _positionLabelView.backgroundColor = UIColor.clearColor();
        self.addSubview(_positionLabelView);
        
        _positionLabel = UILabel();
        _positionLabel.font = UIFont(name:"STHeitiSC-Light", size:14.0);
        _positionLabel.textAlignment = NSTextAlignment.Center;
        _positionLabel.backgroundColor = UIColor.clearColor();
        
        let pathFrame = CGRectMake(0, 0, 40, 40);
        let path = UIBezierPath(roundedRect:pathFrame, cornerRadius:20);
        
        let circleShape = CAShapeLayer();
        circleShape.path = path.CGPath;
        circleShape.position = CGPointMake(0, 0);
        circleShape.fillColor = UIColor(red:0.5, green:0.5, blue:0.5, alpha:0.85).CGColor;
        circleShape.strokeColor = UIColor.clearColor().CGColor;
        circleShape.lineWidth = 1.0;
        
        _positionLabelView.layer.addSublayer(circleShape);
        _positionLabelView.addSubview(_positionLabel);
        //    positionLabelView.backgroundColor = [UIColor redColor];
        _positionLabel.frame = CGRectMake(_positionLabelView.bounds.origin.x, _positionLabelView.bounds.origin.y, _positionLabelView.bounds.size.width, _positionLabelView.bounds.size.height);
        _positionLabel.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleHeight.rawValue | UIViewAutoresizing.FlexibleWidth.rawValue);
        
        self.addGestureRecognizer(UITapGestureRecognizer(action:{[weak self](sender:AnyObject) in
            self?.addImageTap();
            }));
        //    self.userInteractionEnabled = FALSE;
        //     self.userInteractionEnabled = (self->_edited || self->_fullScreen || self->_isFullScreen);
        self.userInteractionEnabled = true;
        //    NSLog(@"userInteractionEnabled:%d",self.userInteractionEnabled);
    }
    
    private func update(){
        //    self.userInteractionEnabled = (self->_edited || self->_fullScreen || self->_isFullScreen) && self->_controller;
        self.userInteractionEnabled = true;
        let rect = self.bounds;
        if rect.size.width == 0 || rect.size.height == 0 {
            return;
        }
        
        //    LinImagesContentView * imageItme;
        //    UIView * item;
        var imageItemN = -1;
        for n in 0 ..< _views.count {
            
            let item = _views[n];
            
            var itemRect = item.bounds;
            if itemRect.size.width == 0 {
                itemRect.origin.x = rect.size.width * CGFloat(n);
            }else{
                itemRect.origin.x = rect.size.width * CGFloat(n) + itemRect.origin.x / itemRect.size.width * rect.size.width;
            }
            
            itemRect.size.width = rect.size.width;
            itemRect.size.height = rect.size.height;
            item.frame = itemRect;
            
            
            let itemAddImage = _addImages[n];
            
            itemAddImage.hidden = !self.edited;
            
            if _playImageView != nil && n == 0 {
                itemAddImage.hidden = false;
                if (self.edited) {
                    itemAddImage.image = UIImage(named:"LinCore.bundle/imagesEditAdd.png");
                }else{
                    itemAddImage.image = UIImage(named:"LinCore.bundle/play.png");
                }
            }
            
            var itemAddImageRect = itemAddImage.bounds;
            itemAddImageRect.origin.x = rect.size.width * CGFloat(n) + (rect.size.width - itemAddImageRect.size.width ) / 2;
            itemAddImageRect.origin.y = (rect.size.height - itemAddImageRect.size.height) / 2.0;
            itemAddImage.frame = itemAddImageRect;
            
            _scrollView.bringSubviewToFront(itemAddImage);
            
            if _views[n] is LinImagesContentView {
                
                imageItemN += 1;
                
                let imageItme = _views[n] as! LinImagesContentView;
                
                _noneImageLabels[imageItemN].hidden = imageItme._imagePath != nil || self.edited;
            }
        }
        _scrollView.contentSize = CGSizeMake(rect.size.width * CGFloat(_views.count), rect.size.height);
        var offsetX = _scrollView.contentOffset;
        offsetX.x = rect.size.width * CGFloat(self._currentItem);
        _scrollView.contentOffset = offsetX;
        
        var positionLabelRect = CGRectMake(0, 0, 40, 40);
        positionLabelRect.origin.x = rect.size.width - 40 - rect.size.width * 0.05;
        positionLabelRect.origin.y = rect.size.height * 0.05;
        _positionLabelView.frame = positionLabelRect;
        
        self.setCurrentItem(self._currentItem);
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews();
        self.update();
    }
    
    private func addImageTap(){
        if (self.edited) {
            
            if hasVedio && _currentItem == 0 {
                
                //            __weak ScrollImagesView * wself = self;
                //            let camera = CameraViewController();
                //CameraViewController
                //self dismissViewControllerAnimated:<#(BOOL)#> completion:<#^(void)completion#>
                //[self presentViewController:]
                //            [camera setResult:^(NSURL *file) {
                //                NSLog(@"file:%@",file);
                ////                player.contentURL = file;
                ////                [player play];
                //                ScrollImagesView * w = wself;
                //                w->_vedioUrl = file;
                //            }];
                //            [self.viewController presentViewController:camera animated:TRUE completion:nil];
                //            return;
            }
            //        int videoCount = _hasVedio?1:0;
            //        int index = _currentItem - videoCount;
            //
            //        QBImagePickerController * imagePickerController = [[QBImagePickerController alloc] init];
            //        imagePickerController.delegate = self;
            //        imagePickerController.filterType = QBImagePickerFilterTypeAllPhotos;
            //        imagePickerController.allowsMultipleSelection = TRUE;
            //        uint maxSelection = 0;
            ////        for (NSObject * item in self.imagePaths) {
            //        NSObject * item = nil;
            //        for (int n=0; n<self.imagePaths.count; n++) {
            //            item = self.imagePaths[n];
            //            if ((item == nil || [item isKindOfClass:[NSNull class]]) && [views[n+videoCount] isKindOfClass:[LinImagesContentView class]] &&
            //                ((LinImagesContentView*)views[n+videoCount]).image == nil
            //                //&&
            //                //(((LinImagesContentView*)views[n])->_imagePath == nil || [((LinImagesContentView*)views[n])->_imagePath isKindOfClass:[NSNull class]])
            //                ) {
            //                maxSelection++;
            //            }
            //        }
            //        if ((self.imagePaths[index] != nil && ![self.imagePaths[index] isKindOfClass:[NSNull class]])
            //            || ((LinImagesContentView*)views[_currentItem]).image != nil)
            //             {
            //            maxSelection++;
            //        }
            //        imagePickerController.maximumNumberOfSelection = maxSelection;
            //        imagePickerController.limitsMaximumNumberOfSelection = TRUE;
            //        UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
            //        [self.viewController presentViewController:navigationController animated:TRUE completion:nil];
            
        }else {
            if self._isFullScreen {//退出全屏
                //            isLinImagesViewFullScreen = FALSE;
                //            [preLinImagesView setCurrentItem:[self currentItem]];
                self.viewController?.dismissViewControllerAnimated(true, completion:nil);
            }else if self.fullScreen {//进入全屏
                //            LinImagesViewFullScreenCurrentItem = [self currentItem];
                //            isLinImagesViewFullScreen = TRUE;
                
                //            preLinImagesView = self;
                
                let fullScreenView = ScrollImagesView();
                //            fullScreenController = [[LinImagesController alloc] init];
                
                //            LinImagesView * fullImagesView = [[LinImagesView alloc] init];
                fullScreenView.edited = false;
                fullScreenView.fill = ImageFill.Default;
                fullScreenView.zoom = true;
                fullScreenView.fullScreen = false;
                fullScreenView.imagePaths = self.imagePaths;
                //            fullScreenView.noImage = self.noImage;
                fullScreenView._isFullScreen = true;
                fullScreenView._fullScreenItem = self._currentItem;
                //            fullImagesView.controller = fullScreenController;
                fullScreenView.showPositionLabel = false;
                
                //            [fullScreenController setImageView:fullImagesView];
                fullScreenView.backgroundColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0);
                
                let fullScreenController = UIViewController();
                
                fullScreenController.view.addSubview(fullScreenView);
                fullScreenView.frame = CGRectMake(0, 0, fullScreenController.view.bounds.size.width, fullScreenController.view.bounds.size.height);
                fullScreenView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.FlexibleWidth.rawValue | UIViewAutoresizing.FlexibleHeight.rawValue);
                
                self.viewController?.presentViewController(fullScreenController, animated:true, completion:nil);
            }
        }
    }
    
    //-(int)currentItem{
    //    return _currentItem;
    //}
    private func setCurrentItem(currentItem:Int){
        //    if (views != nil) {
        if _views.count > 0 {
            _positionLabel.text = "\(currentItem+1)/\(_views.count)";
            if _views[currentItem] is UIScrollView {
                (_views[currentItem] as! UIScrollView).zoomScale = 1.0;
                (_views[currentItem] as! UIScrollView).zoomScale = 1.0;
            }
        }else{
            _positionLabel.text = "0/0";
        }
        //    }
        self._currentItem = currentItem;
        
        var point = _scrollView.contentOffset;
        point.x = self.bounds.size.width * CGFloat(currentItem);
        _scrollView.contentOffset = point;
    }
    
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let contentOffsetX = scrollView.contentOffset.x;
        //    if (views != nil) {
        //        UIView * item;
        for n in 0 ..< _views.count {
            let item = _views[n];
            let tmp = item.frame.origin.x - contentOffsetX;
            let w = item.frame.size.width / 2 - 10;
            if tmp > -w && tmp < w {
                self.setCurrentItem(n);
                break;
            }
        }
    }
    
    
    //- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info{
    //
    //    if (imagePickerController.allowsMultipleSelection) {
    //        NSArray * mediaInfoArray = (NSArray*)info;
    //        int start = [self currentItem];
    //        for (NSDictionary * item in mediaInfoArray) {
    //            while (!([views[start % views.count] isKindOfClass:[LinImagesContentView class]]) || (
    //                   ((LinImagesContentView*)views[start % views.count]).image != nil &&
    //                   ![((LinImagesContentView*)views[start % views.count]).image isKindOfClass:[NSNull class]] && start != [self currentItem]))
    //            {
    //                start++;
    //            }
    //            UIImage * image = (UIImage*)(item[@"UIImagePickerControllerOriginalImage"]);
    //            ((LinImagesContentView*)views[start%views.count]).image = image;
    //            ((LinImagesContentView*)views[start%views.count]).tag = 2;
    //            start++;
    //        }
    //    }
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
    //-(NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos{
    //    return [[NSString alloc] initWithFormat:@"共有%lu张照片",(unsigned long)numberOfPhotos];
    //}
    //
    //-(NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos{
    //    return [[NSString alloc] initWithFormat:@"共有%lu个视频",(unsigned long)numberOfVideos];
    //}
    //
    //- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos{
    //    return [[NSString alloc] initWithFormat:@"共有%lu张照片，%lu个视频",(unsigned long)numberOfPhotos,(unsigned long)numberOfVideos];
    //}
    
    
}


//@implementation LinImagesController
//
////-(void)setFullScreenStatus:(BOOL)fullScreenStatus{
////    _isFullScreen = fullScreenStatus;
////    imageView->_isFullScreen = fullScreenStatus;
////}
//-(BOOL)edited{
//    if(_imageView){
//        return _imageView.edited;
//    }
//    return _edited;
//}
//-(void)setEdited:(BOOL)edited{
//    _edited = edited;
//    [_imageView setEdited:edited];
//}
//
//-(NSArray *)imagesForEdited{
//    return [_imageView imagesForEdited];
//}
//
//-(NSArray *)images{
//    if(_imageView){
//        return _imageView.images;
//    }
//    return nil;
//}
//-(NSURL *)vedioUrl{
//    if (_imageView) {
//        return _imageView.vedioUrl;
//    }
//    return _vedioUrl;
//}
//
//-(void)setVedioUrl:(NSURL*)vedioUrl{
//    if (_imageView) {
//        _imageView.vedioUrl = vedioUrl;
//    }
//    _vedioUrl = vedioUrl;
//}
//
//-(BOOL)hasVedio{
//    if (_imageView) {
//        return _imageView.hasVedio;
//    }
//    return _hasVedio;
//}
//-(void)setHasVedio:(BOOL)hasVedio{
//    if (_imageView) {
//        _imageView.hasVedio = hasVedio;
//    }
//    _hasVedio = hasVedio;
//}
//
//-(NSArray *)imagePaths{
//    if (_imageView != nil) {
//        return [_imageView imagePaths];
//    }
//    return _imagePaths;
//}
//-(void)setImagePaths:(NSArray *)imagePaths{
//    [_imageView setImagePaths:imagePaths];
//    self->_imagePaths = imagePaths;
//}
//
////    //是否可以全屏
//-(BOOL)fullScreen{
//    if(_imageView){
//        return _imageView.fullScreen;
//    }
//    return _fullScreen;
//}
//-(void)setFullScreen:(BOOL)fullScreen{
//    [_imageView setFullScreen:fullScreen];
//    _fullScreen = fullScreen;
//}
////
////    //使图像填满
//-(LinImagesFill)fill{
//    if(_imageView){
//        return _imageView.fill;
//    }
//    return _fill;
//}
//-(void)setFill:(LinImagesFill)fill{
//    _fill = fill;
//    [_imageView setFill:fill];
//}
////    //缩放
//-(BOOL)zoom{
//    if(_imageView){
//        return _imageView.zoom;
//    }
//    return _zoom;
//}
//-(void)setZoom:(BOOL)zoom{
//    _zoom = zoom;
//    [_imageView setZoom:zoom];
//}
////    
////    //是否显示位置标记
//-(BOOL)showPositionLabel{
//    if(_imageView){
//        return _imageView.showPositionLabel;
//    }
//    return _showPositionLabel;
//}
//-(void)setShowPositionLabel:(BOOL)showPositionLabel{
//    _showPositionLabel = showPositionLabel;
//    [_imageView setShowPositionLabel:showPositionLabel];
//}
//
//-(NSString *)noImage{
//    if(_imageView){
//        return _imageView.noImage;
//    }
//    return _noImage;
//}
//-(void)setNoImage:(NSString *)noImage{
//    self->_noImage = noImage;
//    [_imageView setNoImage:noImage];
//}
//
////-(void)loadView{
////    imageView = [[LinImagesView alloc] init];
////    self.view = imageView;
////}
//
//
//-(void)setImageView:(LinImagesView*)imageView{
//    self->_imageView = imageView;
//}
//-(void)viewDidLoad{
//    [super viewDidLoad];
//
//    if(_imageView){
//        _imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [self.view addSubview:_imageView];
//        return;
//    }
//    _imageView = [[LinImagesView alloc] init];
//    _imageView.controller = self;
//    _imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _imageView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_imageView];
//
//    _imageView->_isFullScreen = self->_isFullScreen;
//    _imageView->_fullScreenItem = self->_fullScreenItem;
//    _imageView.edited = self->_edited;
//    _imageView.fill =self->_fill;
//    _imageView.zoom = self->_zoom;
//    _imageView.fullScreen = self->_fullScreen;
//    _imageView.showPositionLabel = self->_showPositionLabel;
//    _imageView.noImage = self->_noImage;
//    _imageView.imagePaths = _imagePaths;
//    _imageView.vedioUrl = _vedioUrl;
//    _imageView.hasVedio = _hasVedio;
//    
//}
//
//@end
