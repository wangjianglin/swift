//
//  ScrollImagesView.swift
//  seller
//
//  Created by lin on 12/28/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import MediaPlayer
import UIKit


private class LinImagesContentView : UIScrollView,UIScrollViewDelegate{
    
    fileprivate var _imagePath:String?;
    fileprivate var _imageView:CacheImageView!;
    
    fileprivate var _contentView:UIView!;
    fileprivate var _preImageSize = CGSize(width: 0, height: 0);
    fileprivate var _preViewSize = CGSize(width: 0, height: 0);
    fileprivate var _linImagesView:ScrollImagesView!;
    
    
    fileprivate init(imagePath:String, contentMode:UIViewContentMode, zoom:Bool, linImagesView:ScrollImagesView){
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        
        self._imagePath = imagePath;
        self.contentMode = contentMode;
        self.zoom = zoom;
        self._linImagesView = linImagesView;
        self.initView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    fileprivate var image:UIImage?{
        get{
            return self._imageView?.image;
        }
        set{
            self._imageView?.image = newValue;
        }
    }
    
    
    //    //缩放
    fileprivate var zoom:Bool = false{
        didSet{
            self.bouncesZoom = zoom;
            self.zoomScale = 1;
            self.minimumZoomScale = 1;
            self.maximumZoomScale = zoom ? 8 : 1;
        }
    }
    
    fileprivate func initView(){
        
        self.backgroundColor = UIColor.clear;
        _contentView = UIView();
        _contentView.backgroundColor = UIColor.clear;
        self.addSubview(_contentView);
        
        _imageView = CacheImageView();
        
        _imageView.imageChanged = {[weak self](_:CacheImageView)->() in
            self?.update();
        };
        _imageView?.path = self._imagePath;
        _imageView?.contentMode = self.contentMode;
        _imageView.translatesAutoresizingMaskIntoConstraints = false;
        _contentView.addSubview(_imageView);
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[image]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["image":_imageView]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[image]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["image":_imageView]));
        
        
        self.delegate = self;
        self.autoresizesSubviews = true;
        
        self.contentMode = UIViewContentMode.redraw;
        
        self.scrollsToTop = false;
        self.delaysContentTouches = false;
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
        self.contentMode = UIViewContentMode.redraw;
        self.isUserInteractionEnabled = true;
        self.autoresizesSubviews = false;
        self.zoomScale = 1;
        
    }
    
    fileprivate func update(){
        let contentViewRect = _contentView.bounds;
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
            contentViewRect2.size.width = self.bounds.size.width + 1;
            _contentView.frame = contentViewRect2;
            self.zoomScale = 1;
        }
    }
    
    fileprivate override func layoutSubviews() {
        self.update();
    }
}


open class ScrollImagesView:UIView,QBImagePickerControllerDelegate,UIScrollViewDelegate,UINavigationControllerDelegate{
    
    fileprivate var _isFullScreen = false;
    fileprivate var _fullScreenItem = 0;
    
    fileprivate var _addImages = [UIImageView]();
    fileprivate var _views = [UIView]();
    fileprivate var _positionLabelView:UIView!;
    fileprivate var _resetImagePaths = false;
    fileprivate var _noneImageLabels = [UILabel]();
    fileprivate var _scrollView:UIScrollView!;
    fileprivate var _currentItem = 0;
    fileprivate var _positionLabel:UILabel!;
    fileprivate var _playImageView:CacheImageView?;
    
    public var currentPos:Int{
        get{
            return _currentItem;
        }
        set{
            self.setCurrentItem(newValue);
        }
    }
    
    public init() {
        super.init(frame:CGRect(x: 0, y: 0, width: 0, height: 0));
        super.contentMode = UIViewContentMode.scaleAspectFit;
        self.initView();
        _resetImagePaths = true;
        self.showPositionLabel = true;
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    
    open var vedioImage:AnyObject?;
    
    open var edited = false{
        didSet{
            self.isUserInteractionEnabled = true;
            
            for item in _addImages {
                item.isHidden = !edited;
            }
        }
    }
    
    
    open var fullScreen = false{
        didSet{
            //            self.userInteractionEnabled = true;
        }
    }
    
    
    ////使图像填满
    open override var contentMode:UIViewContentMode{
        get{
            return super.contentMode;
        }
        set{
            super.contentMode = newValue;
            for item in _views {
                if item is LinImagesContentView {
                    (item as! LinImagesContentView).contentMode = self.contentMode;
                }
            }
        }
    }
    
    ////缩放
    open var zoom = false{
        didSet{
            for item in _views {
                if item is LinImagesContentView {
                    (item as! LinImagesContentView).zoom = self.zoom;
                }
            }
        }
    }
    
    open var showPositionLabel = false{
        didSet{
            self._positionLabelView.isHidden = !showPositionLabel;
        }
    }
    
    open var imageForEdited:[UIImage?]{
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
    
    dynamic var images:NSArray{
        let _images = NSMutableArray();
        for item in _views {
            if item is LinImagesContentView {
                if let image = (item as! LinImagesContentView)._imageView.image {
                    _images.add(image)
                }else{
                    _images.add(NSNull());
                }
            }
        }
        return _images;
    }
    
    fileprivate var _vedioURL:URL?;
    
    open var vedioUrl:URL?{
        get{ return _vedioURL;}
        set{ _vedioURL = newValue;self.resetVedioView();}
    }
    
    open var hasVedio:Bool = false{
        didSet{
            self.resetVedioView();
        }
    }
    
    open var imagePaths:[String]?{
        didSet{
            self.resetImageViews();
        }
    }
    
    fileprivate func resetVedioView(){
        if !hasVedio {
            
            if let playImageView = _playImageView {
                playImageView.removeFromSuperview();
                _views.remove(at: 0);
                _addImages.remove(at: 0);
                self.update();
            }
            return;
        }
        if _playImageView == nil {
            _playImageView = CacheImageView();
            _playImageView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100);
            _views.insert(_playImageView!, at:0);
            _scrollView.addSubview(_playImageView!);
            _playImageView?.setImageObj(self.vedioImage);
            _playImageView?.isUserInteractionEnabled = true;
            
            _playImageView?.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.playVedio)));
            
            let itemAddImage = UIImageView();
            _addImages.insert(itemAddImage, at:0);
            
            itemAddImage.image = UIImage(named:"LinCore.bundle/imagesEditAdd.png", in: Bundle(for:self.classForCoder), compatibleWith: nil);
            
            _scrollView.addSubview(itemAddImage);
            
            
            itemAddImage.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleBottomMargin.rawValue | UIViewAutoresizing.flexibleLeftMargin.rawValue | UIViewAutoresizing.flexibleTopMargin.rawValue | UIViewAutoresizing.flexibleRightMargin.rawValue);
            itemAddImage.frame = CGRect(x: 0, y: 0, width: 64, height: 64);
            itemAddImage.isHidden = !self.edited;
            
        }
        self.update();
        
    }
    
    @objc fileprivate func movieFinishedCallback(_ sender:AnyObject){
        let playerViewController = (sender as! Notification).object;
        
        if let playerViewController = playerViewController{
            if playerViewController is MPMoviePlayerController {
                (playerViewController as! MPMoviePlayerController).view.removeFromSuperview();
            }
        }
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object:nil);
        
    }
    
    @objc private func playVedio(_:AnyObject){
        let playerViewController = MPMoviePlayerViewController(contentURL:vedioUrl);
        
        self.rootViewController?.addChildViewController(playerViewController!);
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.movieFinishedCallback),
                                               name:NSNotification.Name.MPMoviePlayerPlaybackDidFinish,
                                               object:(playerViewController?.moviePlayer));
        //-- add to view---
        self.rootViewController?.view.addSubview((playerViewController?.view)!);
        
        
        //---play movie---
        let player = playerViewController?.moviePlayer;
        
        player?.play();
    }
    
    private func resetImageViews(){
        if _resetImagePaths == false {
            return;
        }
        for item in _views {
            item.removeFromSuperview();
        }
        for item in _noneImageLabels {
            item.removeFromSuperview();
        }
        for item in _addImages {
            item.removeFromSuperview();
        }
        
        _views.removeAll();
        _noneImageLabels.removeAll();
        _addImages.removeAll();
        
        
        if let playImageView = _playImageView {
            _views.append(playImageView);
            playImageView.isHidden = true;
            _scrollView.addSubview(playImageView);
            
            let itemAddImage = UIImageView();
            _addImages.append(itemAddImage);
            _scrollView.addSubview(itemAddImage);
            itemAddImage.frame = CGRect(x: 0, y: 0, width: 60, height: 60);
            itemAddImage.isHidden = !self.edited;
            
            
        }
        
        
        if let imagePaths = self.imagePaths {
            
            var itemView:LinImagesContentView!;
            for n in 0 ..< imagePaths.count {
                itemView = LinImagesContentView(imagePath:imagePaths[n], contentMode:self.contentMode, zoom:self.zoom, linImagesView:self);
                itemView.backgroundColor = UIColor.clear;
                _scrollView.addSubview(itemView);
                _views.append(itemView);
                
                let itemAddImage = UIImageView();
                _addImages.append(itemAddImage);
                itemAddImage.image = UIImage(named:"LinCore.bundle/imagesEditAdd.png", in: Bundle(for:self.classForCoder), compatibleWith: nil);
                _scrollView.addSubview(itemAddImage);
                
                itemAddImage.frame = CGRect(x: 0, y: 0, width: 60, height: 60);
                itemAddImage.isHidden = !self.edited;
                itemAddImage.tag = n;
                
                let itemNoneImageLabel = UILabel();
                _noneImageLabels.append(itemNoneImageLabel);
                itemNoneImageLabel.text = "没有图像";
                itemNoneImageLabel.textAlignment = NSTextAlignment.center;
                itemNoneImageLabel.frame = CGRect(x: 0, y: 0, width: 160, height: 60);
                itemNoneImageLabel.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleTopMargin.rawValue | UIViewAutoresizing.flexibleBottomMargin.rawValue);
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
        
        self.isUserInteractionEnabled = true;
        
        _scrollView = UIScrollView();
        self.backgroundColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0);
        _scrollView.backgroundColor = UIColor.clear;
        _scrollView.autoresizesSubviews = true;
        _scrollView.contentMode = UIViewContentMode.redraw;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.scrollsToTop = false;
        _scrollView.delaysContentTouches = false;
        _scrollView.isPagingEnabled = true;
        _scrollView.bouncesZoom = false;
        _scrollView.zoomScale = 1;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 1;
        _scrollView.delegate = self;
        self.addSubview(_scrollView);
        _scrollView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height);
        _scrollView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue);
        
        _positionLabelView = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: 40));
        _positionLabelView.isUserInteractionEnabled = false;
        _positionLabelView.isHidden = !self.showPositionLabel;
        _positionLabelView.backgroundColor = UIColor.clear;
        self.addSubview(_positionLabelView);
        
        _positionLabel = UILabel();
        _positionLabel.font = UIFont(name:"STHeitiSC-Light", size:14.0);
        _positionLabel.textAlignment = NSTextAlignment.center;
        _positionLabel.backgroundColor = UIColor.clear;
        
        let pathFrame = CGRect(x: 0, y: 0, width: 40, height: 40);
        let path = UIBezierPath(roundedRect:pathFrame, cornerRadius:20);
        
        let circleShape = CAShapeLayer();
        circleShape.path = path.cgPath;
        circleShape.position = CGPoint(x: 0, y: 0);
        circleShape.fillColor = UIColor(red:0.5, green:0.5, blue:0.5, alpha:0.85).cgColor;
        circleShape.strokeColor = UIColor.clear.cgColor;
        circleShape.lineWidth = 1.0;
        
        _positionLabelView.layer.addSublayer(circleShape);
        _positionLabelView.addSubview(_positionLabel);
        _positionLabel.frame = CGRect(x: _positionLabelView.bounds.origin.x, y: _positionLabelView.bounds.origin.y, width: _positionLabelView.bounds.size.width, height: _positionLabelView.bounds.size.height);
        _positionLabel.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleHeight.rawValue | UIViewAutoresizing.flexibleWidth.rawValue);
        
        self.addGestureRecognizer(UITapGestureRecognizer(action:{[weak self](sender:AnyObject) in
            self?.addImageTap();
        }));
        
        self.isUserInteractionEnabled = true;
    }
    
    private func update(){
        self.isUserInteractionEnabled = true;
        let rect = self.bounds;
        if rect.size.width == 0 || rect.size.height == 0 {
            return;
        }
        
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
            
            itemAddImage.isHidden = !self.edited;
            
            if _playImageView != nil && n == 0 {
                itemAddImage.isHidden = false;
                if (self.edited) {
                    itemAddImage.image = UIImage(named:"LinCore.bundle/imagesEditAdd.png",in: Bundle(for: self.classForCoder),compatibleWith: nil);
                }else{
                    itemAddImage.image = UIImage(named:"LinCore.bundle/play.png",in: Bundle(for: self.classForCoder),compatibleWith: nil);
                }
            }
            
            var itemAddImageRect = itemAddImage.bounds;
            itemAddImageRect.origin.x = rect.size.width * CGFloat(n) + (rect.size.width - itemAddImageRect.size.width ) / 2;
            itemAddImageRect.origin.y = (rect.size.height - itemAddImageRect.size.height) / 2.0;
            itemAddImage.frame = itemAddImageRect;
            
            _scrollView.bringSubview(toFront: itemAddImage);
            
            if _views[n] is LinImagesContentView {
                
                imageItemN += 1;
                
                let imageItme = _views[n] as! LinImagesContentView;
                
                _noneImageLabels[imageItemN].isHidden = imageItme._imagePath != nil || self.edited;
            }
        }
        _scrollView.contentSize = CGSize(width: rect.size.width * CGFloat(_views.count), height: rect.size.height);
        var offsetX = _scrollView.contentOffset;
        offsetX.x = rect.size.width * CGFloat(self._currentItem);
        _scrollView.contentOffset = offsetX;
        
        var positionLabelRect = CGRect(x: 0, y: 0, width: 40, height: 40);
        positionLabelRect.origin.x = rect.size.width - 40 - rect.size.width * 0.05;
        positionLabelRect.origin.y = rect.size.height * 0.05;
        _positionLabelView.frame = positionLabelRect;
        
        self.setCurrentItem(self._currentItem);
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews();
        self.update();
    }
    
    private func addImageTap(){
        if (self.edited) {
            
            if hasVedio && _currentItem == 0 {
                
                let camera = CameraViewController();
                camera.setResult({[weak self] (url) in
                    self?._vedioURL = url;
                })
                self.viewController?.present(camera, animated: true, completion: nil);
                return;
            }
            
            let imagePickerController = QBImagePickerController();
            imagePickerController.delegate = self;
            imagePickerController.filterType = QBImagePickerFilterTypeAllPhotos;
            var maxSelection:UInt = 0;
            
            for n in 0..<_views.count {
                
                if n == _currentItem {
                    maxSelection += 1;
                    continue;
                }
                if _views[n] is LinImagesContentView{
                    let litem = _views[n] as! LinImagesContentView;
                    if litem.image == nil{
                        maxSelection += 1;
                    }
                }
            }
            
            
            imagePickerController.maximumNumberOfSelection = maxSelection;
            imagePickerController.allowsMultipleSelection = maxSelection > 1;
            imagePickerController.limitsMaximumNumberOfSelection = true;
            
            let navigationController = UINavigationController(rootViewController: imagePickerController);
            
            self.viewController?.present(navigationController, animated: true, completion: nil);
            
        }else {
            if self._isFullScreen {//退出全屏
                
                self.viewController?.dismiss(animated: true, completion:nil);
            }else if self.fullScreen {//进入全屏
                
                
                let fullScreenView = ScrollImagesView();
                
                fullScreenView.edited = false;
                fullScreenView.contentMode = .scaleAspectFit;
                fullScreenView.zoom = true;
                fullScreenView.fullScreen = false;
                fullScreenView.imagePaths = self.imagePaths;
                
                fullScreenView._isFullScreen = true;
                fullScreenView._fullScreenItem = self._currentItem;
                
                fullScreenView.showPositionLabel = false;
                
                
                fullScreenView.backgroundColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0);
                
                let fullScreenController = UIViewController();
                
                fullScreenController.view.addSubview(fullScreenView);
                fullScreenView.frame = CGRect(x: 0, y: 0, width: fullScreenController.view.bounds.size.width, height: fullScreenController.view.bounds.size.height);
                fullScreenView.autoresizingMask = UIViewAutoresizing(rawValue:UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue);
                
                self.viewController?.present(fullScreenController, animated:true, completion:nil);
            }
        }
    }
    
    private func setCurrentItem(_ currentItem:Int){
        if _views.count > 0 {
            _positionLabel.text = "\(currentItem+1)/\(_views.count)";
            if _views[currentItem] is UIScrollView {
                (_views[currentItem] as! UIScrollView).zoomScale = 1.0;
                (_views[currentItem] as! UIScrollView).zoomScale = 1.0;
            }
        }else{
            _positionLabel.text = "0/0";
        }
        self._currentItem = currentItem;
        
        var point = _scrollView.contentOffset;
        point.x = self.bounds.size.width * CGFloat(currentItem);
        _scrollView.contentOffset = point;
    }
    
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let contentOffsetX = scrollView.contentOffset.x;
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
    
    
    @nonobjc public func imagePickerController(_ imagePickerController: QBImagePickerController, didFinishPickingMediaWithInfo info: AnyObject!) {
        
        self.willChangeValue(forKey: "images")
        
        if imagePickerController.allowsMultipleSelection {
            let mediaInfoArray = info as! [NSDictionary];
            var start = _currentItem;
            for item in mediaInfoArray {
                while !(_views[start % _views.count] is LinImagesContentView)
                    || (_views[start % _views.count] as! LinImagesContentView).image == nil
                {
                    start += 1;
                }
                let image = item["UIImagePickerControllerOriginalImage"] as! UIImage?;
                (_views[start % _views.count] as! LinImagesContentView).image = image;
                (_views[start % _views.count] as! LinImagesContentView).tag = 2;
                start + 1;
            }
        }else{
            let item = info as! NSDictionary;
            let image = item["UIImagePickerControllerOriginalImage"] as! UIImage?;
            (_views[_currentItem] as! LinImagesContentView).image = image;
            (_views[_currentItem] as! LinImagesContentView).tag = 2;
        }
        imagePickerController.dismiss(animated: true, completion: nil);
        
        self.didChangeValue(forKey: "images")
    }
    
    public func imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        imagePickerController.dismiss(animated: true, completion: nil);
    }
    
    @objc public func description(forSelectingAllAssets imagePickerController: QBImagePickerController!) -> String! {
        return "选择所有";
    }
    
    @objc public func description(forDeselectingAllAssets imagePickerController: QBImagePickerController!) -> String! {
        return "取消所有选择";
    }
    
    @objc public func imagePickerController(_ imagePickerController: QBImagePickerController!, descriptionForNumberOfPhotos numberOfPhotos: UInt) -> String! {
        return "共有\(numberOfPhotos)张照片";
    }
    
    @objc public func imagePickerController(_ imagePickerController: QBImagePickerController!, descriptionForNumberOfVideos numberOfVideos: UInt) -> String! {
        return "共有\(numberOfVideos)个视频"
    }
    
    
    @objc public func imagePickerController(_ imagePickerController: QBImagePickerController!, descriptionForNumberOfPhotos numberOfPhotos: UInt, numberOfVideos: UInt) -> String! {
        return "共有\(numberOfPhotos)张照片，\(numberOfVideos)个视频";
    }
}
